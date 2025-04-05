#!/bin/bash

# Source the configuration file
source config/server-config.sh

# Function to run SSH commands with password
run_ssh_command() {
    local server=$1
    local command=$2
    sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $SSH_USER@$server "$command"
}

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "sshpass is not installed. Installing now..."
    apt-get update && apt-get install -y sshpass
fi

# Set hostnames
echo "Setting hostnames..."
run_ssh_command $MASTER_IP "hostnamectl set-hostname $MASTER_HOSTNAME"
run_ssh_command $WORKER1_IP "hostnamectl set-hostname $WORKER1_HOSTNAME"
run_ssh_command $WORKER2_IP "hostnamectl set-hostname $WORKER2_HOSTNAME"

# Update /etc/hosts on all servers
echo "Updating /etc/hosts on all servers..."
for server in $MASTER_IP $WORKER1_IP $WORKER2_IP; do
  run_ssh_command $server "cat > /etc/hosts << EOF
127.0.0.1 localhost
$MASTER_IP $MASTER_HOSTNAME
$WORKER1_IP $WORKER1_HOSTNAME
$WORKER2_IP $WORKER2_HOSTNAME
EOF"
done

echo "Hostname setup completed successfully!"
echo "Master node: $MASTER_HOSTNAME ($MASTER_IP)"
echo "Worker node 1: $WORKER1_HOSTNAME ($WORKER1_IP)"
echo "Worker node 2: $WORKER2_HOSTNAME ($WORKER2_IP)"
