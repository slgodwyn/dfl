#!/bin/bash

echo "Run as root or press ctrl+c to abort"
echo -t 1 "............................................................"
echo -t 1 "........................................."
echo -t 1 "......................"
echo -t 1  "......."
echo -t 1 "."
echo "Proceeding with update, xfce4 desktop installation and VNC server configuration"

apt-get update -y
apt-get dist-upgrade -y
apt-get install -y curl
apt-get install -y git
apt-get install -y wget
apt-get install -y ffmpeg
apt-get install -y unzip

if [ -f /usr/bin/sudo ] 
then 
    echo "Installing required apt packages ... [1/10]"
else 
    apt-get install sudo -y 
    echo "Installing required apt packages ... [1/10]"
fi
if [ -f /usr/bin/openssh-server ] 
then 
    echo "Installing required apt packages ... [2/10]"
Else 
    apt-get install openssh-server -y 
    echo "Installing required apt packages ... [2/10]"
fi
if [ -d /usr/share/locales ]
then 
    locale-gen en_US.UTF-8
else
    apt install -y locales
    locale-gen en_US.UTF-8
fi
if [ -f /usr/bin/expect ] 
then 
    echo "Installing required apt packages ... [3/10]"
else 
    apt-get install expect -y 
    echo "Installing required apt packages ... [3/10]"
fi
echo "Installing required apt packages ... [4/10]"
apt-get install tightvncserver -y
echo "Installing required apt packages ... [5/10]"
echo "Installing required apt packages ... [6/10]"
echo "Installing required apt packages ... [7/10]"
if [ -f /usr/sbin/gdm3 ] 
then 
    echo "Installing required apt packages ... [8/10]"
else 
    apt-get install gdm3 -y 
    echo "Installing required apt packages ... [8/10]"
fi
if [ -d /etc/X11 ]
then
    echo "/usr/sbin/gdm3" > /etc/X11/default-display-manager
else
    mkdir /etc/X11
    echo "/usr/sbin/gdm3" > /etc/X11/default-display-manager
    echo "Installing required apt packages ... [9/10]"
    echo "Installing required apt packages ... [10/10]"
fi
if [ -f /usr/bin/xorg ] 
then
    echo "Installing required apt packages ... [9/10]"
    echo "Installing required apt packages ... [10/10]"
else
    apt install -y xauth
    apt install -y xorg openbox
   
fi
if [ -F $HOME/.XAuthority ]
then
    mv $HOME/.XAuthority $HOME/.XAuthority_Backup
else
    touch $HOME/.XAuthority
    xauth generate :0 . trusted 
fi
echo "set shared/default-x-display-manager gdm3" | debconf-communicate
DEBIAN_FRONTEND=noninteractive apt install ubuntu-gnome-desktop -y

echo "downloading latest Anaconda3 installation script"
mkdir /tmp/DFL_install
TMP_DIR="/tmp/DFL_install"
DL_CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh"
DL_DFL="https://slgodwyn:holliday954@github.com/nagadit/DeepFaceLab_Linux.git"
CONDA_PATHS=("/opt" "$HOME")
CONDA_NAMES=("/ana" "/mini")
CONDA_VERSIONS=("3" "2")
CONDA_BINS=("/bin/conda" "/condabin/conda")
DIR_CONDA="$HOME/anaconda"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=false
ENV_NAME="deepfacelab"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=true
script_name='anaconda.sh'
env_path='$HOME/anaconda'
curl $DL_CONDA -s -o $script_name
# create temporary conda installation
echo "Creating Conda environment configured for DeepFaceLab 2.0"
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name

source $DIR_CONDA/etc/profile.d/conda.sh
$CONDA_EXECUTABLE init bash

cd $HOME
git clone --depth 1 --no-single-branch "$DL_DFL"
cd $HOME/DeepFaceLab_Linux
git clone --depth 1 --no-single-branch https://github.com/slgodwyn/DeepFaceLab.git
curl https://raw.githubusercontent.com/slgodwyn/dfl/main/dfl.yml -o $HOME/dfl.yml
conda env create -f $HOME/dfl.yml

echo "export DFL_WORKSPACE="$HOME/DeepFaceLab_Linux/workspace"" >> $HOME/.bashrc
echo "export DFL_PYTHON="python3.7"" >> $HOME/.bashrc
echo "export DFL_SRC="$HOME/DeepFaceLab_Linux/DeepFaceLab"" >> $HOME/.bashrc
echo "export scripts="$HOME/DeepFaceLab_Linux/scripts"" >> $HOME/.bashrc
echo "export work="$HOME/DeepFaceLab_Linux/workspace"" >> $HOME/.bashrc
echo "alias env=‘cd $scripts && conda activate deepfacelab‘" >> ~/.bashrcmkdir $DFL_WORKSPACE
DFL_WORKSPACE="$HOME/DeepFaceLab_Linux/workspace"" >> $HOME/.bashrc
DFL_SRC="$HOME/DeepFaceLab_Linux/DeepFaceLab"" >> $HOME/.bashrc
scripts="$HOME/DeepFaceLab_Linux/scripts"" >> $HOME/.bashrc
echo "alias env=‘cd $scripts && conda activate deepfacelab‘" >> ~/.bashrcmkdir $DFL_WORKSPACE
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src/aligned
mkdir $DFL_WORKSPACE/data_src/aligned_debug
mkdir $DFL_WORKSPACE/data_dst
mkdir $DFL_WORKSPACE/data_dst/aligned
mkdir $DFL_WORKSPACE/data_dst/aligned_debug
mkdir $DFL_WORKSPACE/model

if [ -d ~/.vnc ] 
then
    echo "writing xstartup"
else 
    mkdir ~/.vnc
fi

if [ -f ~/.vnc/xstartup ] 
then
    rm ~/.vnc.xstartup
    touch ~/.vnc/xstartup
else 
    echo "writing xstartup"
fi

cat << EOF >> ~/.vnc/xstartup
#!/bin/sh
exec /etc/vnc/xstartup
xrdb $HOME/.Xresources
vncconfig -iconic &
dbus-launch --exit-with-session gnome-session &
EOF 

mkdir -p /etc/vncserver
touch /etc/vncserver/vncservers.conf
cat << EOF >> /etc/vncserver/vncservers.conf
VNCSERVERS="1:root"
VNCSERVERARGS[1]="-geometry 1440x900 -depth 24"
EOF

awk '$1=="#AllowTcpForwarding"{foundLine=1; print "AllowTcpForwarding yes"} $1!="#AllowTcpForwarding"{print $0} END{if(foundLine!=1) print "permitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config

awk '$1=="#TCPKeepAlive"{foundLine=1; print "TCPKeepAlive yes"} $1!="#TCPKeepAlive"{print $0} END{if(foundLine!=1) print "permitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config

echo "PermitOpen any" >> /etc/ssh/sshd_config

/etc/init.d/ssh restart

vncserver -geometry 900x600 -depth 24 :1

cat << EOF >> next.txt
Next Step:
start ssh tunnel on host with cmd: ssh -L 5901:172.17.0.2:5901 -C -N -l USER YOUR_SERVER_IP
connect on 127.0.0.1:5901 with authentication set to vncpasswd
EOF

cat next.txt
