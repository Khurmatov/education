## Задача 1

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: ```{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}```
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);
- скачайте образ nginx:1.29.0;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП).
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

## Ответ

https://hub.docker.com/repository/docker/khurmatov94/custom-nginx/general

## Задача 2
1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:
- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080
2. Не удаляя, переименуйте контейнер в "custom-nginx-t2"
3. Выполните команду ```date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html```
4. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.

## Ответ

<img width="1533" height="589" alt="Задача 2" src="https://github.com/user-attachments/assets/ffff799d-68f1-4866-bce8-414496eb1c3b" />

## Задача 3
1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
3. Выполните ```docker ps -a``` и объясните своими словами почему контейнер остановился.
4. Перезапустите контейнер
5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
8. Запомните(!) и выполните команду ```nginx -s reload```, а затем внутри контейнера ```curl http://127.0.0.1:80 ; curl http://127.0.0.1:81```.
9. Выйдите из контейнера, набрав в консоли  ```exit``` или Ctrl-D.
10. Проверьте вывод команд: ```ss -tlpn | grep 127.0.0.1:8080``` , ```docker port custom-nginx-t2```, ```curl http://127.0.0.1:8080```. Кратко объясните суть возникшей проблемы.
11. * Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)
12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

## Ответ

п.1 - п.3
<img width="998" height="306" alt="Задача 3 1" src="https://github.com/user-attachments/assets/40570d5f-8dde-458d-a345-534da254a996" />

Комбинация клавиш Ctrl-C передает контейнеру сигнал SIGINT, и контейнер останавливается, так как завершается его процесс.

п.4 - п.5

<img width="692" height="96" alt="Задача 3 2" src="https://github.com/user-attachments/assets/7d1d7f52-8067-4a2f-a03c-f9624601f419" />

п.6
<img width="1287" height="764" alt="Задача 3 4" src="https://github.com/user-attachments/assets/772fe9c7-4f0e-47cf-9bae-639407629caf" />

п.7
<img width="616" height="780" alt="Задача 3 5" src="https://github.com/user-attachments/assets/9d592e3e-7d82-4d7c-b717-35397330d84e" />

п.8 - п.9

<img width="711" height="238" alt="Задача 3 6" src="https://github.com/user-attachments/assets/980ca10a-d5d4-4ffb-9f47-158aab9a34ae" />

п.10

<img width="652" height="122" alt="Задача 3 7" src="https://github.com/user-attachments/assets/f26b2399-b457-4332-8071-cbd3c55b444d" />

Мы поменяли порт, который слуашает nginx, а сопостовление портов запущенного контейнера и хост машины оставили как есть.

п.12
<img width="1352" height="195" alt="Задача 3 8" src="https://github.com/user-attachments/assets/abf4622e-952d-4ca3-9a3e-bd2cce1e0a9f" />

## Задача 4

- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку  текущий рабочий каталог ```$(pwd)``` на хостовой машине в ```/data``` контейнера, используя ключ -v.
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив текущий рабочий каталог ```$(pwd)``` в ```/data``` контейнера.
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.
- Добавьте ещё один файл в текущий каталог ```$(pwd)``` на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

## Ответ

п.1
<img width="1095" height="347" alt="Задача 4 1" src="https://github.com/user-attachments/assets/ca70df5b-116d-4e10-8782-98d7e74b741c" />

п.2

<img width="957" height="245" alt="Задача 4 2" src="https://github.com/user-attachments/assets/3bfcd51a-e39a-4cf8-b9a0-ce3fb0f56a35" />

п.3 - п.5
<img width="1098" height="1028" alt="Задача 4 4" src="https://github.com/user-attachments/assets/4f913d2d-3821-45a6-9328-98431ec3b7e7" />

## Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
"compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

## Ответ

п.1
<img width="1372" height="432" alt="Задача 5 1" src="https://github.com/user-attachments/assets/091590c8-74d0-4123-b81a-b51ada944bc4" />

По умолчанию путь к файлу Compose: compose.yaml (предпочтительный) или compose.yml. Compose также поддерживает docker-compose.yaml и docker-compose.yml для обеспечения обратной совместимости с более ранними версиями. Если в рабочем каталоге оба файла, Compose предпочитает compose.yaml.

п.2
<img width="1652" height="692" alt="Задача 5 2" src="https://github.com/user-attachments/assets/55cce55e-6c04-481d-82b0-a41dac0c6a7c" />

п.3
<img width="1216" height="628" alt="Задача 5 3" src="https://github.com/user-attachments/assets/afa0f2a7-ec41-4df9-a32e-05f764de2f2d" />
<img width="897" height="592" alt="Задача 5 4" src="https://github.com/user-attachments/assets/16f0689f-948f-4d83-82cb-c11682688f57" />

п.4
<img width="1802" height="967" alt="Задача 5 5" src="https://github.com/user-attachments/assets/37118485-a84d-46ea-859e-47b486065a05" />

п.5
<img width="1858" height="997" alt="Задача 5 6" src="https://github.com/user-attachments/assets/76dd961e-6207-48ba-9516-dddc63475dc3" />

п.6
<img width="1778" height="765" alt="Задача 5 7" src="https://github.com/user-attachments/assets/04f93beb-f79f-4f23-98c4-ec5cae494aa1" />
<img width="1798" height="587" alt="Задача 5 8" src="https://github.com/user-attachments/assets/7770c58b-f1a9-4680-996f-61fbf29c8003" />

п.7
<img width="1847" height="492" alt="Задача 5 9" src="https://github.com/user-attachments/assets/71c7ee77-d13b-4724-bd3d-3e476a8a27f5" />
После выполнения команды появилось предупреждение ```Found orphan containers ([task_5-registry-1]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.```, которое говорит о том, что найдены контейнеры, которые не описаны в файле. Для их очистки нужно выполнить ту же команду(```docker compose up -d```) с флагом --remove-orphans.
