#!/bin/bash

# Source the configuration file
source config/server-config.sh

echo "=== Testing Cloudera Deployment ==="
echo "1. Testing SSH connectivity to all nodes..."

for server in $MASTER_IP $WORKER1_IP $WORKER2_IP; do
  echo -n "  - Testing SSH to $server: "
  ssh -o ConnectTimeout=5 -o BatchMode=yes $SSH_USER@$server "echo OK" || { echo "FAILED"; exit 1; }
done

echo "2. Testing hostname resolution..."
for server in $MASTER_IP $WORKER1_IP $WORKER2_IP; do
  echo -n "  - Testing hostname resolution on $server: "
  ssh $SSH_USER@$server "grep -q $MASTER_HOSTNAME /etc/hosts && grep -q $WORKER1_HOSTNAME /etc/hosts && grep -q $WORKER2_HOSTNAME /etc/hosts && echo OK" || { echo "FAILED"; exit 1; }
done

echo "3. Testing Cloudera Manager connectivity..."
echo -n "  - Testing CM web interface: "
curl -s -o /dev/null -w "%{http_code}" http://$MASTER_IP:7180/ | grep -q "200" && echo "OK" || { echo "FAILED"; exit 1; }

echo "4. Testing database connectivity..."
echo -n "  - Testing MariaDB: "
ssh $SSH_USER@$MASTER_IP "systemctl is-active mariadb" | grep -q "active" && echo "OK" || { echo "FAILED"; exit 1; }

echo "All tests passed! Your deployment should be working correctly."
echo "Access Cloudera Manager at: http://$MASTER_IP:7180"
echo "Username: admin"
echo "Password: Secure123!"
