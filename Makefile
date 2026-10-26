# include .env
# export

export AWS_ACCESS_KEY_ID := test
export AWS_SECRET_ACCESS_KEY := test
export AWS_DEFAULT_REGION := us-east-1
export AWS_STS_ENDPOINT := http://localhost:4566

dkcleanup:
	@echo "Pruning all unused Docker containers, images, networks, and volumes..."
	# Stop all running containers first (if not handled by docker-compose down)
	-docker stop $(shell docker ps -aq)
	# Run system prune with -a (all unused images, not just dangling) and --volumes
	docker system prune -a --volumes -f
	@echo "Docker system cleanup complete."

dkcomposeup:
	docker compose up -d

#### ANSIBLE ####

export ANSIBLE_NOCOWS := 1 

# To create a basic configuration file with default settings commented out, run the following command:
# ansible-config init --disabled > ansible.cfg
# To include available plugin configurations as well, use the -t all option:
# ansible-config init --disabled -t all > ansible.cfg
# export ANSIBLE_CONFIG := /etc/ansible/ansible.cfg

# export ANSIBLE_DISPLAY_OK_HOSTS := false

ansible_reqs:
	@ansible-galaxy install -r requirements.yaml
	@ansible-galaxy collection install community.aws --upgrade
	@ansible-galaxy collection install amazon.aws --upgrade

aws_deploy:
	@ansible-playbook -v aws_ansible.yaml

aws_ssh:
	@ansible-playbook -v aws_ansible_ssh.yaml  

create:
	@ansible-playbook -vvvvvv vms.yaml -t "create"

start:
	@ansible-playbook -vvvvvv vms.yaml -t "start"

destroy:
	@ansible-playbook -v vms.yaml -t "destroy"

deploy:
	@ansible-playbook -v vms.yaml -t "deploy"

bridge:
	@ansible-playbook -v vms.yaml -t "bridge"

bridge_out:
	@ansible-playbook -v vms.yaml -t "bridge_out"

wpfacts:
	@ansible-playbook -vvvvvv -i inventory.ini src/wordpress.yaml -t "facts"

wpsetup:
	@ansible-playbook -v -i inventory.ini src/wordpress.yaml --skip-tags "facts"

rancher_init:
    sudo docker run -d --privileged --restart=unless-stopped -p 8080:80 -p 8443:443 --name rancher rancher/rancher:latest

rancher_bootstrap_pass:
    docker logs  rancher  2>&1 | grep "Bootstrap Password:"
	# 2026/02/14 17:49:03 [INFO] Bootstrap Password: xtk8mbbsw82hhhz2w47qhmx47fg9vcln4glhxrp6k7d2ntbzh7pmmk [gvjqGGqGV7dXAR9A]

# A new API Key has been created
# Access Key
# token-jsbcn
# Secret Key
# cv4wlwt9wmqskmctjqr68vwfsf4qcz4fjznrqpr7cdrtfngcqwkj2p

# Access Key and Secret Key can be sent as the username and password for HTTP Basic auth to authorize requests. You can also combine them to use as a Bearer token:
# Bearer Token
# token-jsbcn:cv4wlwt9wmqskmctjqr68vwfsf4qcz4fjznrqpr7cdrtfngcqwkj2p
# Save the info above! This is the only time you'll be able to see it. If you lose it, you'll need to create a new API key.

