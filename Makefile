# include .env

#### ANSIBLE ####

export ANSIBLE_NOCOWS := 1 

# To create a basic configuration file with default settings commented out, run the following command:
# ansible-config init --disabled > ansible.cfg
# To include available plugin configurations as well, use the -t all option:
# ansible-config init --disabled -t all > ansible.cfg
# export ANSIBLE_CONFIG := /etc/ansible/ansible.cfg

# export ANSIBLE_DISPLAY_OK_HOSTS := false

deps:
	-sudo apt-get update
	sudo apt-get install -y python3 python3-pip python3-venv pipx jq
	@command -v multipass >/dev/null 2>&1 || sudo snap install multipass
	pipx ensurepath
	@command -v ansible >/dev/null 2>&1 || pipx install --include-deps ansible

ansible_reqs:
	@ansible-galaxy install -r src/00_reqs/00_requirements.yaml

infra_create:
	@ansible-playbook -vvvvvv src/10_infra/00_vms.yaml -t "create"
	@ansible-playbook -v src/10_infra/00_vms.yaml -t "bridge"
	@ansible-playbook -v src/10_infra/10_copy_ssh_key.yaml

infra_destroy:
	@ansible-playbook -v src/10_infra/00_vms.yaml -t "bridge_out"
	@ansible-playbook -v src/10_infra/00_vms.yaml -t "destroy"

infra_facts:
	@ansible-playbook -vvvvvv -i inventory.ini src/20_deploy_no_roles/40_wkload_deploy.yaml -t "facts"

wkload_deploy_no_roles:
	@ansible-playbook -v -i inventory.ini src/20_deploy_no_roles/40_wkload_deploy.yaml --skip-tags "facts"

wkload_deploy_roles:
	@ansible-playbook -v -i inventory.ini src/30_deploy_with_roles/10_wkload_deploy.yaml

# TODO : rancher_init:
# 	sudo docker run -d --privileged --restart=unless-stopped -p 8080:80 -p 8443:443 --name rancher rancher/rancher:latest

# TODO : rancher_bootstrap_pass:
# 	docker logs  rancher  2>&1 | grep "Bootstrap Password:"
# 	# 2026/02/14 17:49:03 [INFO] Bootstrap Password: xtk8mbbsw82hhhz2w47qhmx47fg9vcln4glhxrp6k7d2ntbzh7pmmk [gvjqGGqGV7dXAR9A]
