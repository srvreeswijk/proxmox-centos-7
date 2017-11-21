# packer-openshift

This set of scripts and config files will create an CentOS-7 based OpenShift VM. 
With openshift-ansible scripts these will be configured to be an Master or an Node. 

# prerequisites:
- available centos-7 mininimal install iso with sha256 checksum
- an linux host with qemu/kvm
- internet access for downloading this repo in the vm and the ansible scripts from openshift.

# what will be done:
- an qcow2 virtual machine will be created with packer
- packer will start the kickstart install of CentOS
- packer will start some post scripts for some final configuration and cleanup

# what needs to be done:
- not all packages are installed during kickstart
- secure storage for vialisadmin password. For now the user will be created with an unsafe password and manually changed. 
- ldap configuration
- dns setup
- default host setup etc....
- een nette manier vinden om het vialisadmin wachtwoord in centos7.json te krijgen, nu vraagt hij de gebruiker. maar dat vind ik niet mooi.


# more info:
[Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/installation_guide/s1-kickstart2-options#s2-kickstart2-options-part-examples)