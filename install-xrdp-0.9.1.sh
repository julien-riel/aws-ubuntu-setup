# From: https://github.com/neutrinolabs/xrdp/wiki/Building-on-Debian-8

sudo apt-get install git autoconf libtool pkg-config gcc g++ make libssl-dev libpam0g-dev libjpeg-dev libx11-dev libxfixes-dev libxrandr-dev flex bison libxml2-dev intltool xsltproc xutils-dev python-libxml2 g++ xutils libfuse-dev libmp3lame-dev nasm libpixman-1-dev xserver-xorg-dev

# Sources for xrdp and xorgxrdp Get sources from the release page, or clone xrdp and xorgxrdp repository from GitHub if you need the devel branch:

BD=`pwd`
mkdir -p "${BD}"/git/neutrinolabs
cd "${BD}"/git/neutrinolabs
wget https://github.com/neutrinolabs/xrdp/releases/download/v0.9.1/xrdp-0.9.1.tar.gz
wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.0/xorgxrdp-0.2.0.tar.gz

# Build and install xrdp server (Adapt the configure line to activate your needed features)
cd "${BD}"/git/neutrinolabs
tar xvfz xrdp-0.9.1.tar.gz
cd "${BD}"/git/neutrinolabs/xrdp-0.9.1
./bootstrap
./configure --enable-fuse --enable-mp3lame --enable-pixman --enable-painter
make
sudo make install
sudo ln -s /usr/local/sbin/xrdp{,-sesman} /usr/sbin

# Build and install xorgxrdp
cd "${BD}"/git/neutrinolabs
tar xvfz xorgxrdp-0.2.0.tar.gz
cd "${BD}"/git/neutrinolabs/xorgxrdp-0.2.0
./bootstrap
./configure
make
sudo make install


## Needed in order to have systemd working properly with xrdp
echo "-----------------------"
echo "Modify xrdp.service "
echo "-----------------------"
#Comment the EnvironmentFile - Ubuntu does not have sysconfig folder
sudo sed -i.bak 's/EnvironmentFile/#EnvironmentFile/g' /lib/systemd/system/xrdp.service
#Replace /sbin/xrdp with /sbin/local/xrdp as this is the correct location
sudo sed -i.bak 's/sbin\/xrdp/local\/sbin\/xrdp/g' /lib/systemd/system/xrdp.service
echo "-----------------------"
echo "Modify xrdp-sesman.service "
echo "-----------------------"
#Comment the EnvironmentFile - Ubuntu does not have sysconfig folder
sudo sed -i.bak 's/EnvironmentFile/#EnvironmentFile/g' /lib/systemd/system/xrdp-sesman.service
#Replace /sbin/xrdp with /sbin/local/xrdp as this is the correct location
sudo sed -i.bak 's/sbin\/xrdp/local\/sbin\/xrdp/g' /lib/systemd/system/xrdp-sesman.service
#Issue systemctl command to reflect change and enable the service
sudo systemctl daemon-reload
sudo systemctl enable xrdp.service
