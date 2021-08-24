#!/bin/bash

echo "Run as root or press ctrl+c to abort"
echo -p "........... Continuing in 3 seconds ..........." -t 1
echo -p "....................... 2 seconds ......................." -t 1
echo -p "........................ 1 second ........................" -t 1
echo -p "Proceeding with update, xfce4 desktop installation and VNC server configuration" -t 1

apt-get update -y
apt-get dist-upgrade -y
apt-get install -y curl
apt-get install -y git
apt-get install -y wget
apt-get install -y ffmpeg
apt-get install -y unzip

if [ -f /usr/bin/sudo ]; then 
    echo "Installing required apt packages ... [1/10]"
else 
    apt-get install sudo -y 
    echo "Installing required apt packages ... [1/10]"
fi
if [ -f /usr/bin/openssh-server ]; then 
    echo "Installing required apt packages ... [2/10]"
else 
    apt-get install openssh-server -y 
    echo "Installing required apt packages ... [2/10]"
fi
if [ -d /usr/share/locales ]; then 
    locale-gen en_US.UTF-8
else
    apt install -y locales
    locale-gen en_US.UTF-8  

fi
if [ -f /usr/bin/expect ]; then 
    echo "Installing required apt packages ... [3/10]"
else 
    apt-get install expect -y 
    echo "Installing required apt packages ... [3/10]"
fi
echo "Installing required apt packages ... [4/10]"
apt-get install tigervnc-standalone-server -y
echo "Installing required apt packages ... [5/10]"
echo "Installing required apt packages ... [6/10]"
echo "Installing required apt packages ... [7/10]"

if [ -f /usr/sbin/lightdm ]; then 
    echo "Installing required apt packages ... [8/10]"
else 
    apt-get install lightdm -y 
    echo "Installing required apt packages ... [8/10]"
fi
if [ -d /etc/X11 ]; then
    echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
else
    mkdir /etc/X11
    echo "/usr/sbin/lightdm" > /etc/X11/default-display-manager
    echo "Installing required apt packages ... [9/10]"
    echo "Installing required apt packages ... [10/10]"
fi
if [ -d /usr/lib/xorg ]; then
    echo "Installing required apt packages ... [9/10]"
else
    echo "Installing required apt packages ... [9/10]"
    apt install -y xauth
    apt install -y xorg openbox
   
fi
if [ -f /usr/bin/xauth ]; then
    echo "Installing required apt packages ... [10/10]"
else
    echo "Installing required apt packages ... [10/10]"
    apt install -y xauth
fi
if [ -f /root/.XAuthority ]; then
    mv /root/.XAuthority /root/.XAuthority_Backup
    touch /root/.XAuthority
    xauth generate :0 . trusted
else
    touch /root/.XAuthority
    xauth generate :0 . trusted 
fi
echo "set shared/default-x-display-manager lightdm" | debconf-communicate
DEBIAN_FRONTEND=noninteractive apt install xfce4 xfce4-goodies -y

echo "downloading latest Anaconda3 installation script"
mkdir /tmp/DFL_install
TMP_DIR="/tmp/DFL_install"
DL_CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.07-Linux-x86_64.sh"
DL_DFL="https://slgodwyn:holliday954@github.com/nagadit/DeepFaceLab_Linux.git"
CONDA_PATHS=("/opt" "/root")
CONDA_NAMES=("/ana" "/mini")
CONDA_VERSIONS=("3" "2")
CONDA_BINS=("/bin/conda" "/condabin/conda")
DIR_CONDA="/root/anaconda"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=false
ENV_NAME="deepfacelab"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=true
script_name='anaconda.sh'
env_path='/root/anaconda'
curl $DL_CONDA -s -o $script_name
echo "Creating Conda environment configured for DeepFaceLab 2.0"
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name

source $DIR_CONDA/etc/profile.d/conda.sh
$CONDA_EXECUTABLE init bash
source /root/.bashrc

cd /root
git clone --depth 1 --no-single-branch "$DL_DFL"
cd /root/DeepFaceLab_Linux
git clone --depth 1 --no-single-branch https://github.com/slgodwyn/DeepFaceLab.git
curl https://raw.githubusercontent.com/slgodwyn/dfl/main/dfl.yml -o /root/dfl.yml
conda env create -f /root/dfl.yml

echo "export DFL_WORKSPACE="/root/DeepFaceLab_Linux/workspace"" >> /root/.bashrc
echo "export DFL_PYTHON="python3.7"" >> /root/.bashrc
echo "export DFL_SRC="/root/DeepFaceLab_Linux/DeepFaceLab"" >> /root/.bashrc
echo "export scripts="/root/DeepFaceLab_Linux/scripts"" >> /root/.bashrc
echo "export work="/root/DeepFaceLab_Linux/workspace"" >> /root/.bashrc
echo "alias env=‘cd $scripts && conda activate deepfacelab‘" >> ~/.bashrc
DFL_WORKSPACE="/root/DeepFaceLab_Linux/workspace"" >> /root/.bashrc
DFL_SRC="/root/DeepFaceLab_Linux/DeepFaceLab"" >> /root/.bashrc
mkdir $DFL_WORKSPACE
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src/aligned
mkdir $DFL_WORKSPACE/data_src/aligned_debug
mkdir $DFL_WORKSPACE/data_dst
mkdir $DFL_WORKSPACE/data_dst/aligned
mkdir $DFL_WORKSPACE/data_dst/aligned_debug
mkdir $DFL_WORKSPACE/model

vncserver
vncserver -kill :1

if [ -d /root/.vnc ]; then
    touch /root/.vnc/xstartup
else
     mkdir /root/.vnc
     touch /root/.vnc/xstartup
fi

cat << EOF > /root/.vnc/xstartup
#!/bin/sh
export QT_PLUGIN_PATH="/root/anaconda/pkgs/qt-5.9.7-h5867ecd_1/plugins"

xrdb /root/.Xresources
dbus-launch startxfce4 &
EOF 

mkdir /etc/vncserver
touch /etc/vncserver/vncservers.conf
cat << EOF > /etc/vncserver/vncservers.conf
VNCSERVERS="1:root"
VNCSERVERARGS[1]="-geometry 1440x900 -depth 24"
EOF

awk '$1=="#AllowTcpForwarding"{foundLine=1; print "AllowTcpForwarding yes"} $1!="#AllowTcpForwarding"{print $0} END{if(foundLine!=1) print "permitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config

awk '$1=="#TCPKeepAlive"{foundLine=1; print "TCPKeepAlive yes"} $1!="#TCPKeepAlive"{print $0} END{if(foundLine!=1) print "permitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config

echo "PermitOpen any" >> /etc/ssh/sshd_config

/etc/init.d/ssh restart

vncserver :1

if [ -f /usr/sbin ]; then 
    ifconfig
else 
    apt install -y net-tools
    ifconfig
fi

cd /root/Desktop
wget https://d13lb3tujbc8s0.cloudfront.net/onlineinstallers/qt-unified-linux-x64-4.1.1-online.run
chmod +x qt-unified-linux-x64-4.1.1-online.run
echo "run in xfce4-terminal on vnc display: {$~ sh qt-opensource-linux-x64-5.7.0.run}
cat << EOF > next.txt
Next Step:
start ssh tunnel on host with cmd: ssh -L 5901:172.17.0.2:5901 -L 5902:172.17.0.3:5901 -L 5903:172.17.0.4:5901 -p $SERVER_PORT root@$SERVER_IP
connect on 127.0.0.1:5901 with authentication set to vncpasswd
EOF

cat next.txt
