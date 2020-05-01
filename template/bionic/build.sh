#!/bin/bash

curdir=`pwd`
mkdir hld

#rm -rf HPCCSystemsVM-amd64-7.0.18-1.ova

vagrant up 
rc=$?
vagrant halt || exit 1
[ $rc -eq 0 ] && vagrant package --output hpcc-bionic64.box
vagrant destroy -f
[ $rc -ne 0 ] && exit 1

#cd hld
#tar -xf HPCCSystemsVM-amd64-7.0.18-1.box
#tar -cf HPCCSystemsVM-amd64-7.0.18-1.ova box.ovf box-disk1.vmdk

#cp HPCCSystemsVM-amd64-7.0.18-1.ova ../
#cd $curdir
#rm -rf hld

