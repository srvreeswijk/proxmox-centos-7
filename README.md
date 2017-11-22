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
- not all packages are installed during kickstart (how to add repo locations during kickstart or post operations)
-- nss-pam-ldapd
-- wget
-- net-tools
- secure storage for vialisadmin password in the centos7.json for packer, now it will ask during the install. 
- ldap configuration
- dns setup
- ntp setup 
- hostname setup
- nic bootproto (none of static)
- docker preconfig for openshift
-- add dockervg to the docker-config see (we used option B): https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
-- run docker config command
```
cat <<EOF > /etc/sysconfig/docker-storage-setup
VG=dockervg
EOF

docker-storage-setup
```



# more info:
[Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/installation_guide/s1-kickstart2-options#s2-kickstart2-options-part-examples)