#/bin/sh
# exit the execution when an error occure
set -e
# Exit the script if a variable not define
set -u

WORKING_DIR="/home/vagrant/"
HOSTNAME="$(hostname)"

if [ "${HOSTNAME}" != "controller" ]
then

# Delete block added by vagrant 
sed -i -e '/^#VAGRANT-BEGIN/,/^#VAGRANT-END/d' /etc/network/interfaces

# Delete the config of the eth1
sed -i -e '/^# The secondary/,/^iface eth1/d' /etc/network/interfaces


cat >> "/etc/network/interfaces" <<MARK
# The secondary network interface
allow-hotplug eth1
iface eth1 inet dhcp
MARK

cat << EOF > "/etc/resolv.conf"
nameserver 192.168.50.50
EOF

sudo dhclient -v eth1

#Update The system
echo "UPDATING THE SYSTEM....."
sudo apt-get update -q
echo "THE SYSTEM UPDATED......."

else
    cd ${WORKING_DIR}/Playbooks

    # Test using ping module
    echo "PING ALL VMS"
    su vagrant -c "ansible all -m ping "

    # Install mariadb on s3.infra
    echo "INSTALL MARIADB ON S3.INFRA ..."
    su vagrant -c "ansible-playbook mariaDB.yaml"

    # Install nfs server on s4.infra
    echo "INSTALL NFS server ON S4.INFRA ..."
    su vagrant -c "ansible-playbook nfs_server.yaml"


    # Install wordpress,apache on s1.infra, and s2.infra
    echo "INSTALL wordpress,Apache ON S1.INFRA, S1.INFRA..."
    su vagrant -c "ansible-playbook wordpress.yaml"

        # Install Haproxy on s0.infra
    echo "INSTALL HAPROXY ON S0.INFRA ..."
    su vagrant -c "ansible-playbook haproxy.yaml"

fi

echo "SUCCESS!!!!"
