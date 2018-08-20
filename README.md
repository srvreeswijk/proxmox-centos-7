# packer-openshift

This set of scripts and config files will create an CentOS-7 based OpenShift VM. 
With openshift-ansible scripts these will be configured to be an Master or an Node. 

# more info:
[Kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/installation_guide/s1-kickstart2-options#s2-kickstart2-options-part-examples)

# prerequisites:
- available centos-7 mininimal install iso with sha256 checksum
- an linux host with qemu/kvm
- internet access for downloading this repo in the vm and the ansible scripts from openshift.

# what will be done:
- an qcow2 virtual machine will be created with packer
- packer will start the kickstart install of CentOS
- packer will start some post scripts for some final configuration and cleanup

# how to start the build:
- clone this repo to an machine who matches the prerequisites
- run "packer_build.sh"
- get some coffee and talk with people, this takes some time.....

# what needs to be done:
- not all packages are installed during kickstart (how to add repo locations during kickstart or post operations)
  - nss-pam-ldapd
  - wget
  - net-tools
  - vim              ( + alias aanmaken en correcte color instellen en search text highlighting )
- secure storage for vialisadmin password in the centos7.json for packer, now it will ask during the install. 
- ldap configuration
- dns setup
- ntp setup 
- hostname setup
- nic bootproto (none of static)
- docker preconfig for openshift
  - add dockervg to the docker-config see (we used option B): https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  - run docker config command

```
cat <<EOF > /etc/sysconfig/docker-storage-setup
VG=dockervg
EOF

docker-storage-setup
```

~~Aan passen in BYO playbooks zodat de OC cluster admin user wordt aangemaakt op moment van runnen en installeren van OpenShift met Ansible~~  
BYO playbooks nooit aanpassen, daar krijg je last van met upgrades van openshift.  
Beter is om een set met prepare for openshift-node playbooks te maken.  
```
name: oc adm policy remove-scc-from-user an-scc ausername
  oc_adm_policy_user:
    user: ausername
    resource_kind: scc
    resource_name: an-scc
    state: absent
```

# Logging tijdens OpenShift installatie

Vooral tijdens het installeren ontstond de behoefte aan uitgebride logging om de installatie problemen mee op te kunnen lossen.
file:  /etc/sysconfig/[origin-master | origin-master=-api-controller | origin-node] 
- En er mag wat mij betreft meer logging verhoogd worden. Maar dan bedoel ik van systeem processen zoals yum ntp enz.  
Voor mij part zorgen dat er gescript echt alles naar journalctl gestuurd wordt.
En als de installatie klaaris dan un-installen we deze config weer. 
- Als we toch bezig zijn, tijdens de installatie alle logging naar een centrale ELK-stack die alleen voor de installatie tijdelijk in de lucht gebracht wordt. 

## waarom aanpassen? 
Met de standaard log niveaus (0 en 2) zoals het installatie script kwam, bleek het soms lastig te achterhalen waardoor nu werkelijk de installatie faalde. 
(Stap X van playbook faalt, maar is dat omdat de master geen antwoord krijgt van de node. Of heeft de node de vraag nooit gehoord. of wordt het andword van de node verkeerd gerouteerd) 1000 redenen waarom het zou kunnen falen. Maar nergens logging. En dus traceren tot waar een proces is gekomen bleek zo goed als onmogelijk. En dus was het vaak. Dit checken, dat checken en dan een gokje wagen op basis van een naampje van een config item. 


```
# Possible loglevels are:
# 0     -       Errors and Warnings only
# 2     -       Normal information
# 4     -       Debugging-level information
# 6     -       API-level debugging information (request / response)
# 8     -       Body-level API debugging information
#OPTIONS="--loglevel=0"
OPTIONS="--loglevel=8"

CONFIG_FILE=/etc/origin/master/master-config.yaml

# Proxy configuration
# Origin uses standard HTTP_PROXY environment variables. Be sure to set
# NO_PROXY for your master
#NO_PROXY=master.example.com
#HTTP_PROXY=http://USER:PASSWORD@IPADDR:PORT
#HTTPS_PROXY=https://USER:PASSWORD@IPADDR:PORT

```

