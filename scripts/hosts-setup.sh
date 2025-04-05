#!/bin/bash

# Set hostnames
ssh root@45.90.120.29 "hostnamectl set-hostname cm-master"
ssh root@38.242.250.17 "hostnamectl set-hostname worker1"
ssh root@157.245.39.216 "hostnamectl set-hostname worker2"

# Update /etc/hosts on all servers
for server in 45.90.120.29 38.242.250.17 157.245.39.216; do
  ssh root@$server "cat > /etc/hosts << EOF
127.0.0.1 localhost
45.90.120.29 cm-master
38.242.250.17 worker1
157.245.39.216 worker2
EOF"
done
