# Cloudera Telecom Big Data Platform

Automated deployment of a secure, multi-tenant Cloudera Hadoop cluster for telecom clients (MTN Rwanda, MTN Ghana, and Airtel Uganda) using Ansible.

## Features

- Cloudera Manager with HDFS, YARN, Hive, and Spark
- Multi-tenant HDFS directory structure
- Isolated YARN queues per telecom client
- Automated deployment with Ansible playbooks
- Optimized for 3-node cluster deployment
- Configurable server IPs for flexible deployment

## Prerequisites

- Three Ubuntu 20.04 servers with:
  - Root SSH access to all servers
  - At least 8 vCPUs, 16GB RAM, and 100GB storage per server
- Ansible installed on your local machine or jump host

## Quick Start

1. Clone this repository
   ```bash
   git clone https://github.com/your-username/cloudera-telecom-platform.git
   cd cloudera-telecom-platform
   ```

2. Configure your server IPs in `config/server-config.sh`
   ```bash
   # Edit the server IP addresses to match your environment
   vim config/server-config.sh
   ```

3. Generate the inventory file
   ```bash
   bash scripts/generate-inventory.sh
   ```

4. Set up hostnames and /etc/hosts on all servers
   ```bash
   bash scripts/hosts-setup.sh
   ```

5. Run the deployment playbooks in sequence:
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/setup-prereqs.yml
   ansible-playbook -i inventory/hosts.ini playbooks/install-cloudera.yml
   ansible-playbook -i inventory/hosts.ini playbooks/deploy-services.yml
   ansible-playbook -i inventory/hosts.ini playbooks/setup-multitenancy.yml
   ```

6. Access Cloudera Manager at http://<master-ip>:7180
   - Username: admin
   - Password: Secure123!

7. Multi-tenant resources will be configured as follows:
   - HDFS directories: /telecoms/mtn-rwanda, /telecoms/mtn-ghana, /telecoms/airtel-uganda
   - YARN queues: mtn.rwanda (30%), mtn.ghana (30%), airtel.uganda (40%)

## Customizing Your Deployment

You can customize your deployment by editing:
- `config/server-config.sh` - Server IPs and hostnames
- `inventory/group_vars/all.yml` - Cluster name, admin credentials, etc.
- `config/yarn-queues.json` - YARN queue structure
- `config/cluster-definition.json` - Hadoop services configuration

## Troubleshooting

If you encounter issues:
- Check Cloudera Manager logs: `/var/log/cloudera-scm-server/`
- Check agent logs: `/var/log/cloudera-scm-agent/`
- Verify all nodes can communicate with each other
- Ensure all required ports are open
- Check MariaDB status: `systemctl status mariadb`
- Verify database connectivity: `mysql -u root -p`

## Documentation

See the detailed deployment guide in the `guide` file for step-by-step instructions.
