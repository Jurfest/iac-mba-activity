#!/bin/bash

# Directory containing Terraform configuration
TERRAFORM_DIR="terraform"
# Directory containing Terraform state
TERRAFORM_STATE_DIR=".terraform"
# Maximum number of retries for retrieving IP address
MAX_RETRIES=5
# Path to the inventory.ini file
INVENTORY_FILE="ansible/inventory.ini"

# Function to log messages
log() {
    echo "$(date) - $*" | tee -a script.log
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if necessary tools are installed
if ! command_exists terraform || ! command_exists ansible || ! command_exists nc || ! command_exists jq; then
    echo "Error: Required tools are not installed. Make sure Terraform, Ansible, netcat (nc), and jq are installed." >&2
    exit 1
fi

# Check for SSH key and create if it doesn't exist
if [ ! -f ~/.ssh/id_rsa_github ]; then
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_github -N "" || { echo "Error creating SSH key"; exit 1; }
fi

# Apply Terraform configuration with retry mechanism
for ((i=1; i<=MAX_RETRIES; i++)); do
    # Initialize Terraform if necessary
    if [ ! -d "$TERRAFORM_DIR/$TERRAFORM_STATE_DIR" ] || [ -z "$(ls -A "$TERRAFORM_DIR/$TERRAFORM_STATE_DIR")" ]; then
        log "Initializing Terraform..."
        terraform -chdir="$TERRAFORM_DIR" init | tee -a terraform.log 2>&1 || { log "Error initializing Terraform"; exit 1; }
    else
        log "Terraform is already initialized. Skipping initialization."
    fi

    # Apply Terraform configuration
    log "Planning Terraform deployment (attempt $i/$MAX_RETRIES)..."
    terraform -chdir="$TERRAFORM_DIR" plan | tee -a terraform.log 2>&1 || { log "Error planning Terraform deployment"; exit 1; }
    log "Applying Terraform changes (attempt $i/$MAX_RETRIES)..."
    terraform -chdir="$TERRAFORM_DIR" apply -auto-approve | tee -a terraform.log 2>&1 || { log "Error applying Terraform changes"; exit 1; }

    # Extract IP address from Terraform output
    IP_ADDRESS=$(terraform -chdir="$TERRAFORM_DIR" output -json public_ips | jq -r '.[0]')
    log "Got IP address: $IP_ADDRESS"

    # Check if IP address was retrieved
    if [ -n "$IP_ADDRESS" ]; then
        break
    elif [ $i -eq $MAX_RETRIES ]; then
        log "Error: Unable to retrieve public IP address after $MAX_RETRIES attempts"
        exit 1
    else
        log "Retrying to retrieve public IP address..."
        sleep 10
    fi
done

# Wait for VM to become SSH accessible
log "Waiting for IP $IP_ADDRESS to become responsive..."
while ! (nc -zvw3 "$IP_ADDRESS" 22); do
    sleep 5
done
log "VM is now responsive."

# Update the inventory.ini file with the latest public IP
log "Updating inventory.ini with latest public IP..."
cat <<EOF > "$INVENTORY_FILE"
[webservers]
$IP_ADDRESS

[webservers:vars]
ansible_ssh_user=azureadmin
ansible_ssh_private_key_file="../ssh-keys/swarm-cluster"
EOF

# Execute Ansible playbook
ANSIBLE_DIR="ansible"
log "Executing Ansible playbook..."
cd "$ANSIBLE_DIR" || { log "Error changing directory to $ANSIBLE_DIR"; exit 1; }
ansible-playbook -i inventory.ini playbook.yml -vvv | tee -a ansible.log 2>&1 || { log "Error executing Ansible playbook"; exit 1; }
cd .. || { log "Error returning to previous directory"; exit 1; }

# Display the application link
echo "You can access the application at: http://$IP_ADDRESS"
log "Application is available at: http://$IP_ADDRESS"
