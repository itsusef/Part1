#!/bin/sh

# exit the execution when an error occure
set -e
# Exit the script if a variable not define
set -u

WORKING_DIR="/home/vagrant"
ROOT_DIR="/root"
KEYS_DIR="/vagrant/Keys"
export DEBIAN_FRONTEND=noninteractive


echo "Start provisioning sshkeys..."
mkdir -p ${ROOT_DIR}/.ssh
touch ${ROOT_DIR}/.ssh/authorized_keys

if [ ! -f ${KEYS_DIR}/controller@vm ]; then
ssh-keygen -t ed25519 -N "" -C "controller@vm" -f ${KEYS_DIR}/controller@vm
fi


cat << EOF > ${KEYS_DIR}/config
Host *
User root
IdentityFile ~/.ssh/controller@vm
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
EOF


echo "SUCCESS: GENERATING KEYS ..."