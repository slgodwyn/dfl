#!/bin/bash
TMP_DIR="/tmp/DFL_install"
DL_CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh"
DL_DFL="https://github.com/iperov/DeepFaceLab_Linux.git"

CONDA_PATHS=("/opt" "$HOME")
CONDA_NAMES=("/ana" "/mini")
CONDA_VERSIONS=("3" "2")
CONDA_BINS=("/bin/conda" "/condabin/conda")
DIR_CONDA="$HOME/anaconda"
CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
CONDA_TO_PATH=false
ENV_NAME="DFL"

CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
if ! check_file_exists "$CONDA_EXECUTABLE" ; then CONDA_TO_PATH=true ; fi

script_name='anaconda.sh'
env_path='$HOME/anaconda'
# download the installation script
echo "Downloading conda installation script..."
curl $DL_CONDA -s -o $script_name
# create temporary conda installation
echo "conda installation..."
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name
source "$DIR_CONDA/etc/profile.d/conda.sh" activate
$CONDA_EXECUTABLE init
$CONDA_EXECUTABLE config --set auto_activate_base false
 
$CONDA_EXECUTABLE" create -n DFL -c main python=3.7 cudnn=7.6.5 cudatoolkit=10.1.243 -y



conda activate "$ENV_NAME"
conda install git -q -y


git clone --depth 1  "$DL_DFL"
cd DeepFaceLab_Linux
git clone --depth 1 https://github.com/iperov/DeepFaceLab.git
python -m pip install -r ./DeepFaceLab/requirements-cuda.txt



