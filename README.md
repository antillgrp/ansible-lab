# Ansible Lab — Operations Guide

This repository contains a hands-on Ansible lab covering basic playbooks, Multipass VM provisioning, and deploying WordPress + MariaDB both with standalone playbooks and with reusable Ansible roles.

---

## Project Structure

```text
.
├── ansible.cfg                        # Default Ansible configuration (inventory, interpreter, vault)
├── inventory.ini                      # Default inventory (auto-updated by 00_vms.yaml)
├── inventory.yaml                     # Alternative YAML inventory (auto-updated by 00_vms.yaml)
├── Makefile                           # Common automation targets
├── capitulos/                         # Course chapter notes
└── src/                               # Playbooks, requirements, and roles
    ├── README.md
    ├── 00_facts.yaml                  # Gather & print localhost facts
    ├── 01_hello.yaml                  # Basic Hello World playbook with variables
    ├── 00_reqs/                       # Ansible Galaxy collection requirements
    ├── 10_infra/                      # Multipass VM lifecycle, SSH key setup & dynamic inventory
    ├── 20_deploy_no_roles/            # Monolithic WordPress + MariaDB playbooks
    ├── 30_deploy_with_roles/          # Role-based deployment playbooks
    └── roles/                         # Reusable roles (mariadb, wordpress)
```

Each folder under [`src/`](./src/README.md) has its own `README.md` with detailed usage instructions:
- [`src/README.md`](./src/README.md) — Overview & introductory playbooks (`00_facts.yaml`, `01_hello.yaml`)
- [`src/00_reqs/README.md`](./src/00_reqs/README.md) — Installing Ansible Galaxy collections
- [`src/10_infra/README.md`](./src/10_infra/README.md) — Creating/destroying Multipass VMs and configuring SSH
- [`src/20_deploy_no_roles/README.md`](./src/20_deploy_no_roles/README.md) — Deploying WordPress without roles
- [`src/30_deploy_with_roles/README.md`](./src/30_deploy_with_roles/README.md) — Deploying WordPress with roles
- [`src/roles/README.md`](./src/roles/README.md) — Documentation for the `mariadb` and `wordpress` roles

---

## Prerequisites

- **Python 3** (`>= 3.8.0`)
- **Multipass** ([Install guide](https://multipass.run/install))
- **pipx** ([Install guide](https://pipx.pypa.io/stable/))
- **jq** (used by `00_vms.yaml` to parse Multipass JSON output)

Install all system dependencies and Ansible via `make`:
```bash
make deps
```
*(Or manually run `pipx install --include-deps ansible` if `python3`, `multipass`, `pipx`, and `jq` are already installed.)*

---

## Step-by-Step Operations Workflow

All commands below should be run from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`).

### Step 1: Install Ansible Galaxy Requirements
Install the required collections (`theko2fi.multipass`, `community.mysql`, `community.crypto`) defined in [`src/00_reqs/00_requirements.yaml`](./src/00_reqs/00_requirements.yaml):

```bash
make ansible_reqs
# or directly:
ansible-galaxy install -r src/00_reqs/00_requirements.yaml
```

### Step 2: Run Introductory Playbooks (Localhost)
Verify your local Ansible setup before provisioning VMs:

```bash
# Gather and print localhost facts
ansible-playbook -c local src/00_facts.yaml

# Print a greeting using an extra variable
ansible-playbook src/01_hello.yaml -e "user=toor"
```

### Step 3: Provision the Lab VM & Configure SSH (`10_infra`)
Run `make infra_create` (which runs [`src/10_infra/00_vms.yaml`](./src/10_infra/00_vms.yaml) with tags `create` and `bridge`, followed by [`src/10_infra/10_copy_ssh_key.yaml`](./src/10_infra/10_copy_ssh_key.yaml)):

```bash
make infra_create
```

Or run the individual [`src/10_infra/`](./src/10_infra/README.md) playbooks and targets directly:
```bash
# Full VM deployment (launch on bridge, fetch IP, generate & copy SSH keys, write inventory.ini)
make deploy
# or: ansible-playbook src/10_infra/00_vms.yaml -t "deploy"

# Display the VM's current IPs
make bridge_out
# or: ansible-playbook src/10_infra/00_vms.yaml -t "bridge_out"

# Copy .ssh/id_rsa.pub to all inventory hosts via SSH
ansible-playbook -v src/10_infra/10_copy_ssh_key.yaml
```

Verify connectivity to the `demo` VM:
```bash
ansible demo -m ping -i inventory.ini
```

### Step 4A: Deploy WordPress Without Roles (`20_deploy_no_roles`)
Run the standalone WordPress + MariaDB + Apache + PHP playbook [`src/20_deploy_no_roles/04_wordpress.yaml`](./src/20_deploy_no_roles/04_wordpress.yaml):

```bash
# Check target host facts only
ansible-playbook -i inventory.ini src/20_deploy_no_roles/04_wordpress.yaml -e "@src/20_deploy_no_roles/03_variables.yaml" -t "facts"

# Run full WordPress setup (skipping facts debug output)
ansible-playbook -i inventory.ini src/20_deploy_no_roles/04_wordpress.yaml -e "@src/20_deploy_no_roles/03_variables.yaml" --skip-tags "facts"
```

### Step 4B: Deploy WordPress With Roles (`roles` / `30_deploy_with_roles`)
Deploy using the modular `wordpress` and `mariadb` roles located in [`src/roles/`](./src/roles/README.md):

```bash
ANSIBLE_ROLES_PATH=src/roles ansible-playbook -i inventory.ini src/20_deploy_no_roles/05_wordpressv2.yaml
```

Once deployed, open `http://<demo_vm_ip>` in your browser to complete the WordPress setup wizard.

### Step 5: Destroy the Lab Environment
When finished, tear down and purge the Multipass VM (running `bridge_out` and `destroy`):

```bash
make infra_destroy
# or:
ansible-playbook src/10_infra/00_vms.yaml -t "bridge_out"
ansible-playbook src/10_infra/00_vms.yaml -t "destroy"
```

---

## Course Chapters (`capitulos/`)

- [1. Introducción](./capitulos/1-intro.md)
- [2. Playbooks](./capitulos/2-playbooks.md)
- [3. Variables](./capitulos/3-variables.md)
- [4. Inventory](./capitulos/4-inventory.md)
- [5. Ansible config](./capitulos/5-ansible-cfg.md)
- [6. Wordpress playbook](./capitulos/6-wordpress-playbook.md)
- [7. Wordpress roles](./capitulos/7-wordpress-roles.md)
