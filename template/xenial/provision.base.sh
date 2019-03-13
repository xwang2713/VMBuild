export DEBIAN_FRONTEND=noninteractive
arch=$(arch)
FILE_SERVER=10.240.32.242
apt-get update > /dev/null
#apt-get upgrade -y
apt-get install -y linux-headers-4.4.0-98-generic build-essential dkms --fix-missing

apt-get install -y xserver-xorg --fix-missing
apt-get -y -f install

# will need extra 200 MB
#apt-get install -y lxde

apt-get install -y openbox --fix-missing
#startx to start X Windows
apt-get install -y xinit --fix-missing
apt-get -y -f install

sleep 1
apt-get install -y libboost-regex1.58.0 libicu55 libxslt1.1 libxerces-c3.1 g++ expect libarchive13 openjdk-8-jdk r-base r-cran-rcpp libv8-dev git libapr1 libaprutil1 --fix-missing
apt-get -y -f install

RInsideName=RInside_0.2.12
wget http://10.240.32.242/builds/software/R/${RInsideName}.tar.gz
R CMD INSTALL ${RInsideName}.tar.gz
rm -rf ${RInsideName}.tar.gz


# Install/configure Ganglia Components
# Get prerequisites
apt-get install -y  git ganglia-monitor python-lxml libltdl7 collectd-core libganglia1 libapr1 libconfuse0 libxslt1.1 libconfuse-common ganglia-webfrontend gmetad --fix-missing
apt-get -f install

# Install/configure Nagios Components
# Get prerequisites
apt-get install -y nagios-nrpe-server apache2 libapache2-mod-php5 build-essential libgd2-xpm-dev nagios3 openssh-server --fix-missing
apt-get -y -f install
