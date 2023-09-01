#!/bin/sh

set -e # arrete le script en cas d'erreur
set -u # arrete le script en cas de variable non d�finie
export DEBIAN_FRONTEND=noninteractive


echo "START: DHCP CONFIGURATION (AGENTS)....."

echo "UPDATING THE SYSTEM....."
sudo apt-get update 
echo "THE SYSTEM UPDATED......."


# cat >> "/etc/network/interfaces" <<MARK
# # The secondary network interface
# allow-hotplug eth1
# iface eth1 inet dhcp
# MARK


# cat > "/etc/resolv.conf" <<MARK
# nameserver 192.168.50.50
# MARK

# echo "ASKING FOR IP ADDRESS"
# sudo dhclient -v eth1
# echo "ASKING FOR IP ADDRESS: DONE!!!!"

echo "SUCCESS: DHCP CONFIGURATION (AGENTS)....."