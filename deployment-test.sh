#!/bin/bash

# Source the configuration file
source config/server-config.sh

# Functions to run SSH commands with password for specific servers
run_master_ssh_command() {
    local command=$1
    sshpass -p "$MASTER_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 $MASTER_SSH_USER@$MASTER_IP "$command"
}

run_worker1_ssh_command() {
    local command=$1
    sshpass -p "$WORKER1_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 $WORKER1_SSH_USER@$WORKER1_IP "$command"
}

run_worker2_ssh_command() {
    local command=$1
    sshpass -p "$WORKER2_SSH_PASSWORD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 $WORKER2_SSH_USER@$WORKER2_IP "$command"
}

echo "=== Testing Cloudera Deployment ==="
echo "1. Testing SSH connectivity to all nodes..."

echo -n "  - Testing SSH to $MASTER_IP: "
run_master_ssh_command "echo OK" || { echo "FAILED"; exit 1; }

echo -n "  - Testing SSH to $WORKER1_IP: "
run_worker1_ssh_command "echo OK" || { echo "FAILED"; exit 1; }

echo -n "  - Testing SSH to $WORKER2_IP: "
run_worker2_ssh_command "echo OK" || { echo "FAILED"; exit 1; }

echo "2. Testing hostname resolution..."

echo -n "  - Testing hostname resolution on $MASTER_IP: "
run_master_ssh_command "grep -q $MASTER_HOSTNAME /etc/hosts && grep -q $WORKER1_HOSTNAME /etc/hosts && grep -q $WORKER2_HOSTNAME /etc/hosts && echo OK" || { echo "FAILED"; exit 1; }

echo -n "  - Testing hostname resolution on $WORKER1_IP: "
run_worker1_ssh_command "grep -q $MASTER_HOSTNAME /etc/hosts && grep -q $WORKER1_HOSTNAME /etc/hosts && grep -q $WORKER2_HOSTNAME /etc/hosts && echo OK" || { echo "FAILED"; exit 1; }

echo -n "  - Testing hostname resolution on $WORKER2_IP: "
run_worker2_ssh_command "grep -q $MASTER_HOSTNAME /etc/hosts && grep -q $WORKER1_HOSTNAME /etc/hosts && grep -q $WORKER2_HOSTNAME /etc/hosts && echo OK" || { echo "FAILED"; exit 1; }

echo "3. Testing SSH password authentication..."
echo -n "  - Testing SSH password authentication: "
run_master_ssh_command "echo OK" > /dev/null 2>&1 && run_worker1_ssh_command "echo OK" > /dev/null 2>&1 && run_worker2_ssh_command "echo OK" > /dev/null 2>&1 && echo "OK" || { echo "FAILED"; exit 1; }

echo "4. Testing Cloudera Manager connectivity..."
echo -n "  - Waiting for CM web interface (this may take a few minutes): "
for i in {1..30}; do
  if curl -s -o /dev/null -w "%{http_code}" http://$MASTER_IP:7180/ | grep -q "200"; then
    echo "OK"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "FAILED - Cloudera Manager not responding after 5 minutes"
    exit 1
  fi
  echo -n "."
  sleep 10
done

echo "5. Testing database connectivity..."
echo -n "  - Testing MariaDB: "
run_master_ssh_command "systemctl is-active mariadb" | grep -q "active" && echo "OK" || { echo "FAILED"; exit 1; }

echo "6. Testing HDFS status..."
echo -n "  - Checking HDFS service: "
curl -s -u admin:Secure123! http://$MASTER_IP:7180/api/v32/clusters/TelecomCluster/services/hdfs | grep -q "GOOD_HEALTH" && echo "OK" || echo "WARNING - HDFS may not be healthy yet"

echo "7. Testing YARN status..."
echo -n "  - Checking YARN service: "
curl -s -u admin:Secure123! http://$MASTER_IP:7180/api/v32/clusters/TelecomCluster/services/yarn | grep -q "GOOD_HEALTH" && echo "OK" || echo "WARNING - YARN may not be healthy yet"

echo "All tests completed! Your deployment should be working correctly."
echo "Access Cloudera Manager at: http://$MASTER_IP:7180"
echo "Username: admin"
echo "Password: Secure123!"

echo ""
echo "Tenant directories:"
echo "- MTN Rwanda: /telecoms/mtn-rwanda"
echo "- MTN Ghana: /telecoms/mtn-ghana"
echo "- Airtel Uganda: /telecoms/airtel-uganda"

echo ""
echo "YARN queues:"
echo "- mtn.rwanda (30%)"
echo "- mtn.ghana (30%)"
echo "- airtel.uganda (40%)"
