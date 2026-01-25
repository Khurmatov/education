Lighthouse role
=========

1. Роль устанавливает и настраивает LightHouse (веб-интерфейс для ClickHouse):
2. Устанавливает EPEL-репозиторий (только для RedHat/CentOS)
3. Устанавливает Nginx как веб-сервер
4. Создаёт директорию для файлов LightHouse
5. Скачивает архив со статикой LightHouse
6. Распаковывает архив во временную директорию
7. Копирует веб-файлы из docs/ в целевую директорию
8. Настраивает Nginx для обслуживания LightHouse
9. Запускает и включает Nginx

Role Variables
--------------

| vars                   | description       |
|------------------------|-------------------|
| Lighthouse_version     | Install version   |
| ---------------        | ---------------   |
| lighthouse_install_dir | Directory install |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: lighthouse_role }

License
-------

MIT

Author Information
------------------

Roman Khurmatov