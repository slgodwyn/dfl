#!/bin/bash

echo "Run as root user"

apt update -y
apt dist-upgrade -y
apt-get install -y perl
apt-get install -y sudo 
apt-get install -y wget
apt-get install -y ffmpeg
apt-get install -y unzip
apt install xfce4 xfce4-goodies -y
apt install tightvncserver -y
apt-get install -y openssh-server
/etc/init.d/ssh start

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

    # Download and install Anaconda3
script_name='anaconda.sh'
env_path='$HOME/anaconda'
# download the installation script
echo "Downloading conda installation script..."
curl $DL_CONDA -s -o $script_name
# create temporary conda installation
echo "conda installation..."
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name

source $DIR_CONDA/etc/profile.d/conda.sh
$CONDA_EXECUTABLE init bash
exec $SHELL

cd $HOME
git clone --depth 1 --no-single-branch "$DL_DFL"
cd $HOME/DeepFaceLab_Linux
git clone --depth 1 --no-single-branch https://slgodwyn:holliday954@github.com/iperov/DeepFaceLab.git
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

vncserver
vncserver -kill :1

if [ -f ~/.vnc/xstartup ] 
then
    rm ~/.vnc.xstartup
else 
    echo "writing xstartup"
fi

cat << EOF > ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
dbus-launch startxfce4 &
EOF 

awk '$1=="#AllowTcpForwarding"{foundLine=1; print "AllowTcpForwarding yes"} $1!="#AllowTcpForwarding"{print $0} END{if(foundLine!=1) print "permitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config

awk '$1=="#TCPKeepAlive"{foundLine=1; print "TCPKeepAlive yes"} $1!="#TCPKeepAlive"{print $0} END{if(foundLine!=1) print "permitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config

echo "PermitOpen any" >> /etc/ssh/sshd_config

/etc/init.d/ssh restart

vncserver -geometry 900x600 -depth 24 :1

cat << EOF > next.txt
Next Step:
start ssh tunnel on host with cmd: ssh -L 5901:172.17.0.2:5901 -C -N -l USER YOUR_SERVER_IP
connect on 127.0.0.1:5901 with authentication set to vncpasswd
EOF

cat next.txt
