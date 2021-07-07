#!/bin/bash

apt-get install -y perl
apt-get install -y sudo
apt-get install -y wget
apt-get install -y ffmpeg
apt-get install -y unzip

pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -m -p "$pass" treewyn
usermod -aG sudo treewyn
su - treewyn

TMP_DIR="/tmp/DFL_install"
DL_CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh"
DL_DFL="https://slgodwyn:holliday954@github.com/nagadit/DeepFaceLab_Linux.git"

CONDA_PATHS=("/opt" "/home/treewyn")
CONDA_NAMES=("/ana" "/mini")
CONDA_VERSIONS=("3" "2")
CONDA_BINS=("/bin/conda" "/condabin/conda")
DIR_CONDA="/home/treewyn/anaconda"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=false
ENV_NAME="deepfacelab"

CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
if ! check_file_exists "$CONDA_EXECUTABLE" ; then CONDA_TO_PATH=true ; fi

    # Download and install Anaconda3
script_name='anaconda.sh'
env_path='/home/treewyn/anaconda'
# download the installation script
echo "Downloading conda installation script..."
curl $DL_CONDA -s -o $script_name
# create temporary conda installation
echo "conda installation..."
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name
$CONDA_EXECUTABLE init
   
source $DIR_CONDA/etc/profile.d/conda.sh activate
$CONDA_EXECUTABLE create -n $ENV_NAME -c main python=3.7 cudnn=7.6.5 cudatoolkit=10.1.243 -y
$CONDA_EXECUTABLE activate $ENV_NAME

$CONDA_EXECUTABLE install git -q -y

cd /home/treewyn
git clone --depth 1 --no-single-branch "$DL_DFL"
cd /home/treewyn/DeepFaceLab_Linux
git clone --depth 1 --no-single-branch https://slgodwyn:holliday954@github.com/iperov/DeepFaceLab.git
python -m pip install -r ./DeepFaceLab/requirements-cuda.txt

echo "export DFL_WORKSPACE="/home/treewyn/DeepFaceLab_Linux/workspace" >> ~/.bashrc
echo "export DFL_PYTHON="python3.7" >> ~/.bashrc
echo "export DFL_SRC="/home/treewyn/DeepFaceLab_Linux/deepfacelab" >> ~/.bashrc

DFL_WORKSPACE="/home/treewyn/DeepFaceLab_Linux/workspace" 
DFL_PYTHON="python3.7" 
DFL_SRC="/home/treewyn/DeepFaceLab_Linux/deepfacelab"

mkdir $DFL_WORKSPACE
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src/aligned
mkdir $DFL_WORKSPACE/data_src/aligned_debug
mkdir $DFL_WORKSPACE/data_dst
mkdir $DFL_WORKSPACE/data_dst/aligned
mkdir $DFL_WORKSPACE/data_dst/aligned_debug
mkdir $DFL_WORKSPACE/model

cd $DFL_WORKSPACE/model
wget https://github.com/chervonij/DFL-Colab/releases/download/GenericXSeg/GenericXSeg.zip
unzip GenericXSeg.zip -d $DFL_WORKSPACE/model/
cd /home/treewyn/DeepFaceLab_Linux/scripts


