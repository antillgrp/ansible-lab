# `20_deploy_no_roles` — WordPress Deployment (Without Roles)

This folder contains playbooks, task lists, and variable files for deploying Apache, MariaDB, PHP, and WordPress directly in a playbook.

## Files

- **`02_python.yaml`** — Task list (not a standalone playbook) that detects the Python version, installs `python3-pip`, `python3-dev`, `libmysqlclient-dev`, and installs `mysqlclient` via `pip`. Imported into a playbook via `import_tasks`.
- **`03_variables.yaml`** — Variables file defining `mysql_root_password`, `mysql_socket`, `wordpress_db_name`, `wordpress_user`, and `wordpress_password`.
- **`04_wordpress.yaml`** — Full monolithic playbook that installs and configures Apache2, MariaDB, PHP, and WordPress on host `demo`.
- **`05_wordpressv2.yaml`** — Playbook that deploys WordPress using the `wordpress` role.

## Usage

Run from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`):

### 1. Run `04_wordpress.yaml`
> **Note:** `04_wordpress.yaml` references `vars_files: - variables.yaml`. Either update `vars_files` in `04_wordpress.yaml` to `03_variables.yaml` or pass `@src/20_deploy_no_roles/03_variables.yaml` via `-e`:

- **Run full WordPress installation (skipping debug facts):**
  ```bash
  ansible-playbook -i inventory.ini src/20_deploy_no_roles/04_wordpress.yaml -e "@src/20_deploy_no_roles/03_variables.yaml" --skip-tags "facts"
  ```

- **Print host facts only:**
  ```bash
  ansible-playbook -i inventory.ini src/20_deploy_no_roles/04_wordpress.yaml -e "@src/20_deploy_no_roles/03_variables.yaml" -t "facts"
  ```

### 2. Run `05_wordpressv2.yaml`
Since the roles live in `src/roles`, specify `ANSIBLE_ROLES_PATH=src/roles` when running from the repository root:

```bash
ANSIBLE_ROLES_PATH=src/roles ansible-playbook -i inventory.ini src/20_deploy_no_roles/05_wordpressv2.yaml
```
