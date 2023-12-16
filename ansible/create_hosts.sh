#!/bin/bash

# Directory where Terraform files are located
TERRAFORM_DIR="../terraform"

# Navigate to the Terraform directory and get the output
IP=$(terraform -chdir=$TERRAFORM_DIR output --raw public_ips)

# Check if the IP was obtained
if [ -z "$IP" ]; then
    echo "IP address not found."
    exit 1
fi

# Directory where the Ansible inventory file will be created
ANSIBLE_DIR="."

# Directory where SSH keys are located
SSH_KEYS_DIR="ssh-keys"

# Create the inventory file
cat << EOF > "$ANSIBLE_DIR/hosts.ini"
[webservers]
$IP

[webservers:vars]
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file="$SSH_KEYS_DIR/swarm-cluster"
EOF

echo "Inventory file created at $ANSIBLE_DIR/hosts.ini"