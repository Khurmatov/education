## Ответы

**Шаг 4.** Проверьте module на исполняемость локально.
![4.png](images/4.png)

**Шаг 6.** Проверьте через playbook на идемпотентность.
![6.png](images/6.png)

**Шаг 15.** Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`.
![15.png](images/15.png)

**Шаг 16.** Запустите playbook, убедитесь, что он работает.
![16.png](images/16.png)

Ссылка на collection: https://github.com/Khurmatov/my_own_collection/tree/main/yandex_cloud_elk
Ссылка на tar.gz архив: https://github.com/Khurmatov/my_own_collection/blob/main/release_package/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz