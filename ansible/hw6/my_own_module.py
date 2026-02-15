#!/usr/bin/python

# Copyright: (c) 2024, Your Name <your.email@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: create_file

short_description: Creates a text file on the remote host

version_added: "1.0.0"

description: This module creates a text file on the remote host with specified content and path.

options:
    path:
        description: The full path where the file should be created on the remote host.
        required: true
        type: str
    content:
        description: The content to write to the file.
        required: true
        type: str
    owner:
        description: Name of the user that should own the file.
        required: false
        type: str
    group:
        description: Name of the group that should own the file.
        required: false
        type: str
    mode:
        description: Permissions of the file in octal format (e.g., '0644').
        required: false
        type: str
    force:
        description: If 'no', the module will fail if the file already exists.
        required: false
        type: bool
        default: true
    backup:
        description: Create a backup file if the file already exists.
        required: false
        type: bool
        default: false

author:
    - Your Name (@yourGitHubHandle)
'''

EXAMPLES = r'''
# Create a simple file
- name: Create a configuration file
  my_namespace.my_collection.create_file:
    path: /etc/myapp/config.txt
    content: |
      # Configuration file for myapp
      debug=true
      port=8080

# Create a file with specific permissions
- name: Create a file with custom owner and permissions
  my_namespace.my_collection.create_file:
    path: /home/user/script.sh
    content: "#!/bin/bash\necho 'Hello World'"
    owner: user
    group: users
    mode: '0755'

# Create a file with backup
- name: Create file with backup if exists
  my_namespace.my_collection.create_file:
    path: /var/log/app.log
    content: "Log entry"
    backup: true
'''

RETURN = r'''
path:
    description: The path of the created/modified file.
    type: str
    returned: always
    sample: '/etc/myapp/config.txt'
content:
    description: The content that was written to the file.
    type: str
    returned: always
    sample: 'debug=true'
changed:
    description: Whether the file was created or modified.
    type: bool
    returned: always
    sample: true
backup_file:
    description: The path of the backup file created (if backup was enabled and file existed).
    type: str
    returned: when backup is enabled and file existed
    sample: '/etc/myapp/config.txt.12345.2024-01-01@12:00:00~'
diff:
    description: The differences between the old and new file content.
    type: dict
    returned: when diff is enabled
    sample: '{"before": "old content", "after": "new content"}'
'''

import os
import tempfile
import shutil
from ansible.module_utils.basic import AnsibleModule


def write_file(module, path, content):
    """Write content to file with proper error handling"""
    try:
        # Create directory if it doesn't exist
        directory = os.path.dirname(path)
        if directory and not os.path.exists(directory):
            os.makedirs(directory, mode=0o755, exist_ok=True)

        # Write content to file
        with open(path, 'w') as f:
            f.write(content)
        return True, None
    except (IOError, OSError) as e:
        return False, str(e)


def get_file_diff(module, path, content):
    """Generate diff between existing file and new content"""
    try:
        if os.path.exists(path):
            with open(path, 'r') as f:
                old_content = f.read()
            return {
                'before': old_content,
                'after': content
            }
    except (IOError, OSError):
        pass
    return None


def create_backup(module, path):
    """Create a backup of an existing file"""
    try:
        if os.path.exists(path):
            backup_file = module.backup_local(path)
            return backup_file
    except Exception as e:
        module.warn(f"Failed to create backup: {str(e)}")
    return None


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True),
        owner=dict(type='str', required=False),
        group=dict(type='str', required=False),
        mode=dict(type='str', required=False),
        force=dict(type='bool', required=False, default=True),
        backup=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    result = dict(
        changed=False,
        path='',
        content=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True,
        add_file_common_args=True
    )

    # Get parameters
    path = module.params['path']
    content = module.params['content']
    force = module.params['force']
    backup = module.params['backup']

    # Check if file exists
    file_exists = os.path.exists(path)

    # If not force and file exists, fail
    if not force and file_exists:
        module.fail_json(msg=f"File '{path}' already exists and force=no", **result)

    # Read existing content if file exists
    existing_content = None
    if file_exists:
        try:
            with open(path, 'r') as f:
                existing_content = f.read()
        except (IOError, OSError) as e:
            module.fail_json(msg=f"Failed to read existing file '{path}': {str(e)}", **result)

    # Determine if file needs to be changed
    if not file_exists or existing_content != content:
        result['changed'] = True

    # Store path and content in result
    result['path'] = path
    result['content'] = content

    # Add diff information if in check mode or diff is enabled
    if module._diff or module.check_mode:
        result['diff'] = get_file_diff(module, path, content)

    # If in check mode, return early
    if module.check_mode:
        module.exit_json(**result)

    # If file doesn't need to be changed, exit successfully
    if not result['changed']:
        # Still ensure file attributes are correct
        file_args = module.load_file_common_arguments(module.params)
        if module.set_fs_attributes_if_different(file_args, result['changed']):
            result['changed'] = True
        module.exit_json(**result)

    # Create backup if requested and file exists
    if backup and file_exists:
        backup_file = create_backup(module, path)
        if backup_file:
            result['backup_file'] = backup_file

    # Write the file
    success, error_msg = write_file(module, path, content)
    if not success:
        module.fail_json(msg=f"Failed to write file '{path}': {error_msg}", **result)

    # Set file attributes (owner, group, mode)
    file_args = module.load_file_common_arguments(module.params)
    if module.set_fs_attributes_if_different(file_args, result['changed']):
        result['changed'] = True

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()