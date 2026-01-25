Vector role
=========

1. Роль устанавливает и настраивает Vector (инструмент для работы с логами и метриками):
2. Создаёт директории для установки и конфигурации Vector
3. Скачивает бинарный архив Vector с официального сайта
4. Распаковывает архив в директорию установки
5. Создаёт симлинк бинарника в системный путь (/usr/local/bin/)
6. Настраивает systemd-сервис для управления Vector
7. Разворачивает конфигурационный файл Vector
8. Запускает и включает автозагрузку сервиса Vector

Role Variables
--------------

| vars               | description       |
|--------------------|-------------------|
| vector_version     | Install version   |
| vector_install_dir | Directory install |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: vector_role }

License
-------

MIT

Author Information
------------------

Roman Khurmatov
