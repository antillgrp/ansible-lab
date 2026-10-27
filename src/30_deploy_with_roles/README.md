# `30_deploy_with_roles` — WordPress Deployment (With Roles)

This folder contains playbooks that deploy the stack using reusable roles from [`../roles/`](../roles/README.md) (`python`, `mariadb`, and `wordpress`).

## Files

- **`10_wordpressv2.yaml`** — Deploys WordPress on host `demo` using the `wordpress` role (which automatically imports `mariadb` and `python`).

## Usage

Run from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`):

### 1. Using `make`
```bash
make wkload_deploy_roles
```

### 2. Using `ansible-playbook` directly
```bash
ansible-playbook -i inventory.ini src/30_deploy_with_roles/10_wordpressv2.yaml
```

### Playbook Structure

```yaml
---
- name: Wordpress Install V2
  hosts: demo
  become: true

  roles:
    - role: wordpress
      vars:
        mariadb_root_password: mypassword
        mysql_root_password: mypassword
        wordpress_user: wordpress_user
        wordpress_db_name: wp_db
        wordpress_password: mywppassword
```
