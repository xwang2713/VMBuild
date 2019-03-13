export DEBIAN_FRONTEND=noninteractive
arch=$(arch)
FILE_SERVER=10.240.32.242
apt-get update > /dev/null
#apt-get upgrade -y
apt-get install -y linux-headers-4.15.0-29-generic build-essential dkms --fix-missing

apt-get install -y xserver-xorg xbitmaps xterm --fix-missing
apt-get -y -f install

apt-get install -y python2.y libpython2.7 python3.6 libpython3.6 --fix-missing
apt-get -y -f install

# will need extra 200 MB
#apt-get install -y lxde

apt-get install -y openbox --fix-missing
#startx to start X Windows
apt-get install -y xinit --fix-missing
apt-get -y -f install

sleep 1
apt-get install -y libboost-regex1.65.1 libicu60 libxslt1.1 libxerces-c3.2 g++ expect libarchive13 openjdk-8-jdk r-base r-cran-rcpp libv8-dev --fix-missing
apt-get -y -f install

apt-get install -y git libapr1 libaprutil1 libtbb2 libatlas3-base  libmemcached11 libmemcachedutil2 mysqlclient20 --fix-missing
apt-get -y -f install

RInsideName=RInside_0.2.14
wget http://10.240.32.242/data3/software/R/${RInsideName}.tar.gz
R CMD INSTALL ${RInsideName}.tar.gz
rm -rf ${RInsideName}.tar.gz


apt-get update
# Install/configure Ganglia Components
# Get prerequisites
apt-get install -y  git ganglia-monitor python-lxml libltdl7 collectd-core libganglia1 libapr1 libconfuse2 libxslt1.1 libconfuse-common gmetad --fix-missing
apt-get -f install

# ganglia-webfrontend need configuration after install othewise reboot will
# prompt for authentification forever. 
apt-get install -y  -o Acquire::Retries=5 ganglia-webfrontend --fix-missing

# Install/configure Nagios Components
# Get prerequisites
apt-get install -y nagios-nrpe-server apache2 libapache2-mod-php build-essential libgd-dev nagios3 openssh-server --fix-missing
apt-get -y -f install
