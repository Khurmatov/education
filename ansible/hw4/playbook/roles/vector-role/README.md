Vector role
=========

This role install vector on VM.

Role Variables
--------------

| vars               | description       |
|--------------------|-------------------|
| vector_version     | Install version   |
| --------------     | ---------------   |
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
