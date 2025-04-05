#!/bin/bash

# Script to collect server information and update server-config.sh

echo "=== Cloudera Telecom Platform Configuration ==="
echo "Please provide the following information for your servers:"
echo ""

# Collect master node information
read -p "Master node IP address: " master_ip
read -p "Master node hostname [cm-master]: " master_hostname
master_hostname=${master_hostname:-cm-master}
read -p "Master node SSH username: " master_ssh_user
read -s -p "Master node SSH password: " master_ssh_password
echo ""

# Collect worker node information
read -p "Worker 1 IP address: " worker1_ip
read -p "Worker 1 hostname [worker1]: " worker1_hostname
worker1_hostname=${worker1_hostname:-worker1}
read -p "Worker 1 SSH username: " worker1_ssh_user
read -s -p "Worker 1 SSH password: " worker1_ssh_password
echo ""

read -p "Worker 2 IP address: " worker2_ip
read -p "Worker 2 hostname [worker2]: " worker2_hostname
worker2_hostname=${worker2_hostname:-worker2}
read -p "Worker 2 SSH username: " worker2_ssh_user
read -s -p "Worker 2 SSH password: " worker2_ssh_password
echo ""

# Update the server-config.sh file
cat > config/server-config.sh << EOF
#!/bin/bash

# Server IP configuration
# Change these values to match your server IPs
MASTER_IP="${master_ip}"
WORKER1_IP="${worker1_ip}"
WORKER2_IP="${worker2_ip}"

# Hostname configuration
MASTER_HOSTNAME="${master_hostname}"
WORKER1_HOSTNAME="${worker1_hostname}"
WORKER2_HOSTNAME="${worker2_hostname}"

# SSH configuration - Master node
MASTER_SSH_USER="${master_ssh_user}"
MASTER_SSH_PASSWORD="${master_ssh_password}"

# SSH configuration - Worker1 node
WORKER1_SSH_USER="${worker1_ssh_user}"
WORKER1_SSH_PASSWORD="${worker1_ssh_password}"

# SSH configuration - Worker2 node
WORKER2_SSH_USER="${worker2_ssh_user}"
WORKER2_SSH_PASSWORD="${worker2_ssh_password}"
EOF

chmod +x config/server-config.sh

echo ""
echo "Configuration saved to config/server-config.sh"
echo "Now generating inventory files..."

# Generate inventory files
./scripts/generate-inventory.sh

echo ""
echo "Configuration complete! You can now proceed with the deployment."
echo "Next step: Run ./scripts/hosts-setup.sh"
