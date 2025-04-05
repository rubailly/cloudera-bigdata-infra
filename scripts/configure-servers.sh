#!/bin/bash

# Script to collect server information and update server-config.sh

echo "=== Cloudera Telecom Platform Configuration ==="
echo "Please provide the following information for your servers:"
echo ""

# Collect master node information
read -p "Master node IP address: " master_ip
read -p "Master node hostname [cm-master]: " master_hostname
master_hostname=${master_hostname:-cm-master}

# Collect worker node information
read -p "Worker 1 IP address: " worker1_ip
read -p "Worker 1 hostname [worker1]: " worker1_hostname
worker1_hostname=${worker1_hostname:-worker1}

read -p "Worker 2 IP address: " worker2_ip
read -p "Worker 2 hostname [worker2]: " worker2_hostname
worker2_hostname=${worker2_hostname:-worker2}

# Collect SSH information
read -p "SSH username [root]: " ssh_user
ssh_user=${ssh_user:-root}
read -s -p "SSH password: " ssh_password
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

# SSH configuration
SSH_USER="${ssh_user}"
SSH_PASSWORD="${ssh_password}"
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
