#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")
root_dir="/scratch/$USER"

# Extract the whole data directory for singularity binding
IFS='/' read -ra root_dir_list <<< "$root_dir"
data_dir="/${root_dir_list[1]}/${root_dir_list[2]}"

if [[ "$*" == *"--no-check-certificate"* ]]; then
    nocheck="--no-check-certificate"
else
    nocheck=""
fi


used_for_ood=0
install_new_env=1
install_new_conda=1

GREEN='\033[0;32m'
GRAY='\033[0;30m'
NC='\033[0m' # No Color

echo -e "Creating/Activating singularity environment ${GRAY}(no space allowed in folder name)${NC}"
read -p "Singularity Folder Name: " folder_name

env_dir="$root_dir/$folder_name"

# Check if folder exists
if [ -d $env_dir ]; then
    echo "$folder_name is found."
    singularity_file=$(find "$env_dir" -type f -name "*cuda*" | head -n 1)
    overlay=$(find "$env_dir" -type f -name "*overlay*" | head -n 1)
    echo -e  "Overlay found at ${GREEN}$overlay${NC}"
    echo -e "Singularity file found at ${GREEN}$singularity_file${NC}"
    options=("start singularity env in read only mode" "start singularity env in read and write mode" "setup this environment for jupyter notebook in OOD" "reinstall singularity env" "reinstall conda inside the singularity" "exit")
    select opt in "${options[@]}"; do
        case $opt in
            "start singularity env in read only mode")
                echo "Entering singularity $folder_name in read only mode"
                echo "Always remember to activate your conda environment by typing: source /ext3/env.sh"
                singularity exec --nv --bind $data_dir --overlay $overlay:ro $singularity_file /bin/bash
                exit 1
                break
                ;;
            "start singularity env in read and write mode")
                echo "Entering singularity $folder_name in read and write mode"
                echo "Always remember to activate your conda environment by typing: source /ext3/env.sh"
                singularity exec --nv --bind $data_dir --overlay $overlay:rw $singularity_file /bin/bash
                exit 1
                break
                ;;
            "setup this environment for jupyter notebook in OOD")
                install_new_env=0
                install_new_conda=0
                used_for_ood=1
                break
                ;;
            "reinstall singularity env")
                read -p "All python packages installed in this singularity environment will be removed. Are you sure to reinstall it? [y]/n: " warning
                # Convert the input to lowercase
                warning=$(echo "$warning" | tr '[:upper:]' '[:lower:]')

                # Check if the input is 'y' or 'yes', set boolean variable accordingly
                if [[ "$warning" == "y" || "$warning" == "yes" ]]; then
                    rm -rf $env_dir
                    rm -rf ~/.local/share/jupyter/kernels/$folder_name
                else
                    exit 1
                fi
                break
                ;;
            "reinstall conda inside the singularity")
                read -p "All python packages installed in the conda (if exists) will be removed. Are you sure to reinstall it? [y]/n: " warning
                # Convert the input to lowercase
                warning=$(echo "$warning" | tr '[:upper:]' '[:lower:]')

                # Check if the input is 'y' or 'yes', set boolean variable accordingly
                if [[ "$warning" == "y" || "$warning" == "yes" ]]; then
                    anaconda-clean --yes
                    install_new_env=0
                else
                    exit 1
                fi
                break
                ;;
            "exit")
                exit 1
                ;;
            *) 
                echo "Invalid option"
                exit 1
                ;;
        esac
    done
else
    echo "No existing $folder_name found. Start creating a new one"
fi

if [ $install_new_env -eq 1 ]; then
    # Create folder
    mkdir -p $env_dir

    # Check if folder creation was successful
    if [ $? -eq 0 ]; then
        echo "Folder \"$folder_name\" created successfully."
    else
        echo "Failed to create folder \"$folder_name\"."
        exit 1
    fi

    CUSTOM_BUILD=0  

    # choose what cuda version for your ubuntu system
    echo "Choose the cuda version":
    options=("cuda 11.3" "cuda 11.6" "cuda 11.8" "cuda 12.1" "Custom CUDA version (build from Docker Hub)")
    select opt in "${options[@]}"; do
        case $opt in
            "cuda 11.3")
                singularity_file="cuda11.3.0-cudnn8-devel-ubuntu20.04.sif"
                # Add actions for the "large" option here
                break
                ;;
            "cuda 11.6")
                singularity_file="cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif"
                # Add actions for the "small" option here
                break
                ;;
            "cuda 11.8")
                singularity_file="cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif"
                break
                ;;
            "cuda 12.1")
                singularity_file="cuda12.1.1-cudnn8.9.0-devel-ubuntu22.04.2.sif"
                break
                ;;
            "Custom CUDA version (build from Docker Hub)")
            read -rp "Enter CUDA major.minor (e.g. 12.4): " cuda_ver
            if [[ ! $cuda_ver =~ ^[0-9]+\.[0-9]+$ ]]; then
                echo "Invalid CUDA version format. Exiting."; exit 1; fi
            singularity_file="cuda-${cuda_ver}.sif"
            CUSTOM_BUILD=1
            break;;
            *)
                echo "Invalid option"
                exit 1
                ;;
        esac
    done

    if [ "$CUSTOM_BUILD" -eq 0 ]; then
    # Copy prebuilt campus image if not already present
    if [ ! -f "$env_dir/$singularity_file" ]; then
        cp -rp "/scratch/work/public/singularity/$singularity_file" "$env_dir/" 
    fi
    else
    # Build custom SIF from Docker Hub tag: nvidia/cuda:${cuda_ver}.0-devel-ubuntu22.04
    if [ ! -f "$env_dir/$singularity_file" ]; then
        echo "Building CUDA $cuda_ver image; this may take several minutes…"
        
        # Try different minor versions to find the best available tag
        major_minor=$(echo $cuda_ver | cut -d. -f1,2)
        minor_versions=("0" "1" "2" "3" "4" "5")
        
        build_success=false
        for minor in "${minor_versions[@]}"; do
            docker_tag="nvidia/cuda:${major_minor}.${minor}-devel-ubuntu22.04"
            echo "Attempting to build from Docker tag: $docker_tag"
            
            if singularity build "$env_dir/$singularity_file" "docker://$docker_tag"; then
                echo "Successfully built with tag: $docker_tag"
                build_success=true
                break
            else
                echo "Failed with tag $docker_tag, trying next minor version..."
            fi
        done
        
        if [ "$build_success" = false ]; then
            echo "Failed to build with any minor version for CUDA $cuda_ver"
            echo "Please check if CUDA $cuda_ver is available on Docker Hub."
            echo "You can check available tags at: https://hub.docker.com/r/nvidia/cuda/tags"
            exit 1
        fi
    fi
    fi


    # choose what singularity overlay
    echo "Choose the size of overlay, larger overlay allows you to install more python packages:"
    options=("overlay-25GB-500K.ext3" "overlay-50G-10M.ext3")
    select overlay in "${options[@]}"; do
        case $overlay in
            "overlay-25GB-500K.ext3")
                echo "Medium Size Overlay Selected"
                # Add actions for the "large" option here
                break
                ;;
            "overlay-50G-10M.ext3")
                echo "Large Size Overlay Selected"
                # Add actions for the "small" option here
                break
                ;;
            *) 
                echo "Invalid option"
                exit 1
                ;;
        esac
    done

    cp -rp /scratch/work/public/overlay-fs-ext3/$overlay.gz $env_dir
    echo "unzipping your singularity $overlay, it will take a long time, please be patient"
    gunzip -f $env_dir/$overlay.gz
    echo "unzip finished"

    overlay=$env_dir/$overlay
    singularity_file=$env_dir/$singularity_file
fi

if [ $install_new_conda -eq 1 ]; then
    # start overlay and download conda

    if [ "$CUSTOM_BUILD" -eq 1 ]; then
        # For custom builds, download Miniconda on host first since container has no wget
        echo "Downloading Miniconda installer on host..."
        wget $nocheck -O "$env_dir/Miniconda3-latest-Linux-x86_64.sh" \
            https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
        
        singularity exec --nv --bind $data_dir,$script_dir --overlay $overlay:rw $singularity_file /bin/bash -c "
        # Copy and install miniconda
        cp /mnt/$folder_name/Miniconda3-latest-Linux-x86_64.sh /ext3/
        bash /ext3/Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
        rm /ext3/Miniconda3-latest-Linux-x86_64.sh

        # Copy env.sh from script directory
        cp $script_dir/env.sh /ext3/env.sh

        # init conda
        source /ext3/env.sh

        # Install essential tools for custom builds
        conda install -c conda-forge -y git nano wget curl
    else
        # For prebuilt images, use wget inside container
        singularity exec --nv --bind $data_dir,$script_dir --overlay $overlay:rw $singularity_file /bin/bash -c "
        # download and install miniconda
        wget $nocheck https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

        bash Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
        rm Miniconda3-latest-Linux-x86_64.sh

        # Copy env.sh from script directory
        cp $script_dir/env.sh /ext3/env.sh

        # init conda
        source /ext3/env.sh

        echo 'setting up base conda environment'

        conda update -n base conda -y
        conda clean --all --yes
        conda install pip -y
        conda install ipykernel -y

        unset -f which

        echo 'conda installed'
        which conda
        which pip
        "
    fi

    read -p "Do you want to use this python environment in open on demand jupyter notebook? [y]/n: " answer
    # Convert the input to lowercase
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    # Check if the input is 'y' or 'yes', set boolean variable accordingly
    if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
        used_for_ood=1
    else
        used_for_ood=0
    fi
fi

if [ $used_for_ood -eq 1 ]; then
    mkdir -p ~/.local/share/jupyter/kernels
    cd ~/.local/share/jupyter/kernels
    cp -R /share/apps/mypy/src/kernel_template ./$folder_name # this should be the name of your Singularity env
    cd ./$folder_name
    old_word="/path/to/overlay.ext3"
    new_word="$overlay"
    sed -i "s#$old_word#$new_word#g" "./python"
    old_word="/scratch/work/public/singularity/OS.sif"
    new_word="$singularity_file"
    sed -i "s#$old_word#$new_word#g" "./python"

    old_word="PYTHON_LOCATION"
    new_word="/home/$USER/.local/share/jupyter/kernels/$folder_name/python"
    sed -i "s#$old_word#$new_word#g" "./kernel.json"
    old_word="KERNEL_DISPLAY_NAME"
    new_word="$folder_name"
    sed -i "s#$old_word#$new_word#g" "./kernel.json"
fi

echo -e "${GREEN}You are all set!${NC}"
echo -e  "Overlay is stored at ${GREEN}$overlay${NC}"
echo -e "Singularity file is stored at ${GREEN}$singularity_file${NC}"
echo
echo -e "To start the singularity, type ${GREEN}chslauncher.sh${NC} or ${GREEN}clc${NC} to run this script again"
echo -e "${GRAY}You can also manually start this singularity using:"
echo -e "singularity exec --nv --bind $data_dir --overlay $overlay:rw $singularity_file /bin/bash${NC}"



