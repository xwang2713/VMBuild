#!/bin/bash

curdir=`pwd`
mkdir hld

#rm -rf HPCCSystemsVM-amd64-7.0.18-1.ova

vagrant up || exit 1
vagrant halt || exit 1
vagrant package --output hpcc-xenial64.box
vagrant destroy -f

#cd hld
#tar -xf HPCCSystemsVM-amd64-7.0.18-1.box
#tar -cf HPCCSystemsVM-amd64-7.0.18-1.ova box.ovf box-disk1.vmdk

#cp HPCCSystemsVM-amd64-7.0.18-1.ova ../
#cd $curdir
#rm -rf hld

