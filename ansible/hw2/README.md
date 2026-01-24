# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Приложите ссылку на ваше решение в поле "Ссылка на решение" и нажмите "Отправить решение"

## Ответы к основной части

1. Подготовьте свой inventory-файл `prod.yml`.
```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: 89.169.172.148
vector:
  hosts:
    vector-01:
      ansible_host: 158.160.75.97
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
```
- name: Install Vector
  hosts: vector
  vars_files:
    - vector/vars.yml
  handlers:
    - name: Restart vector
      become: true
      ansible.builtin.systemd:
        name: vector
        state: restarted
  tasks:
    - name: Download Vector archive
      become: true
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-gnu.tar.gz"
        dest: "/tmp/vector-{{ vector_version }}.tar.gz"
        timeout: 30
        mode: '0644'

    - name: Extract Vector to installation directory
      become: true
      ansible.builtin.unarchive:
        src: "/tmp/vector-{{ vector_version }}.tar.gz"
        dest: "{{ vector_install_dir }}"
        remote_src: true
        creates: "{{ vector_install_dir }}/vector-{{ vector_version }}/bin/vector"

    - name: Install Vector binary
      become: true
      ansible.builtin.file:
        src: "{{ vector_install_dir }}/vector-{{ vector_version }}/bin/vector"
        dest: "{{ vector_bin_path }}"
        state: link
        force: true
        mode: '0755'

    - name: Deploy Vector configuration
      become: true
      ansible.builtin.template:
        src: vector.yml.j2
        dest: "{{ vector_config_dir }}/vector.yml"
        mode: '0644'
      notify: Restart vector
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
![1.png](images/1.png)
![2.png](images/2.png)

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.







---
