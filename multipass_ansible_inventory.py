#!/usr/bin/env python3
import subprocess
import json
import sys
import argparse

def get_multipass_vms():
    # Use the Multipass CLI to get VM data
    result = subprocess.run(['multipass', 'list', '--format', 'json'], 
                            capture_output=True, text=True)
    return json.loads(result.stdout).get('list', [])

def build_inventory_dict():
    vms = get_multipass_vms()
    inventory = {
        'all': {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }

    for vm in vms:
        if vm['state'] == 'Running':
            name = vm['name']
            ipv4 = vm['ipv4'][0] if vm['ipv4'] else None
            
            if ipv4:
                inventory['all']['hosts'].append(name)
                # Meta hostvars for JSON dynamic inventory compatibility
                inventory['_meta']['hostvars'][name] = {
                    'ansible_host': ipv4,
                    'ansible_user': 'ubuntu',
                    'ansible_connection': 'theko2fi.multipass.multipass'
                }
    return inventory

def to_ansible_yaml(data):
    # Ansible YAML inventories have a slightly different structure than the JSON _meta format
    yaml_inventory = {
        'all': {
            'hosts': {}
        }
    }
    for host in data['all']['hosts']:
        yaml_inventory['all']['hosts'][host] = data['_meta']['hostvars'][host]
    
    try:
        import yaml
        return yaml.dump(yaml_inventory, default_flow_style=False)
    except ImportError:
        return "Error: PyYAML is required for YAML output. Install with 'pip install pyyaml'."

def to_ansible_ini(data):
    lines = ["[all]"]
    for host in data['all']['hosts']:
        hvars = data['_meta']['hostvars'][host]
        var_str = " ".join([f"{k}={v}" for k, v in hvars.items()])
        lines.append(f"{host} {var_str}")
    return "\n".join(lines)

def main():
    parser = argparse.ArgumentParser(description="Ansible Multipass Inventory Generator")
    parser.add_argument('--list', action='store_true', help="Ansible dynamic inventory list flag")
    parser.add_argument('--host', help="Ansible dynamic inventory host flag")
    parser.add_argument('--output', '-o', choices=['json', 'yaml', 'ini'], 
                        default='json', help="Target format for manual exports")
    
    args = parser.parse_args()
    data = build_inventory_dict()

    # ANSIBLE DYNAMIC INVENTORY MODE
    # If Ansible calls this script, it uses --list and expects JSON.
    if args.list:
        if args.output == 'json':
            print(json.dumps(data, indent=2))
        elif args.output == 'yaml':
            print(to_ansible_yaml(data))
        elif args.output == 'ini':
            print(to_ansible_ini(data))
    elif args.host:
        print(json.dumps(data['_meta']['hostvars'].get(args.host, {})))
    else:
        parser.print_help()

if __name__ == '__main__':
    main()