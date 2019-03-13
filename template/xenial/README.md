Error while connecting to libvirt: Error making a connection to libvirt URI qemu:///system?no_verify=1&keyfile=/home/hpccbuild/.ssh/id_rsa: (VagrantPlugins::ProviderLibvirt::Errors::FogLibvirtConnectionError)

$ vagrant plugin install vagrant-libvirt
$ sudo /etc/init.d/sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager
#$ sudo adduser pavel libvirt
#$ sudo adduser pavel libvirt-qemu
$ sudo /etc/init.d/libvirtd restart
