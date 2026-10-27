# `src/` — Ansible Playbooks & Roles

All commands below assume you are running from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`), where `ansible.cfg` and `inventory.ini` are located.

## Root Playbooks in `src/`

### 1. `00_facts.yaml`
Gathers and prints `ansible_facts` for `localhost`.

```bash
ansible-playbook -c local src/00_facts.yaml
```
*(Note: If line 4 is set to `connection: localhost`, either pass `-c local` or change line 4 to `connection: local`.)*

### 2. `10_hello.yaml`
Prints a greeting message on `localhost` using the `user` variable.

```bash
ansible-playbook src/10_hello.yaml -e "user=toor"
```

---

## Subfolders

- [`00_reqs/`](./00_reqs/README.md) — Ansible Galaxy collection requirements (`00_requirements.yaml`).
- [`10_infra/`](./10_infra/README.md) — Multipass VM provisioning, SSH key setup, and dynamic inventory (`00_vms.yaml`, `10_copy_ssh_key.yaml`, `multipass_ansible_inventory.py`).
- [`20_deploy_no_roles/`](./20_deploy_no_roles/README.md) — Standalone WordPress & MariaDB deployment playbooks, task files, and variable files.
- [`30_deploy_with_roles/`](./30_deploy_with_roles/README.md) — Role-based deployment playbooks.
- [`roles/`](./roles/README.md) — Modular Ansible roles (`python`, `php`, `mariadb`, and `wordpress`).
