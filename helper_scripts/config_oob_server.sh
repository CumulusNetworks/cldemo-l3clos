#!/bin/bash

#This file is transferred to a Debian/Ubuntu Host and executed to re-map interfaces
#Extra config COULD be added here but I would recommend against that to keep this file standard.
echo "#################################"
echo "  Running OOB server config"
echo "#################################"
sudo su

#Replace existing network interfaces file
echo -e "auto lo" > /etc/network/interfaces
echo -e "iface lo inet loopback\n\n" >> /etc/network/interfaces
echo -e  "source /etc/network/interfaces.d/*.cfg\n" >> /etc/network/interfaces

#Add vagrant interface
echo -e "\n\nauto eth0" >> /etc/network/interfaces
echo -e "iface eth0 inet dhcp\n\n" >> /etc/network/interfaces

####### Custom Stuff
echo "auto eth1" >> /etc/network/interfaces
echo "iface eth1 inet static" >> /etc/network/interfaces
echo "    address 192.168.0.254" >> /etc/network/interfaces
echo "    netmask 255.255.255.0" >> /etc/network/interfaces

echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus

# Disable AAAA records; speeds up APT for v4 only networks
sed -i -e 's/#precedence ::ffff:0:0\/96  10/#precedence ::ffff:0:0\/96  100/g' /etc/gai.conf

ifup eth1
sed "s/PasswordAuthentication no/PasswordAuthentication yes/" -i /etc/ssh/sshd_config
service ssh restart

# Update GPG keys to solve KB issue https://support.cumulusnetworks.com/hc/en-us/articles/360002663013-Updating-Expired-GPG-Keys
wget https://repo3.cumulusnetworks.com/repo/pool/cumulus/c/cumulus-archive-keyring/cumulus-archive-keyring_3-cl3u4_all.deb
sudo dpkg -i cumulus-archive-keyring_3-cl3u4_all.deb

echo "#################################"
echo "   Finished"
echo "#################################"
