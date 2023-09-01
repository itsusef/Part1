#!/bin/sh

# exit the execution when an error occure
set -e
# Exit the script if a variable not define
set -u
WORKING_DIR="/home/vagrant"
ROOT_DIR="/root"
KEYS_DIR="/vagrant/Keys"

LINE="192.168.50.50 s0.infra s0"
FILE="/etc/hosts"


export DEBIAN_FRONTEND=noninteractive

#Update The system
# echo "UPDATING THE SYSTEM....."
# sudo apt-get update 
# echo "THE SYSTEM UPDATED......."


# Add the public key
echo "START COPYING PUBLIC KEY ...."
sudo mkdir -p ${ROOT_DIR}/.ssh
cat ${KEYS_DIR}/controller@vm.pub >> ${WORKING_DIR}/.ssh/authorized_keys
cat ${KEYS_DIR}/controller@vm.pub >> ${ROOT_DIR}/.ssh/authorized_keys



# Set up permissions
sudo chown -R vagrant:vagrant ${WORKING_DIR}/.ssh
sudo chmod 600 ${WORKING_DIR}/.ssh/*
sudo chmod 700 ${WORKING_DIR}/.ssh


# Add s0.infro to hosts 
grep -q "${LINE}" "${FILE}" || echo "${LINE}" >> "${FILE}"


echo "SUCCESS ADD KEYS..."