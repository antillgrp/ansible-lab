# `roles` — Reusable Ansible Roles

This directory contains reusable Ansible roles for deploying Python dependencies, PHP, MariaDB, and WordPress.

## Available Roles

### 1. `python`
Installs Python build tools and libraries (`pkg-config`, `python3-pip`, `python3-dev`, `libmysqlclient-dev`), removes PEP 668 restriction on Ubuntu 24.04+, and installs `mysqlclient` via pip.

- **Tasks:** `python/tasks/main.yaml`

### 2. `php`
Installs PHP runtime and required extensions (`php-common`, `php-mysql`, `php-xml`, `php-curl`, `php-gd`, `php-imagick`, etc.).

- **Tasks:** `php/tasks/main.yaml`
- **Variables (`php/defaults/main.yaml`):**
  - `php_packages` — List of PHP packages to install.

### 3. `mariadb`
Installs and secures `mariadb-server` and `mariadb-client`, imports the `python` role for MySQL dependencies, sets the root password, removes anonymous users and the `test` database, and disallows remote root login.

- **Tasks:** `mariadb/tasks/main.yaml`
- **Handlers:** `mariadb/handlers/main.yaml` (`HANDLER Start MariaDB`)
- **Variables (`mariadb/defaults/main.yaml`):**
  - `new_root_password` — Root password for MariaDB.

### 4. `wordpress`
Updates apt packages, installs Apache2, imports the `php` role, imports the `mariadb` role, creates the WordPress database and database user, downloads and configures WordPress (`wp-config.php` + salts), installs the goVigilant healthcheck drop-in plugin, and enables the Apache site (`wordpress.conf`).

- **Tasks:** `wordpress/tasks/main.yaml`
- **Handlers:** `wordpress/handlers/main.yaml` (`HANDLER Start apache`, `HANDLER Restart apache`, `HANDLER Install Dedicated Plugins`)
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
ansible-playbook -i inventory.ini src/30_deploy_with_roles/10_wkload_deploy.yaml
```
