#/bin/bash

## Cleanup stuff from the previous run.
rm -rf output-centos-7-x86_64-server-vagrant
rm -rf box/*
rm -f build.log

## This is the command that starts it all. 
#packer build centos7.json
PACKER_LOG=1 packer build centos7.json 2>>build.log
