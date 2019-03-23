export DEBIAN_FRONTEND=noninteractive
arch=$(arch)
FILE_SERVER=10.240.32.242
apt-get update > /dev/null
#apt-get upgrade -y
apt-get install -y linux-headers-$(uname -r) build-essential dkms --fix-missing

apt-get install -y net-tools python2.y libpython2.7 python3.6 libpython3.6 --fix-missing
apt-get -y -f install

apt-get install -y xserver-xorg xbitmaps xterm --fix-missing
apt-get -y -f install

# will need extra 200 MB
#apt-get install -y lxde

apt-get install -y openbox --fix-missing
#startx to start X Windows
apt-get install -y xinit --fix-missing
apt-get -y -f install

sleep 1
apt-get install -y libboost-regex1.58.0 libicu55 libxslt1.1 libxerces-c3.1 g++ expect libarchive13 openjdk-8-jdk r-base r-cran-rcpp libv8-dev git libapr1 libaprutil1 libmemcached11 libmemcachedutil2 libtbb2 libatlas3-base libmysqlclient20 --fix-missing
apt-get -y -f install

RInsideName=RInside_0.2.12
wget http://10.240.32.242/data3/software/R/${RInsideName}.tar.gz
R CMD INSTALL ${RInsideName}.tar.gz
rm -rf ${RInsideName}.tar.gz


# Install/configure Ganglia Components
# Get prerequisites
apt-get install -y  git ganglia-monitor python-lxml libltdl7 collectd-core libganglia1 libapr1 libconfuse0 libxslt1.1 libconfuse-common ganglia-webfrontend gmetad --fix-missing
apt-get -f install

apt-get install -y openssh-server 

#Manually install following
#apt-get install -y  ganglia-webfrontend 

# Install/configure Nagios Components
# Get prerequisites
apt-get install -y nagios-nrpe-server apache2 libapache2-mod-php build-essential libgd2-xpm-dev nagios3 --fix-missing
apt-get -y -f install

