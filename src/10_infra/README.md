# `10_infra` — Infrastructure & VM Provisioning

This folder contains playbooks to provision local Multipass virtual machines and configure SSH access.

## Files

### 1. `00_vms.yaml`
Manages the lifecycle of the `demo` Multipass VM on `localhost`, generates SSH keys in `.ssh/id_rsa`, injects the public key into the VM, and writes `./inventory.ini`.

Run from the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`):

- **Provision infrastructure via `make infra_create` (runs `create`, `bridge`, and copies SSH keys via `10_copy_ssh_key.yaml`):**
  ```bash
  make infra_create
  ```

- **Full deploy (launch VM on bridge, get IP, generate & copy SSH keys, update `inventory.ini`):**
  ```bash
  ansible-playbook src/10_infra/00_vms.yaml -t "deploy"
  ```

- **Launch VM on bridged network (`br-ens33`) and print IPs:**
  ```bash
  ansible-playbook src/10_infra/00_vms.yaml -t "bridge"
  ```

- **Query and display existing VM IPs only:**
  ```bash
  ansible-playbook src/10_infra/00_vms.yaml -t "bridge_out"
  ```

- **Configure SSH keys and update inventories for a running VM:**
  ```bash
  ansible-playbook src/10_infra/00_vms.yaml -t "create"
  ```

- **Destroy and purge the VM (`make infra_destroy` runs `bridge_out` and `destroy`):**
  ```bash
  make infra_destroy
  # or:
  ansible-playbook src/10_infra/00_vms.yaml -t "bridge_out"
  ansible-playbook src/10_infra/00_vms.yaml -t "destroy"
  ```

- **Override the VM name (default is `demo`):**
  ```bash
  ansible-playbook src/10_infra/00_vms.yaml -t "deploy" -e "vm_name=myvm"
  ```

---

### 2. `10_copy_ssh_key.yaml`
Copies the local `.ssh/id_rsa.pub` public key to the `ubuntu` user's `~/.ssh/authorized_keys` on all hosts in the inventory.

```bash
ansible-playbook -i inventory.ini src/10_infra/10_copy_ssh_key.yaml
```

---

### 3. `multipass_ansible_inventory.py`
Dynamic Ansible inventory script and static inventory exporter for running Multipass VMs.

- **Use directly as a dynamic inventory with Ansible:**
  ```bash
  ansible all -i src/10_infra/multipass_ansible_inventory.py -m ping
  ```
- **Print dynamic JSON inventory:**
  ```bash
  ./src/10_infra/multipass_ansible_inventory.py --list
  ```
- **Export static YAML or INI inventory:**
  ```bash
  ./src/10_infra/multipass_ansible_inventory.py --list -o yaml
  ./src/10_infra/multipass_ansible_inventory.py --list -o ini
  ```
