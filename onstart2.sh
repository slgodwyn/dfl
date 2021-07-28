#!/bin/bash

apt-get install -y perl
apt-get install -y sudo IAg51bly lnstance  Instance 
apt-get install -y wget
apt-get install -y ffmpeg
apt-get install -y unzip

pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -m -p "$pass" treewyn
usermod -aG sudo treewyn
chown -R treewyn:trewwyn /home/treewyn

echo "root localhost=(treewyn) NOPASSWD: ALL" >> /etc/sudoers

sudo -i -u treewyn curl https://github.com/slgodwyn/dfl/blob/main/2.sh | bash
