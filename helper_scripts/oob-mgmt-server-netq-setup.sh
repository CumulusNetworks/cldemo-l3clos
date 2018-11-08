#!/bin/sh
sudo su - cumulus -c '\
git clone -b evpn https://github.com/CumulusNetworks/cldemo-netq/ evpn;
git clone -b docker-roh https://github.com/CumulusNetworks/cldemo-netq/ docker; \
'

cat << EOT > /var/www/ztp.sh
#!/bin/bash
function error() {
  echo -e "\e[0;33mERROR: The Zero Touch Provisioning script failed while running the command $BASH_COMMAND at line $BASH_LINENO.\e[0m" >&2
  exit 1
}

cat << DONE > /etc/network/interfaces
 # The loopback network interface
 auto lo
 iface lo inet loopback

 # The primary network interface
 auto eth0
 iface eth0 inet dhcp
    vrf mgmt

auto mgmt
iface mgmt
    address 127.0.0.1/8
    vrf-table auto
DONE

ifreload -a

# CUMULUS-AUTOPROVISIONING
exit 0
EOT

chmod +r /var/www/ztp.sh

echo "sudo su - cumulus" >> /home/vagrant/.bash_profile
echo "exit" >> /home/vagrant/.bash_profile
