#!/bin/bash

apt install -y openssh-server
apt install -y ufw
/etc/init.d/ssh start
/etc/init.d/ufw start
ufw allow ssh
ufw allow http
ufw allow 5900/tcp
ufw allow 6080/tcp
FILE=/etc/ssh/sshd_config
DIR=/etc/ssh

if [ -d "$DIR" ];
then
	echo "/etc/ssh exists"
else
	mkdir /etc/ssh
fi

if [ -f "$FILE" ];
then
	sed 's/#\?\(PermitRootLogin\s*\).*$/\1 Yes/' $FILE > temp.txt
	mv -f temp.txt $FILE
else
	touch $FILE
	echo "PermitRootLogin Yes" > $FILE
fi

/etc/init.d/ssh restart
