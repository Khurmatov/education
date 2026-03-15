from os import getenv
from flask import Flask, request, make_response, jsonify
from prometheus_flask_exporter import PrometheusMetrics, NO_PREFIX
from passlib.hash import pbkdf2_sha256
import jwt
import datetime
import uuid

server = Flask(__name__)
metrics = PrometheusMetrics(server, defaults_prefix=NO_PREFIX, buckets=[0.1, 0.5, 1, 1.5, 2], default_labels={"app_name": "security"})
metrics.info('app_info', 'Application info', version='1.0')

jwt_key = 'secret'
users_db = {
    'bob': {
        'password': pbkdf2_sha256.hash('qwe123'),
        'id': str(uuid.uuid4())
    }
}

@server.route('/status', methods=['GET'])
def status():
    return {'status': 'OK'}

@server.route('/v1/user', methods=['POST'])
def register():
    """Регистрация нового пользователя"""
    req = request.get_json()
    if not req or 'login' not in req or 'password' not in req:
        return jsonify({'error': 'Login and password required'}), 400

    login = req['login']
    password = req['password']

    if login in users_db:
        return jsonify({'error': 'User already exists'}), 409

    user_id = str(uuid.uuid4())
    users_db[login] = {
        'password': pbkdf2_sha256.hash(password),
        'id': user_id
    }

    return jsonify({
        'id': user_id,
        'login': login,
        'message': 'User created successfully'
    }), 201

@server.route('/v1/user', methods=['GET'])
def get_user():
    """Получение информации о пользователе"""
    auth_header = request.headers.get('Authorization')
    if not auth_header or not auth_header.startswith('Bearer '):
        return jsonify({'error': 'Invalid authorization header'}), 401

    token = auth_header.split(' ')[1]

    try:
        payload = jwt.decode(token, jwt_key, algorithms=['HS256'])
        login = payload.get('sub')

        if login not in users_db:
            return jsonify({'error': 'User not found'}), 404

        return jsonify({
            'id': users_db[login]['id'],
            'login': login
        }), 200

    except jwt.ExpiredSignatureError:
        return jsonify({'error': 'Token expired'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'error': 'Invalid token'}), 401

@server.route('/v1/token', methods=['POST'])
def login():
    """Получение JWT токена"""
    req = request.get_json()
    if not req or 'login' not in req or 'password' not in req:
        return jsonify({'error': 'Login and password required'}), 400

    login = req['login']
    password = req['password']

    if login not in users_db or not pbkdf2_sha256.verify(password, users_db[login]['password']):
        return jsonify({'error': 'Invalid credentials'}), 401

    payload = {
        'sub': login,
        'iat': datetime.datetime.utcnow(),
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }

    token = jwt.encode(payload, jwt_key, algorithm='HS256')

    return jsonify({
        'access_token': token,
        'token_type': 'Bearer',
        'expires_in': 3600
    }), 200

@server.route('/v1/token/validation', methods=['GET'])
def validate():
    """Валидация токена"""
    auth_header = request.headers.get('Authorization')
    if not auth_header or not auth_header.startswith('Bearer '):
        return jsonify({'error': 'Invalid authorization header'}), 401

    token = auth_header.split(' ')[1]

    try:
        jwt.decode(token, jwt_key, algorithms=['HS256'])
        return '', 200
    except jwt.ExpiredSignatureError:
        return jsonify({'error': 'Token expired'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'error': 'Invalid token'}), 401

if __name__ == '__main__':
    port = int(getenv('PORT', 3000))
    server.run(host='0.0.0.0', port=port, debug=False)