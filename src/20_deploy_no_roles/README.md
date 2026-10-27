# `20_deploy_no_roles` — WordPress Deployment (Without Roles)

This folder contains playbooks, task lists, and variable files for deploying Apache, MariaDB, PHP, and WordPress directly without using Ansible roles.

## Files

- **`10_php.yaml`** — Task list to install PHP and common PHP extensions.
- **`20_python.yaml`** — Task list that detects the Python version, installs `python3-pip`, `python3-dev`, `libmysqlclient-dev`, and installs `mysqlclient` via `pip`.
- **`30_variables.yaml`** — Variables file defining `mysql_root_password`, `mysql_socket`, `wordpress_db_name`, `wordpress_user`, and `wordpress_password`.
- **`40_wkload_deploy.yaml`** — Playbook structured with `pre_tasks`, `tasks`, `post_tasks`, and `handlers` to deploy Apache2, MariaDB, PHP, and WordPress on host `demo`. Includes an `Install Dedicated Plugins` handler dropping in the goVigilant healthcheck plugin and tests the `POST /wp-json/vigilant/v1/health` endpoint.

## Usage

Run from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`):

### 1. Using `make`
```bash
make wkload_deploy_no_roles
```

### 2. Using `ansible-playbook` directly
```bash
ansible-playbook -i inventory.ini src/20_deploy_no_roles/40_wkload_deploy.yaml
```

- **Run only facts:**
  ```bash
  make infra_facts
  ```

- **Deploy without facts:**
  ```bash
  make wkload_deploy_no_roles
  ```
