#!/bin/sh

# exit the execution when an error occure
set -e
# Exit the script if a variable not define
set -u

export DEBIAN_FRONTEND=noninteractive
WORKING_DIR="/home/vagrant/"

echo "START: PROVISIONNING S0.INFRA"
echo "Updating the S0.INFRA....."
sudo apt-get update 
echo "UPDATE: DONE!!!!"


cat > "/etc/resolv.conf" <<MARK
nameserver 192.168.50.50
nameserver 1.1.1.1
MARK

if [ "${DNSMASQ_INSTALLATION_MODE_SHELL}" = "true" ]
then

echo "INSTALL DNSMASQ ON S0 "

sudo apt install -y dnsmasq 

# dnmasq configuration 
cat > "/etc/dnsmasq.conf" <<EOF
interface=eth1
port=53
domain-needed
bogus-priv
listen-address=127.0.0.1,192.168.50.50
expand-hosts
no-resolv
server=1.1.1.1
server=192.168.50.50
domain=infra
dhcp-range=192.168.50.100,192.168.50.150,255.255.255.0,24h
dhcp-option=3,192.168.50.1
dhcp-authoritative
EOF

sudo systemctl restart dnsmasq
fi    

echo "SUCCESS: S0.INFRA PROVISIONNING....!!!!"