# Cloudera Telecom Big Data Platform

Automated deployment of a secure, multi-tenant Cloudera Hadoop cluster for telecom clients (MTN Rwanda, MTN Ghana, and Airtel Uganda) using Ansible.

## Features

- Cloudera Manager with HDFS, YARN, Hive, and Spark
- Multi-tenant HDFS directory structure
- Isolated YARN queues per telecom client
- Automated deployment with Ansible playbooks
- Optimized for 3-node cluster deployment

## Quick Start

1. Clone this repository
2. Configure your inventory in `inventory/hosts.ini`
3. Run the deployment playbooks in sequence:
   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/setup-prereqs.yml
   ansible-playbook -i inventory/hosts.ini playbooks/install-cloudera.yml
   ansible-playbook -i inventory/hosts.ini playbooks/deploy-services.yml
   ansible-playbook -i inventory/hosts.ini playbooks/setup-multitenancy.yml
   ```
4. Access Cloudera Manager at http://45.90.120.29:7180

## Documentation

See the detailed deployment guide in the `guide` file for step-by-step instructions.
