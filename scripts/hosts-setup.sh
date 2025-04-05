#!/bin/bash

# Source the configuration file
source config/server-config.sh

# Set hostnames
ssh root@$MASTER_IP "hostnamectl set-hostname $MASTER_HOSTNAME"
ssh root@$WORKER1_IP "hostnamectl set-hostname $WORKER1_HOSTNAME"
ssh root@$WORKER2_IP "hostnamectl set-hostname $WORKER2_HOSTNAME"

# Update /etc/hosts on all servers
for server in $MASTER_IP $WORKER1_IP $WORKER2_IP; do
  ssh root@$server "cat > /etc/hosts << EOF
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
