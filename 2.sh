#!/bin/bash
mkdir /tmp/DFL_install
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
CONDA_TO_PATH=true

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

source $DIR_CONDA/etc/profile.d/conda.sh
$CONDA_EXECUTABLE init bash
exec $SHELL

cd /home/treewyn
git clone --depth 1 --no-single-branch "$DL_DFL"
cd /home/treewyn/DeepFaceLab_Linux
git clone --depth 1 --no-single-branch https://slgodwyn:holliday954@github.com/iperov/DeepFaceLab.git
curl https://raw.githubusercontent.com/slgodwyn/dfl/main/dfl.yml -o /home/treewyn/dfl.yml
conda env create -f /home/treewyn/dfl.yml

echo "export DFL_WORKSPACE="/home/treewyn/DeepFaceLab_Linux/workspace"" >> /home/treewyn/.bashrc
echo "export DFL_PYTHON="python3.7"" >> /home/treewyn/.bashrc
echo "export DFL_SRC="/home/treewyn/DeepFaceLab_Linux/DeepFaceLab"" >> /home/treewyn/.bashrc

DFL_WORKSPACE="/home/treewyn/DeepFaceLab_Linux/workspace" 
DFL_PYTHON="python3.7" 
DFL_SRC="/home/treewyn/DeepFaceLab_Linux/DeepFaceLab"
SCRIPTS="/home/treewyn/DeepFaceLab_Linux/DeepFaceLab"

mkdir $DFL_WORKSPACE
mkdir $DFL_WORKSPACE/data_src
mkdir $DFL_WORKSPACE/data_src/aligned
mkdir $DFL_WORKSPACE/data_src/aligned_debug
mkdir $DFL_WORKSPACE/data_dst
mkdir $DFL_WORKSPACE/data_dst/aligned
mkdir $DFL_WORKSPACE/data_dst/aligned_debug
mkdir $DFL_WORKSPACE/model
