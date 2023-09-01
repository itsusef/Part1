#!/bin/sh

# exit the execution when an error occure
set -e
# Exit the script if a variable not define
set -u

WORKING_DIR="/home/vagrant"
ROOT_DIR="/root"
KEYS_DIR="/vagrant/Keys"

export DEBIAN_FRONTEND=noninteractive

echo "START: PROVISION THE CONTROLLER"

# Update, install ansible and tools
sudo apt-get update -qq
sudo apt-get install -y software-properties-common python3
sudo apt-get install -y gnupg2 curl wget vim 
sudo apt-get install -y ansible
echo "SUCCESS: INSTALLING ANSIBLE..."

echo "ADDING KEYS ...."
# Add ssh key 
cp ${KEYS_DIR}/controller@vm* ${WORKING_DIR}/.ssh/
cat ${KEYS_DIR}/config >> ${WORKING_DIR}/.ssh/config

# Set up permissions
sudo chown -R vagrant:vagrant ${WORKING_DIR}/.ssh
sudo chmod 600 ${WORKING_DIR}/.ssh/*
sudo chmod 644 ${WORKING_DIR}/.ssh/config
sudo chmod 700 ${WORKING_DIR}/.ssh


# Add Playbooks folder to the home directory
echo "ADD PLAYBOOKS"
cp -r /vagrant/Playbooks ${WORKING_DIR}

cd ${WORKING_DIR} 
sudo chown -R vagrant:vagrant ${WORKING_DIR}/Playbooks

# Add the s0.infra as a nemeserver
sed -i '1s/^/nameserver 192.168.50.50\n/' /etc/resolv.conf


# Add the inventory file 
echo "SETTING UP THE INVENTORY FILE ..."

sudo mkdir -p mkdir /etc/ansible
sudo touch /etc/ansible/hosts

cat >> "/etc/hosts" << EOF
192.168.50.50 s0.infra
EOF

cat >> "/etc/ansible/hosts" <<EOF
[dns]
s0.infra

[app_server]
s1.infra
s2.infra

[db_server]
s3.infra

[nfs_server]
s4.infra
EOF

echo "SUCCESS INVENTORY FILE"

echo "SUCCESS: PROVISION THE CONTROLLER..."
