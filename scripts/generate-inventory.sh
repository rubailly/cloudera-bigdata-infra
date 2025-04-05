#!/bin/bash

# Source the configuration file
source config/server-config.sh

# Update the group_vars/all.yml file with the values from server-config.sh
cat > inventory/group_vars/all.yml << EOF
# Cluster configuration
cluster_name: TelecomCluster
cm_admin_user: admin
cm_admin_password: Secure123!
java_version: openjdk-8-jdk

# Server IP configuration
# These values are automatically updated from server-config.sh
master_ip: $MASTER_IP
worker1_ip: $WORKER1_IP
worker2_ip: $WORKER2_IP

# Hostname configuration
master_hostname: $MASTER_HOSTNAME
worker1_hostname: $WORKER1_HOSTNAME
worker2_hostname: $WORKER2_HOSTNAME
EOF

# Generate the inventory file
cat > inventory/hosts.ini << EOF
# This file is automatically generated from the server-config.sh file
# To change server IPs, edit the config/server-config.sh file and run:
# ./scripts/generate-inventory.sh

[cloudera_manager]
$MASTER_IP

[master]
$MASTER_IP

[workers]
$WORKER1_IP
$WORKER2_IP

[all:vars]
ansible_user=$SSH_USER
EOF

echo "Inventory file and group_vars/all.yml updated successfully"
