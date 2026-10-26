# `roles` — Reusable Ansible Roles

This directory contains the Ansible roles for deploying MariaDB and WordPress.

## Available Roles

### 1. `mariadb`
Installs and secures `mariadb-server` and `mariadb-client`, installs Python MySQL dependencies (`tasks/python.yaml`), sets the root password, removes anonymous users and the `test` database, and disallows remote root login.

- **Tasks:** `mariadb/tasks/main.yaml`, `mariadb/tasks/python.yaml`
- **Handlers:** `mariadb/handlers/main.yaml` (`Start MariaDB`)
- **Variables (`mariadb/vars/vars.yaml`):**
  - `new_root_password` — Root password for MariaDB.

### 2. `wordpress`
Updates apt packages, installs Apache2 and PHP extensions, imports the `mariadb` role, creates the WordPress database and database user, downloads and configures WordPress (`wp-config.php` + salts), and enables the Apache site (`wordpress.conf`).

- **Tasks:** `wordpress/tasks/main.yaml`
- **Handlers:** `wordpress/handlers/main.yaml` (`Start apache`, `Restart apache`)
- **Variables (`wordpress/vars/main.yaml`):**
  - `mariadb_root_password` — Passed as `new_root_password` to the `mariadb` role.
  - `wordpress_user` — MySQL user for WordPress.
  - `wordpress_password` — MySQL password for WordPress.
  - `wordpress_db_name` — Database name for WordPress.

---

## How to Use These Roles

When running a playbook from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`), point Ansible to `src/roles` using `ANSIBLE_ROLES_PATH` (or set `roles_path = src/roles` in `ansible.cfg`):

```bash
ANSIBLE_ROLES_PATH=src/roles ansible-playbook -i inventory.ini <path-to-playbook.yaml>
```
