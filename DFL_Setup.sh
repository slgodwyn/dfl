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

}

check_conda_locations() {
    # Check common conda install locations
    retval=false
    for path in "${CONDA_PATHS[@]}"; do
        for name in "${CONDA_NAMES[@]}" ; do
            foldername="$path${name}conda"
            for vers in "${CONDA_VERSIONS[@]}" ; do
                for bin in "${CONDA_BINS[@]}" ; do
                    condabin="$foldername$vers$bin"
                    if check_file_exists "$condabin" ; then
                        set_conda_dir_from_bin "$condabin"
                        CONDA_EXECUTABLE="$condabin";
                        retval=true
                        break 4
                    fi
                done
            done
        done
    done
    $retval
}

CONDA_EXECUTABLE="${DIR_CONDA}/bin/conda"
if ! check_file_exists "$CONDA_EXECUTABLE" ; then CONDA_TO_PATH=true ; fi

conda_install() {
    # Download and install Mini Conda3
script_name='anaconda.sh'
env_path='$HOME/anaconda'
# download the installation script
echo "Downloading conda installation script..."
curl $DL_CONDA -s -o $script_name
# create temporary conda installation
echo "conda installation..."
TMPDIR=$TMP_DIR bash $script_name -b -f -p $env_path >> /dev/null
rm $script_name
        if $CONDA_TO_PATH ; then
            info "Adding anaconda to PATH..."
            yellow ; "$CONDA_EXECUTABLE" init
            "$CONDA_EXECUTABLE" config --set auto_activate_base false
        fi
    fi
}

create_env() {
    # Create Python 3.8 env for DFL
    delete_env
    info "Creating Conda Virtual Environment..."
    yellow ; "$CONDA_EXECUTABLE" create -n DFL -c main python=3.7 cudnn=7.6.5 cudatoolkit=10.1.243 -y
}


activate_env() {
    # Activate the conda environment
    # shellcheck source=/dev/null
    source "$DIR_CONDA/etc/profile.d/conda.sh" activate
    conda activate "$ENV_NAME"
}

install_git() {
    # Install git inside conda environment
    info "Installing Git..."
    yellow ; conda install git -q -y
}


clone_DFL() {
    # Clone the DFL repo
    info "Downloading DFL..."
    yellow ; git clone --depth 1  "$DL_DFL"
    cd DeepFaceLab_Linux
     git clone --depth 1 https://github.com/iperov/DeepFaceLab.git
     python -m pip install -r ./DeepFaceLab/requirements-cuda.txt
}

conda_install
create_env
activate_env
install_git
clone_DFL
