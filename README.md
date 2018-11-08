# Cumulus Layer 3 Clos Demo

This demo will install Cumulus Linux [NetQ](https://docs.cumulusnetworks.com/display/NETQ) Fabric Validation System using the Cumulus [reference topology](https://github.com/cumulusnetworks/cldemo-vagrant). Please visit the reference topology github page for detailed instructions on using Cumulus Vx with Vagrant.


![Cumulus Reference Topology](https://raw.githubusercontent.com/CumulusNetworks/cldemo-vagrant/master/documentation/cldemo_topology.png)

_Don't want to run it locally? You can also run this demo in [Cumulus In the Cloud](https://cumulusnetworks.com/try-for-free/)_


Table of Contents
=================
* [Prerequisites](#prerequisites)
* [Using Virtualbox](#using-virtualbox)
* [Using Libvirt KVM](#using-libvirtkvm)
* [Using Cumulus in the Cloud](#using-cumulus-in-the-cloud)
* [Running the Demo](#running-the-demo)
    * [EVPN Demo](#evpn-demo)
    * [Docker Swarm   Routing on the Host Demo](#docker-swarm--routing-on-the-host-demo)
* [Troubleshooting + FAQ](#troubleshooting--faq)


Prerequisites
------------------------
* Running this simulation roughly 10G of RAM.
* Internet connectivity is required from the hypervisor. Multiple packages are installed on both the switches and servers when the lab is created.
* Download this repository locally with `git clone https://github.com/CumulusNetworks/cldemo-netq.git` or if you do not have Git installed, [Download the zip file](https://github.com/CumulusNetworks/cldemo-netq/archive/master.zip)
* Download the NetQ Telemetry Server from https://cumulusnetworks.com/downloads/#product=NetQ%20Virtual&hypervisor=Vagrant. You need to be logged into the site to access this.  Choose NetQ 1.4.
* Install [Vagrant](https://releases.hashicorp.com/vagrant/).  Vagrant 2.0.1+ is needed to support VirtualBox 5.2.x
* Install [Virtualbox](https://www.virtualbox.org/wiki/VirtualBox) or [Libvirt+KVM](https://libvirt.org/drvqemu.html) hypervisors.

Using Virtualbox
------------------------
* Add the downloaded box to vagrant via:  
`vagrant box add cumulus-netq-server-1.4.0-ts-amd64-vbox.box --name=cumulus/ts`  
**Note:** You must first manually download the Telemetry Server Vagrant box file from the [Cumulus Networks Download Page](https://cumulusnetworks.com/downloads/#product=NetQ%20Virtual&hypervisor=Vagrant)

Using Libvirt+KVM
------------------------
* Rename `Vagrantfile-kvm` to `Vagrantfile` replacing the existing Vagrantfile that is used for Virtualbox.
* Install the Vagrant mutate plugin with 
`vagrant plugin install vagrant-mutate`
* Add the downloaded box to vagrant via:  
`vagrant box add cumulus-netq-server-1.4.0-ts-amd64-libvirt.box --name=cumulus/ts`  
**Note:** You must first manually download the Telemetry Server Vagrant box file from the [Cumulus Networks Download Page](https://cumulusnetworks.com/downloads/#product=NetQ%20Virtual&hypervisor=Vagrant)

Using Cumulus in the Cloud
------------------------
Request a "Blank Workbench" on [Cumulus in the Cloud](https://cumulusnetworks.com/try-for-free/). When you receive notice that it is provisioned, connect to the *oob-mgmt-server*

Once connected run  
`git clone -b citc https://github.com/CumulusNetworks/cldemo-netq`

This will set the groundwork to copy the rest of the demo to your workbench.

Next  
`cd cldemo-netq`  
`ansible-playbook setup.yml`

After Ansible finishes two new directories are created: 
[evpn](#evpn-demo)  
[docker](#docker-swarm--routing-on-the-host-demo)

You can access either directory and follow the demo instructions below. 

To switch between demos, please _reprovision_ your Cumulus in the Cloud instance.

Running the Demo
------------------------
* The Telemetry Server replaces the oob-mgmt-server in the topology.
* `cd cldemo-netq`
* `vagrant up oob-mgmt-server oob-mgmt-switch`
* `vagrant up` (bringing up the oob-mgmt-server and switch first prevent DHCP issues)
* `vagrant ssh oob-mgmt-server`

### Docker Swarm + Routing on the Host Demo

![Docker + Routing on the Host](https://raw.githubusercontent.com/CumulusNetworks/cldemo-vagrant/master/documentation/cldemo_topology.png)

Just as described in the Reference Topology diagram, each server is configured with a /32 loopback IP and BGP ASN.

**To provision this demo**, from the oob-mgmt-server 
* `cd docker`
* `ansible-playbook run_demo.yml`


Troubleshooting + FAQ
-------
* The `Vagrantfile` expects the telemetry server to be named `cumulus/ts`. If you get the following error
```The box 'cumulus/ts' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/cumulus/ts"]
Error: The requested URL returned error: 404 Not Found
```
Please ensure you have the telemetry server downloaded and installed in Vagrant. Use `vagrant box list` to see the current Vagrant box images you have installed.
* `vagrant ssh` fails to network devices - This is expected, as each network device connects through the `oob-mgmt-server`. Use `vagrant ssh oob-mgmt-server` then ssh to the specific network device.
* If you log into a switch and are prompted for the password for the `vagrant` user, issue the command `su - cumulus` to change to the cumulus user on the oob-mgmt-server
* The Docker demo fails on server01 with an  error similar to the following
```TASK [Deploy Apache Containers] ************************************************
Wednesday 06 September 2017  03:03:56 +0000 (0:00:00.567)       0:00:44.092 ***
fatal: [server01]: FAILED! => {"changed": true, "cmd": ["docker", "service", "create", "--name", "apache_web", "--replicas", "3", "--publish", "8080:80", "php:5.6-apache"], "delta": "0:00:02.673790", "end": "2017-09-06 03:03:58.934894", "failed": true, "rc": 1, "start": "2017-09-06 03:03:56.261104", "stderr": "Error response from daemon: rpc error: code = 3 desc = port '8080' is already in use by service 'apache_web' (vviesw72piif37ip8wplod2dn) as an ingress port", "stdout": "", "stdout_lines": [], "warnings": []}
```
The Docker playbook can only be run once without reprovisioning the environment. The error can be ignored. If you need to rebuild the environment, please `vagrant destroy` and then `vagrant up`
