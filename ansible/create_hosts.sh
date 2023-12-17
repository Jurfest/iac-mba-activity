#!/bin/bash

# Directory where Terraform files are located
TERRAFORM_DIR="../terraform"

# Navigate to the Terraform directory and get the output in JSON format
OUTPUT_JSON=$(terraform -chdir=$TERRAFORM_DIR output --json)

echo "OUTPUT_JSON: $OUTPUT_JSON"

# Extract the IP address from the JSON output
IP=$(echo "$OUTPUT_JSON" | jq -r '.public_ips.value[0]')  # Assumes public_ips is a list, adjust if needed

# Check if the IP was obtained
if [ -z "$IP" ]; then
    echo "IP address not found."
    exit 1
fi

# Directory where the Ansible inventory file will be created
ANSIBLE_DIR="."

# Directory where SSH keys are located
SSH_KEYS_DIR="../ssh-keys"

# Create the inventory file
cat << EOF > "$ANSIBLE_DIR/inventory.ini"
[webservers]
$IP

[webservers:vars]
ansible_ssh_user=azureadmin
ansible_ssh_private_key_file="$SSH_KEYS_DIR/swarm-cluster"
EOF

echo "Inventory file created at $ANSIBLE_DIR/inventory.ini"