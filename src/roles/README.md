# `roles` — Reusable Ansible Roles

This directory contains reusable Ansible roles for deploying Python dependencies, MariaDB, and WordPress.

## Available Roles

### 1. `python`
Installs Python build tools and libraries (`pkg-config`, `python3-pip`, `python3-dev`, `libmysqlclient-dev`), removes PEP 668 restriction on Ubuntu 24.04+, and installs `mysqlclient` via pip.

- **Tasks:** `python/tasks/main.yaml`

### 2. `mariadb`
Installs and secures `mariadb-server` and `mariadb-client`, imports the `python` role for MySQL dependencies, sets the root password, removes anonymous users and the `test` database, and disallows remote root login.

- **Tasks:** `mariadb/tasks/main.yaml`
- **Handlers:** `mariadb/handlers/main.yaml` (`Start MariaDB`)
- **Variables (`mariadb/defaults/main.yaml`):**
  - `new_root_password` — Root password for MariaDB.

### 3. `wordpress`
Updates apt packages, installs Apache2 and PHP extensions, imports the `mariadb` role, creates the WordPress database and database user, downloads and configures WordPress (`wp-config.php` + salts), and enables the Apache site (`wordpress.conf`).

- **Tasks:** `wordpress/tasks/main.yaml`
- **Handlers:** `wordpress/handlers/main.yaml` (`Start apache`, `Restart apache`)
- **Variables (`wordpress/defaults/main.yaml`):**
  - `mariadb_root_password` — Passed as `new_root_password` to the `mariadb` role.
  - `wordpress_user` — MySQL user for WordPress.
  - `wordpress_password` — MySQL password for WordPress.
  - `wordpress_db_name` — Database name for WordPress.

---

## How to Use These Roles

`roles_path = src/roles` is configured in `ansible.cfg`. You can deploy the complete role-based workload via `make`:

```bash
make wkload_deploy_roles
```
Or directly via `ansible-playbook`:
```bash
ansible-playbook -i inventory.ini src/30_deploy_with_roles/10_wordpressv2.yaml
```
