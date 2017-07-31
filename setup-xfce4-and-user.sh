# This scripts installs xfce4 and xrdp. It also creates a new user 'developper' with a password 'secret'

apt-get update
apt-get install -y xfce4
apt-get update

# quietly add a user without password and then add a password and add user to sudoers
adduser --gecos --disabled-password developper
echo 'developper:secret' | chpasswd
sudo adduser developper sudo


