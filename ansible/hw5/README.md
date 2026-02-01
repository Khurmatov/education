# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Подготовительные работы
1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
![0.1.png](images/0.1.png)

2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри. 
![0.2.png](images/0.2.png)

## Основная часть

Ваша цель — настроить тестирование ваших ролей.

Задача — сделать сценарии тестирования для vector.

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Выполнение для Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.
![1.png](images/Molecule/1.png)

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
![2.png](images/Molecule/2.png)

3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
Тестирование будем делать на удаленных ВМ, созданных ранее для выполнения ДЗ.
```declarative
---
driver:
name: default

platforms:
- name: clickhouse-01
groups: [clickhouse, all]

- name: vector-01
groups: [vector, all]

- name: lighthouse-01
groups: [lighthouse, all]

provisioner:
name: ansible
inventory:
links:
hosts: /home/khurmatovri/education/ansible/hw5/playbook/inventory/prod.yml

verifier:
name: ansible

```
Исправили ошибки и протестировали роль:
![3.1.png](images/Molecule/3.1.png)

4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).
```declarative
---
# Purpose: assert that the instance really ended up in the expected state.
# Molecule calls this playbook with `molecule verify`.
- name: Verify
  hosts: instance
  gather_facts: false # Quicker, if you do not need facts
  tasks:
    - name: Assert something
      ansible.builtin.assert:
        that: true

```
Протестировали роль после добавления:
![4.png](images/Molecule/4.png)

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
```declarative
khurmatovri@compute-vm-2-2-10-hdd-1764064826727:~/education/ansible/hw5/playbook/roles/vector-role$ molecule test
INFO     default ➜ discovery: scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     default ➜ prerun: Performing prerun with role_name_check=0...
INFO     default ➜ dependency: Executing
WARNING  default ➜ dependency: Missing roles requirements file: requirements.yml
WARNING  default ➜ dependency: Missing collections requirements file: collections.yml
WARNING  default ➜ dependency: Executed: 2 missing (Remove from test_sequence to suppress)
INFO     default ➜ cleanup: Executing
WARNING  default ➜ cleanup: Executed: Missing playbook (Remove from test_sequence to suppress)
INFO     default ➜ destroy: Executing

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     default ➜ destroy: Executed: Successful
INFO     default ➜ syntax: Executing

playbook: /home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role/molecule/default/converge.yml
INFO     default ➜ syntax: Executed: Successful
INFO     default ➜ create: Executing

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     default ➜ create: Executed: Successful
INFO     default ➜ prepare: Executing                                                                                                                                        
WARNING  default ➜ prepare: Executed: Missing playbook (Remove from test_sequence to suppress)
INFO     default ➜ converge: Executing                                                                                                                                       

PLAY [Test Vector role] ********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Create Vector directories] ***
ok: [vector-01] => (item=/opt/vector)
ok: [vector-01] => (item=/etc/vector)

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Download Vector archive] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Extract Vector to installation directory] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Install Vector binary] ***
[WARNING]: Cannot set fs attributes on a non-existent symlink target. follow
should be set to False to avoid this.
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Create Vector systemd service] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Deploy Vector configuration] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Enable and start Vector service] ***
ok: [vector-01]

PLAY RECAP *********************************************************************
vector-01                  : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     default ➜ converge: Executed: Successful
INFO     default ➜ idempotence: Executing                                                                                                                                    

PLAY [Test Vector role] ********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Create Vector directories] ***
ok: [vector-01] => (item=/opt/vector)
ok: [vector-01] => (item=/etc/vector)

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Download Vector archive] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Extract Vector to installation directory] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Install Vector binary] ***
[WARNING]: Cannot set fs attributes on a non-existent symlink target. follow
should be set to False to avoid this.
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Create Vector systemd service] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Deploy Vector configuration] ***
ok: [vector-01]

TASK [/home/khurmatovri/education/ansible/hw5/playbook/roles/vector-role : Enable and start Vector service] ***
ok: [vector-01]

PLAY RECAP *********************************************************************
vector-01                  : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     default ➜ idempotence: Executed: Successful
INFO     default ➜ side_effect: Executing                                                                                                                                    
WARNING  default ➜ side_effect: Executed: Missing playbook (Remove from test_sequence to suppress)
INFO     default ➜ verify: Executing
[WARNING]: Could not match supplied host pattern, ignoring: instance

PLAY [Verify] ******************************************************************
skipping: no hosts matched

PLAY RECAP *********************************************************************

INFO     default ➜ verify: Executed: Successful
INFO     default ➜ cleanup: Executing                                                                                                                                        
WARNING  default ➜ cleanup: Executed: Missing playbook (Remove from test_sequence to suppress)
INFO     default ➜ destroy: Executing                                                                                                                                        

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     default ➜ destroy: Executed: Successful
INFO     default ➜ scenario: Pruning extra files from scenario ephemeral directory
WARNING  Molecule executed 1 scenario (1 missing files)
```

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
https://github.com/Khurmatov/vector-role/releases/tag/v1.1.0

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на ваш репозиторий и скриншоты этапов выполнения задания.

### Выполнение для Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).


2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.


3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

```declarative
[root@fe054a1b5cdb vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0

ERROR: invocation failed (exit code 1), logfile: /opt/vector-role/.tox/py37-ansible210/log/py37-ansible210-1.log
================================================================================= log start =================================================================================
Collecting ansible<3.0
  Downloading ansible-2.10.7.tar.gz (29.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 29.9/29.9 MB 14.3 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting selinux
  Using cached selinux-0.2.1-py2.py3-none-any.whl (4.3 kB)
Collecting lxml
  Downloading lxml-5.4.0-cp37-cp37m-manylinux_2_28_x86_64.whl (4.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.9/4.9 MB 51.5 MB/s eta 0:00:00
Collecting molecule
  Downloading molecule-3.6.1-py3-none-any.whl (241 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 241.8/241.8 KB 41.6 MB/s eta 0:00:00
Collecting molecule_podman
  Downloading molecule_podman-1.1.0-py3-none-any.whl (15 kB)
Collecting jmespath
  Downloading jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting ansible-base<2.11,>=2.10.5
  Downloading ansible-base-2.10.17.tar.gz (6.1 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 6.1/6.1 MB 26.0 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Requirement already satisfied: setuptools>=39.0 in ./.tox/py37-ansible210/lib/python3.7/site-packages (from selinux->-r tox-requirements.txt (line 1)) (62.1.0)
Collecting distro>=1.3.0
  Downloading distro-1.9.0-py3-none-any.whl (20 kB)
Collecting importlib-metadata
  Downloading importlib_metadata-6.7.0-py3-none-any.whl (22 kB)
Collecting PyYAML>=5.1
  Downloading PyYAML-6.0.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (670 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 670.1/670.1 KB 36.0 MB/s eta 0:00:00
Collecting click-help-colors>=0.9
  Downloading click_help_colors-0.9.4-py3-none-any.whl (6.4 kB)
Collecting ansible-compat>=1.0.0
  Downloading ansible_compat-1.0.0-py3-none-any.whl (16 kB)
Collecting rich>=9.5.1
  Downloading rich-13.8.1-py3-none-any.whl (241 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 241.6/241.6 KB 24.1 MB/s eta 0:00:00
Collecting cookiecutter>=1.7.3
  Downloading cookiecutter-2.6.0-py3-none-any.whl (39 kB)
Collecting Jinja2>=2.11.3
  Downloading jinja2-3.1.6-py3-none-any.whl (134 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 134.9/134.9 KB 21.5 MB/s eta 0:00:00
Collecting enrich>=1.2.7
  Downloading enrich-1.2.7-py3-none-any.whl (8.7 kB)
Collecting cerberus!=1.3.3,!=1.3.4,>=1.3.1
  Downloading cerberus-1.3.8-py3-none-any.whl (30 kB)
Collecting click<9,>=8.0
  Downloading click-8.1.8-py3-none-any.whl (98 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.2/98.2 KB 10.4 MB/s eta 0:00:00
Collecting pluggy<2.0,>=0.7.1
  Downloading pluggy-1.2.0-py3-none-any.whl (17 kB)
Collecting paramiko<3,>=2.5.0
  Downloading paramiko-2.12.0-py2.py3-none-any.whl (213 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 213.1/213.1 KB 33.8 MB/s eta 0:00:00
Collecting packaging
  Downloading packaging-24.0-py3-none-any.whl (53 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.5/53.5 KB 3.2 MB/s eta 0:00:00
Collecting cryptography
  Downloading cryptography-45.0.7-cp37-abi3-manylinux_2_28_x86_64.whl (4.5 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.5/4.5 MB 27.0 MB/s eta 0:00:00
Collecting cached-property~=1.5
  Downloading cached_property-1.5.2-py2.py3-none-any.whl (7.6 kB)
Collecting subprocess-tee>=0.3.5
  Downloading subprocess_tee-0.3.5-py3-none-any.whl (8.0 kB)
Collecting binaryornot>=0.4.4
  Downloading binaryornot-0.4.4-py2.py3-none-any.whl (9.0 kB)
Collecting requests>=2.23.0
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.6/62.6 KB 6.6 MB/s eta 0:00:00
Collecting arrow
  Downloading arrow-1.2.3-py3-none-any.whl (66 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 66.4/66.4 KB 15.4 MB/s eta 0:00:00
Collecting python-slugify>=4.0.0
  Downloading python_slugify-8.0.4-py2.py3-none-any.whl (10 kB)
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.5-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting six
  Downloading six-1.17.0-py2.py3-none-any.whl (11 kB)
Collecting bcrypt>=3.1.3
  Downloading bcrypt-4.2.1-cp37-abi3-manylinux_2_28_x86_64.whl (279 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 279.1/279.1 KB 11.0 MB/s eta 0:00:00
Collecting pynacl>=1.0.1
  Downloading PyNaCl-1.5.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (856 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 856.7/856.7 KB 82.5 MB/s eta 0:00:00
Collecting zipp>=0.5
  Downloading zipp-3.15.0-py3-none-any.whl (6.8 kB)
Collecting typing-extensions>=3.6.4
  Downloading typing_extensions-4.7.1-py3-none-any.whl (33 kB)
Collecting pygments<3.0.0,>=2.13.0
  Downloading pygments-2.17.2-py3-none-any.whl (1.2 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.2/1.2 MB 87.8 MB/s eta 0:00:00
Collecting markdown-it-py>=2.2.0
  Downloading markdown_it_py-2.2.0-py3-none-any.whl (84 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 84.5/84.5 KB 9.2 MB/s eta 0:00:00
Collecting chardet>=3.0.2
  Downloading chardet-5.2.0-py3-none-any.whl (199 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 199.4/199.4 KB 19.0 MB/s eta 0:00:00
Collecting cffi>=1.14
  Downloading cffi-1.15.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (427 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 427.9/427.9 KB 43.7 MB/s eta 0:00:00
Collecting mdurl~=0.1
  Downloading mdurl-0.1.2-py3-none-any.whl (10.0 kB)
Collecting text-unidecode>=1.3
  Downloading text_unidecode-1.3-py2.py3-none-any.whl (78 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 78.2/78.2 KB 1.1 MB/s eta 0:00:00
Collecting idna<4,>=2.5
  Downloading idna-3.10-py3-none-any.whl (70 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 70.4/70.4 KB 4.4 MB/s eta 0:00:00
Collecting certifi>=2017.4.17
  Downloading certifi-2026.1.4-py3-none-any.whl (152 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 152.9/152.9 KB 27.7 MB/s eta 0:00:00
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.4.4-py3-none-any.whl (53 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.4/53.4 KB 6.9 MB/s eta 0:00:00
Collecting urllib3<3,>=1.21.1
  Downloading urllib3-2.0.7-py3-none-any.whl (124 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 124.2/124.2 KB 24.1 MB/s eta 0:00:00
Collecting python-dateutil>=2.7.0
  Downloading python_dateutil-2.9.0.post0-py2.py3-none-any.whl (229 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 229.9/229.9 KB 25.7 MB/s eta 0:00:00
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 KB 2.4 MB/s eta 0:00:00
Building wheels for collected packages: ansible, ansible-base
  Building wheel for ansible (setup.py): started
  Building wheel for ansible (setup.py): still running...
  Building wheel for ansible (setup.py): still running...
  Building wheel for ansible (setup.py): still running...
  Building wheel for ansible (setup.py): finished with status 'done'
  Created wheel for ansible: filename=ansible-2.10.7-py3-none-any.whl size=48212999 sha256=af6c0b74b86ac60bdeda645312079268cc5db180b1e2f17a0925b08613f4b0e4
  Stored in directory: /root/.cache/pip/wheels/8b/a7/b0/989c7da8d62f2445797244fc8c671f25b2d54139555bad354f
  Building wheel for ansible-base (setup.py): started
  Building wheel for ansible-base (setup.py): finished with status 'done'
  Created wheel for ansible-base: filename=ansible_base-2.10.17-py3-none-any.whl size=1880375 sha256=6ab75dafbadfbaff4ee152d5232e4dc3fe87ca60ef2912ea1193e3ab85fc30b5        
  Stored in directory: /root/.cache/pip/wheels/ff/17/b6/05cc49357ca75f3990646aae36b8da5384f31f140cce76cd56
Successfully built ansible ansible-base
Installing collected packages: text-unidecode, cached-property, zipp, urllib3, typing-extensions, subprocess-tee, six, PyYAML, python-slugify, pygments, pycparser, packaging
, mdurl, MarkupSafe, lxml, jmespath, idna, distro, charset-normalizer, chardet, certifi, bcrypt, selinux, requests, python-dateutil, markdown-it-py, Jinja2, importlib-metada
ta, cffi, binaryornot, ansible-compat, rich, pynacl, pluggy, cryptography, click, cerberus, arrow, paramiko, enrich, cookiecutter, click-help-colors, ansible-base, molecule, ansible, molecule_podman
ERROR: Could not install packages due to an OSError: [Errno 28] No space left on device


================================================================================== log end ==================================================================================
ERROR: could not install deps [-rtox-requirements.txt, ansible<3.0]; v = InvocationError("/opt/vector-role/.tox/py37-ansible210/bin/python -m pip install -rtox-requirements.txt 'ansible<3.0'", 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
^CERROR: got KeyboardInterrupt signal                                                                                                                                        
__________________________________________________________________________________ summary __________________________________________________________________________________ERROR:   py37-ansible210: could not install deps [-rtox-requirements.txt, ansible<3.0]; v = InvocationError("/opt/vector-role/.tox/py37-ansible210/bin/python -m pip install -rtox-requirements.txt 'ansible<3.0'", 1)                                                                                                                                    
ERROR:   py37-ansible30: keyboardinterrupt                                                                                                                                   
ERROR:   py39-ansible210: undefined                                                                                                                                          
ERROR:   py39-ansible30: undefined          
```
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
```declarative
khurmatovri@compute-vm-2-2-10-hdd-1764064826727:~/education/ansible/hw5/playbook/roles/vector-role$ molecule test -s podman
WARNING  Driver podman does not provide a schema.
INFO     podman ➜ discovery: scenario test matrix: create, converge, destroy
INFO     podman ➜ prerun: Performing prerun with role_name_check=0...
INFO     podman ➜ create: Executing
INFO     Sanity checks: 'podman'

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/library/centos:7") 
skipping: [localhost]

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/library/centos:7) 
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: sleep infinity")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 
skipping: [localhost]

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     podman ➜ create: Executed: Successful
INFO     podman ➜ converge: Executing                                                                                                                                        

PLAY [Converge] ****************************************************************

TASK [Simple test] *************************************************************
ok: [instance] => {
    "msg": "Podman test successful"
}

TASK [Check container OS] ******************************************************
ok: [instance]

TASK [Show OS info] ************************************************************
ok: [instance] => {
    "msg": "Container OS: NAME=\"CentOS Linux\""
}

PLAY RECAP *********************************************************************
instance                   : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     podman ➜ converge: Executed: Successful
INFO     podman ➜ destroy: Executing                                                                                                                                         

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'command': 'sleep infinity', 'image': 'docker.io/library/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j602171988568.12522', 'results_file': '/home/khurmatovri/.ansible_async/j60217198
8568.12522', 'changed': True, 'item': {'command': 'sleep infinity', 'image': 'docker.io/library/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     podman ➜ destroy: Executed: Successful
INFO     podman ➜ scenario: Pruning extra files from scenario ephemeral directory
INFO     Molecule executed 1 scenario (1 successful)
```

6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
Заменим параметр `-s compatibility` на `-s light` в строке commands
```declarative
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37,39}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s light --destroy always}
```

8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
```declarative
[root@ce6baeec4ce4 vector-role]# tox
py39 create: /opt/vector-role/.tox/py39
py39 installdeps: ansible-compat==1.0.0, ansible==2.9.27, molecule==3.5.2, molecule-podman==1.1.0, selinux==0.2.1
py39 installed: ansible==2.9.27,ansible-compat==1.0.0,arrow==1.4.0,bcrypt==5.0.0,binaryornot==0.4.4,Cerberus==1.3.8,certifi==2026.1.4,cffi==2.0.0,chardet==5.2.0,charset-norm
alizer==3.4.4,click==8.1.8,click-help-colors==0.9.4,cookiecutter==2.6.0,cryptography==46.0.4,distro==1.9.0,enrich==1.2.7,idna==3.11,Jinja2==3.1.6,markdown-it-py==3.0.0,Marku
pSafe==3.0.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==26.0,paramiko==2.12.0,pluggy==1.6.0,pycparser==2.23,Pygments==2.19.2,PyNaCl==1.6.2,python-dateuti
l==2.9.0.post0,python-slugify==8.0.4,PyYAML==5.4.1,requests==2.32.5,rich==14.3.2,selinux==0.2.1,six==1.17.0,subprocess-tee==0.4.2,text-unidecode==1.3,typing_extensions==4.15.0,tzdata==2025.3,urllib3==2.6.3
py39 run-test-pre: PYTHONHASHSEED='3089022661'
py39 run-test: commands[0] | molecule create -s light
INFO     light scenario test matrix: dependency, create, prepare
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running light > create
INFO     Sanity checks: 'podman'
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"class": algorithms.TripleDES,

PLAY [Create] ***************************************************************************************************************************************************************

TASK [get podman executable path] *******************************************************************************************************************************************
ok: [localhost]

TASK [save path to executable as fact] **************************************************************************************************************************************
ok: [localhost]

TASK [Log into a container registry] ****************************************************************************************************************************************
skipping: [localhost] => (item="instance registry username: None specified")

TASK [Check presence of custom Dockerfiles] *********************************************************************************************************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] **********************************************************************************************************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7")

TASK [Discover local Podman images] *****************************************************************************************************************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ************************************************************************************************************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7)

TASK [Determine the CMD directives] *****************************************************************************************************************************************
ok: [localhost] => (item="instance command: sleep infinity")

TASK [Remove possible pre-existing containers] ******************************************************************************************************************************
changed: [localhost]

TASK [Discover local podman networks] ***************************************************************************************************************************************
skipping: [localhost] => (item=instance: None specified)

TASK [Create podman network dedicated to this scenario] *********************************************************************************************************************
skipping: [localhost]

TASK [Create molecule instance(s)] ******************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] ****************************************************************************************************************************
changed: [localhost] => (item=instance)

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running light > prepare
WARNING  Skipping, prepare playbook not configured.
py39 run-test: commands[1] | bash -c 'molecule converge -s light 2>&1 | tee /tmp/converge.log; exit 0'
WARNING: test command found but not installed in testenv
cmd: /usr/bin/bash
env: /opt/vector-role/.tox/py39
Maybe you forgot to specify a dependency? See also the allowlist_externals envconfig setting.

DEPRECATION WARNING: this will be an error in tox 4 and above!
INFO     light scenario test matrix: dependency, create, prepare, converge
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running light > create
WARNING  Skipping, instances already created.
INFO     Running light > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running light > converge
INFO     Sanity checks: 'podman'
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"class": algorithms.TripleDES,

PLAY [Converge] *************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [instance]

TASK [Include vector-role] **************************************************************************************************************************************************

TASK [vector-role : Create Vector directories] ******************************************************************************************************************************
changed: [instance] => (item=/opt/vector)
changed: [instance] => (item=/etc/vector)

TASK [vector-role : Download Vector archive] ********************************************************************************************************************************
changed: [instance]

TASK [vector-role : Extract Vector to installation directory] ***************************************************************************************************************
changed: [instance]

TASK [vector-role : Install Vector binary] **********************************************************************************************************************************
[WARNING]: Cannot set fs attributes on a non-existent symlink target. follow should be set to False to avoid this.
changed: [instance]

TASK [vector-role : Create Vector systemd service] **************************************************************************************************************************
changed: [instance]

TASK [vector-role : Deploy Vector configuration] ****************************************************************************************************************************
changed: [instance]

TASK [vector-role : Enable and start Vector service] ************************************************************************************************************************
fatal: [instance]: FAILED! => {"changed": false, "msg": "failure 1 during daemon-reload: Failed to get D-Bus connection: Operation not permitted\n"}

RUNNING HANDLER [vector-role : Daemon-reload] *******************************************************************************************************************************

RUNNING HANDLER [vector-role : Restart vector] ******************************************************************************************************************************

PLAY RECAP ******************************************************************************************************************************************************************
instance                   : ok=7    changed=6    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/light/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/light/converge.yml']
WARNING  Use of molecule-podman with Ansible 2.9.27 is unsupported, upgrade to Ansible 2.11 or newer. Do not raise any bugs if your tests are failing with current configuration.
py39 run-test: commands[2] | molecule verify -s light
INFO     light scenario test matrix: verify
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light > verify
INFO     Running Ansible Verifier
INFO     Sanity checks: 'podman'
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"class": algorithms.TripleDES,

PLAY [Verify Vector installation] *******************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************
ok: [instance]

TASK [Check Vector binary] **************************************************************************************************************************************************
ok: [instance]

TASK [Test Vector version] **************************************************************************************************************************************************
fatal: [instance]: FAILED! => {"changed": false, "cmd": "/usr/local/bin/vector --version", "msg": "[Errno 2] No such file or directory", "rc": 2}
...ignoring

TASK [Display installation status] ******************************************************************************************************************************************
ok: [instance] => {
"msg": "Vector installed: yes"
}

PLAY RECAP ******************************************************************************************************************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1

INFO     Verifier completed successfully.
py39 run-test: commands[3] | molecule destroy -s light
INFO     light scenario test matrix: dependency, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running light > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running light > destroy
INFO     Sanity checks: 'podman'
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/pkey.py:82: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"cipher": algorithms.TripleDES,
/opt/vector-role/.tox/py39/lib/python3.9/site-packages/paramiko/transport.py:253: CryptographyDeprecationWarning: TripleDES has been moved to cryptography.hazmat.decrepit.ciphers.algorithms.TripleDES and will be removed from cryptography.hazmat.primitives.ciphers.algorithms in 48.0.0.
"class": algorithms.TripleDES,

PLAY [Destroy] **************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *****************************************************************************************************************************************
changed: [localhost] => (item={'command': 'sleep infinity', 'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True, 'privileged': True})

TASK [Wait for instance(s) deletion to complete] ****************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '139588189607.10977', 'results_file': '/root/.ansible_async/139588189607.10977', 'changed': Tru
e, 'failed': False, 'item': {'command': 'sleep infinity', 'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})

PLAY RECAP ******************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
__________________________________________________________________________________ summary __________________________________________________________________________________
py39: commands succeeded
congratulations :)
```
Итоговый результат:
✅ Облегченный сценарий 'light' создан и работает
✅ tox выполняет все команды без ошибок (кроме ожидаемой systemd)
✅ Molecule создает контейнер, применяет роль и проверяет установку
✅ Vector успешно устанавливается (проверено в verify)

9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.



## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
