#!/bin/sh
sudo sh -c 'echo "deb http://ftp.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list'
sudo sh -c 'echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list.d/jessie.list'
sudo sh -c 'echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list.d/jessie.list'
sudo sh -c 'echo "deb http://repo3.cumulusnetworks.com/repo Jessie-supplemental upstream" > /etc/apt/sources.list.d/jessie_cl.list'
# needed to upgrade to ansible 2.7 for reboot module
# ansible docs says ubuntu trusty tested on jesse: https://docs.ansible.com/ansible/2.7/installation_guide/intro_installation.html
sudo sh -c 'echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list.d/jessie.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
# remove list file that points to build servers so that we don't throw errors in the apt-get update
[ -e /etc/apt/sources.list.d/cumulus-apps.list ] && sudo rm /etc/apt/sources.list.d/cumulus-apps.list
sudo apt-get update
sudo apt-get install -yq git python-netaddr sshpass
sudo apt-get install -yq -t trusty ansible
git clone https://github.com/cumulusnetworks/cldemo-provision-ts.git
sudo systemctl enable dhcpd.service

echo " ### Pushing Ansible Hosts File ###"
mkdir -p /etc/ansible
cat << EOT > /etc/ansible/hosts
[oob-switch]
oob-mgmt-switch ansible_host=192.168.0.1 ansible_user=cumulus

[exit]
exit02 ansible_host=192.168.0.42 ansible_user=cumulus
exit01 ansible_host=192.168.0.41 ansible_user=cumulus

[leafs]
leaf04 ansible_host=192.168.0.14 ansible_user=cumulus
leaf02 ansible_host=192.168.0.12 ansible_user=cumulus
leaf03 ansible_host=192.168.0.13 ansible_user=cumulus
leaf01 ansible_host=192.168.0.11 ansible_user=cumulus

[spines]
spine02 ansible_host=192.168.0.22 ansible_user=cumulus
spine01 ansible_host=192.168.0.21 ansible_user=cumulus

[servers]
server01 ansible_host=192.168.0.31 ansible_user=cumulus
server03 ansible_host=192.168.0.33 ansible_user=cumulus
server02 ansible_host=192.168.0.32 ansible_user=cumulus
server04 ansible_host=192.168.0.34 ansible_user=cumulus

[exits]
exit01 ansible_user=cumulus ansible_ssh_pass=CumulusLinux! ansible_become_pass=CumulusLinux!
exit02 ansible_user=cumulus ansible_ssh_pass=CumulusLinux! ansible_become_pass=CumulusLinux!

[internets]
internet ansible_user=cumulus ansible_ssh_pass=CumulusLinux! ansible_host=192.168.0.253

[network:children]
leafs
spines

EOT

echo " ### Pushing Ansible Configuration ###"
cat << EOT > /etc/ansible/ansible.cfg
[defaults]
library = /usr/share/ansible
# only use in lab settings. Reference:
# http://docs.ansible.com/intro_getting_started.html#host-key-checking
host_key_checking=False
callback_whitelist = profile_tasks
retry_files_enabled = False
pipelining = True
forks = 6
EOT
