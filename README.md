# Cloudera Telecom Big Data Platform

Automated deployment of a secure, multi-tenant Cloudera Hadoop cluster for telecom clients (MTN Rwanda, MTN Ghana, and Airtel Uganda) using Ansible.

## Features

- Cloudera Manager with HDFS, YARN, Hive, and Spark
- Multi-tenant HDFS directory structure
- Isolated YARN queues per telecom client
- Automated deployment with Ansible playbooks
- Optimized for 3-node cluster deployment

## Prerequisites

- Three Ubuntu 20.04 servers with the following IPs:
  - 157.245.39.216 (will be cm-master)
  - 38.242.250.17 (will be worker1)
  - 45.90.120.29 (will be worker2)
- Root SSH access to all servers
- At least 8 vCPUs, 16GB RAM, and 100GB storage per server
- Ansible installed on your local machine or jump host

## Quick Start

1. Clone this repository
   ```bash
   git clone https://github.com/your-username/cloudera-telecom-platform.git
   cd cloudera-telecom-platform
   ```

2. Set up hostnames and /etc/hosts on all servers
   ```bash
   bash scripts/hosts-setup.sh
   ```

3. Run the deployment playbooks in sequence:
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/setup-prereqs.yml
   ansible-playbook -i inventory/hosts.ini playbooks/install-cloudera.yml
   ansible-playbook -i inventory/hosts.ini playbooks/deploy-services.yml
   ansible-playbook -i inventory/hosts.ini playbooks/setup-multitenancy.yml
   ```

4. Access Cloudera Manager at http://157.245.39.216:7180
   - Username: admin
   - Password: Secure123!

## Troubleshooting

If you encounter issues:
- Check Cloudera Manager logs: `/var/log/cloudera-scm-server/`
- Check agent logs: `/var/log/cloudera-scm-agent/`
- Verify all nodes can communicate with each other
- Ensure all required ports are open

## Documentation

See the detailed deployment guide in the `guide` file for step-by-step instructions.
