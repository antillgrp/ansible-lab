# `00_reqs` — Ansible Galaxy Requirements

This folder contains [`00_requirements.yaml`](./00_requirements.yaml), which declares the Ansible Galaxy collections required by this lab:

- `theko2fi.multipass` (`0.3.0`)
- `community.mysql` (`3.10.0`)
- `community.crypto` (`2.21.1`)

## Usage

From the repository root (`/home/toor/DEVOPS_DEV/ansible-lab`):

### Using `make`
```bash
make ansible_reqs
```

### Using `ansible-galaxy` directly
```bash
ansible-galaxy install -r src/00_reqs/00_requirements.yaml
```

To force an upgrade of existing collections:
```bash
ansible-galaxy collection install -r src/00_reqs/00_requirements.yaml --force
```
