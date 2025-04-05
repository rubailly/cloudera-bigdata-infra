#!/bin/bash

# Source the configuration file
source config/server-config.sh

# Function to run SSH commands with password for specific servers
run_master_ssh_command() {
    local command=$1
    sshpass -p "$MASTER_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $MASTER_SSH_USER@$MASTER_IP "$command"
}

run_worker1_ssh_command() {
    local command=$1
    sshpass -p "$WORKER1_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $WORKER1_SSH_USER@$WORKER1_IP "$command"
}

run_worker2_ssh_command() {
    local command=$1
    sshpass -p "$WORKER2_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no $WORKER2_SSH_USER@$WORKER2_IP "$command"
}

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "sshpass is not installed. Installing now..."
    apt-get update && apt-get install -y sshpass
fi

# Set hostnames
echo "Setting hostnames..."
run_master_ssh_command "hostnamectl set-hostname $MASTER_HOSTNAME"
run_worker1_ssh_command "hostnamectl set-hostname $WORKER1_HOSTNAME"
run_worker2_ssh_command "hostnamectl set-hostname $WORKER2_HOSTNAME"

# Update /etc/hosts on master server
echo "Updating /etc/hosts on master server..."
run_master_ssh_command "cat > /etc/hosts << EOF
127.0.0.1 localhost
$MASTER_IP $MASTER_HOSTNAME
$WORKER1_IP $WORKER1_HOSTNAME
$WORKER2_IP $WORKER2_HOSTNAME
EOF"

# Update /etc/hosts on worker1 server
echo "Updating /etc/hosts on worker1 server..."
run_worker1_ssh_command "cat > /etc/hosts << EOF
127.0.0.1 localhost
$MASTER_IP $MASTER_HOSTNAME
$WORKER1_IP $WORKER1_HOSTNAME
$WORKER2_IP $WORKER2_HOSTNAME
EOF"

# Update /etc/hosts on worker2 server
echo "Updating /etc/hosts on worker2 server..."
run_worker2_ssh_command "cat > /etc/hosts << EOF
127.0.0.1 localhost
$MASTER_IP $MASTER_HOSTNAME
$WORKER1_IP $WORKER1_HOSTNAME
$WORKER2_IP $WORKER2_HOSTNAME
EOF"

echo "Hostname setup completed successfully!"
echo "Master node: $MASTER_HOSTNAME ($MASTER_IP)"
echo "Worker node 1: $WORKER1_HOSTNAME ($WORKER1_IP)"
echo "Worker node 2: $WORKER2_HOSTNAME ($WORKER2_IP)"
