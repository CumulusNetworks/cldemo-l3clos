Request a "Blank Workbench" on [Cumulus in the Cloud](https://cumulusnetworks.com/try-for-free/). When you receive notice that it is provisioned, you will be automatically connected to the *oob-mgmt-server*

Once connected run
`git clone -b citc https://github.com/CumulusNetworks/cldemo-l3clos`

This will set the groundwork to copy the rest of the demo to your workbench.

Next
`cd cldemo-l3clos`
`ansible-playbook setup.yml`

After Ansible finishes a new directory gets created called, l3-clos.

Follow the instructions "To Provision This Demo" back on the README.md on the master branch to complete the provisioning. 

