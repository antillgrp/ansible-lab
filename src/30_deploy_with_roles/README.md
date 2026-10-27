# `30_deploy_with_roles` — WordPress Deployment (With Roles)

This folder contains playbooks that deploy the stack using reusable roles from [`../roles/`](../roles/README.md) (`php`, `python`, `mariadb`, and `wordpress`).

## Files

- **`10_wkload_deploy.yaml`** — Deploys WordPress on host `demo` using the `wordpress` role (which automatically imports `php`, `mariadb`, and `python`).

## Usage

Run from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`):

### 1. Using `make`
```bash
make wkload_deploy_roles
```

### 2. Using `ansible-playbook` directly
```bash
ansible-playbook -i inventory.ini src/30_deploy_with_roles/10_wkload_deploy.yaml
```

### Playbook Structure

```yaml
---
- name: Workload Deploy (With Roles)
  hosts: demo
  become: true
  gather_facts: true

  vars:
    mariadb_root_password: mypassword
    mysql_root_password: mypassword
    mysql_socket: /var/run/mysqld/mysqld.sock
    wordpress_user: wp_admin
    wordpress_db_name: wp_db
    wordpress_password: wp_password

  pre_tasks:
    - name: PRE_TASK Update Packages
      ...
    - name: PRE_TASK Check if variables mysql_root_password and mysql_socket are set
      ...

  roles:
    - role: wordpress

  post_tasks:
    - name: POST_TASK Test WordPress health endpoint (POST /wp-json/vigilant/v1/health)
      ...
    - name: POST_TASK Display WordPress site URL
      ...
```
