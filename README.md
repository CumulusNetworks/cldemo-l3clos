Request a "Blank Workbench" on [Cumulus in the Cloud](https://cumulusnetworks.com/try-for-free/). When you receive notice that it is provisioned, connect to the *oob-mgmt-server*

Once connected run
`git clone -b citc https://github.com/jubetz/cldemo-l3clos`

This will set the groundwork to copy the rest of the demo to your workbench.

Next
`cd cldemo-netq`
`ansible-playbook setup.yml`

After Ansible finishes two new directories are created:
[evpn](https://github.com/CumulusNetworks/cldemo-netq/blob/master/README.md#evpn-demo)
[docker](https://github.com/CumulusNetworks/cldemo-netq/blob/master/README.md#docker-swarm--routing-on-the-host-demo)

You can access either directory and follow the demo instructions.

To switch between demos, please _reprovision_ your Cumulus in the Cloud instance.
