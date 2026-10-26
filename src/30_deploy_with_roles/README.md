# `30_deploy_with_roles` — WordPress Deployment (With Roles)

This folder is intended for playbooks that deploy the stack using the reusable roles in [`../roles/`](../roles/README.md) (`mariadb` and `wordpress`).

## Usage

For example, if moving or creating a role-based playbook here (such as `05_wordpressv2.yaml`), run it from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`) with `ANSIBLE_ROLES_PATH=src/roles`:

```bash
ANSIBLE_ROLES_PATH=src/roles ansible-playbook -i inventory.ini src/30_deploy_with_roles/<playbook>.yaml
```

### Example Playbook Structure

```yaml
---
- name: Wordpress Install with Roles
  hosts: demo
  become: true

  roles:
    - role: wordpress
      vars:
        mariadb_root_password: mypassword
        wordpress_user: wordpress_user
        wordpress_db_name: wp_db
        wordpress_password: mywppassword
```
