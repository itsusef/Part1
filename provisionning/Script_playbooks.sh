#!/bin/sh

# exit the execution when an error occure
set -e
# Exit the script if a variable not define
set -u
WORKING_DIR="/home/vagrant/"
export DEBIAN_FRONTEND=noninteractive

cd ${WORKING_DIR}/Playbooks

# Test using ping module
echo "PING S0.infra VMS"
su vagrant -c "ansible s0.infra -m ping "

# Install DNSmasq on s0.infra
echo "INSTALL DNSMASQ ON S0.INFRA ..."
su vagrant -c "ansible-playbook dnsmasq.yaml"

echo "SUCCESS..."
