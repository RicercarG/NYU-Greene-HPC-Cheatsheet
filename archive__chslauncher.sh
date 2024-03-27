#!/bin/bash

root_dir=$(dirname "$(realpath "$0")")

# Extract the whole data directory for singularity binding
IFS='/' read -ra root_dir_list <<< "$root_dir"
data_dir="/${root_dir_list[1]}/${root_dir_list[2]}"

echo "Singularity Folder Name: (type anything if you want to create a new one, no space allowed)"
read folder_name

env_dir="$root_dir/$folder_name"

# Check if folder exists
if [ -d $env_dir ]; then
    echo "$folder_name is found. Select the next operation":
    options=("start singularity env in read only mode" "start singularity env in read and write mode" "reinstall singularity env")
    select opt in "${options[@]}"; do
        case $opt in
            "start singularity env in read only mode")
                singularity_file=$(find "$env_dir" -type f -name "*cuda*" | head -n 1)
                overlay=$(find "$env_dir" -type f -name "*overlay*" | head -n 1)
                echo "Entering singularity $folder_name in read only mode"
                echo "Always remember to activate your conda environment by typing: source /ext3/env.sh"
                singularity exec --nv --bind $data_dir --overlay $overlay:ro $singularity_file /bin/bash
                exit 1
                break
                ;;
            "start singularity env in read and write mode")
                singularity_file=$(find "$env_dir" -type f -name "*cuda*" | head -n 1)
                overlay=$(find "$env_dir" -type f -name "*overlay*" | head -n 1)
                echo "Entering singularity $folder_name in read and write mode"
                echo "Always remember to activate your conda environment by typing: source /ext3/env.sh"
                singularity exec --nv --bind $data_dir --overlay $overlay:rw $singularity_file /bin/bash
                exit 1
                break
                ;;
            "reinstall singularity env")
                warnings=("Yes, delete the current folder" "No, get me out of here")
                select warn in "${warnings[@]}"; do
                    case $warn in
                        "Yes, delete the current folder")
                            rm -rf $env_dir
                            break
                            ;;
                        *)
                            exit 1
                            break
                            ;;
                    esac
                done
                break
                ;;
            *) 
                echo "Invalid option"
                exit 1
                ;;
        esac
    done

fi

# Create folder
echo "No existing $folder_name found. Start creating a new one"
mkdir $env_dir

# Check if folder creation was successful
if [ $? -eq 0 ]; then
    echo "Folder \"$folder_name\" created successfully."
else
    echo "Failed to create folder \"$folder_name\"."
    exit 1
fi

# choose what cuda version for your ubuntu system
echo "Choose the cuda version":
options=("cuda 11.3" "cuda 11.6" "cuda 11.8")
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
        *) 
            echo "Invalid option"
            exit 1
            ;;
    esac
done

cp -rp /scratch/work/public/singularity/$singularity_file $env_dir


# choose what singularity overlay
echo "Choose the size of overlay, larger overlay allows you to install more python packages:"
options=("overlay-25GB-500K" "overlay-50G-10M")
select overlay in "${options[@]}"; do
    case $overlay in
        "overlay-25GB-500K")
            echo "Medium Size Overlay Selected"
            # Add actions for the "large" option here
            break
            ;;
        "overlay-50G-10M")
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

cp -rp /scratch/work/public/overlay-fs-ext3/$overlay.ext3.gz $env_dir
echo "unzipping your singularity $overlay, it will take a long time, please be patient"
gunzip $env_dir/$overlay.ext3.gz
echo "unzip finished"


# start overlay and download conda
singularity exec --nv --bind $data_dir --overlay $env_dir/$overlay.ext3:rw $env_dir/$singularity_file /bin/bash -c "

# download and install miniconda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
rm Miniconda3-latest-Linux-x86_64.sh

wget -O /ext3/env.sh https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/env.sh

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

echo "You are all set! To start the singularity, type './chslauncher.sh' to run this script again"
echo "You can also manually start this singularity using:"
echo "singularity exec --nv --bind $data_dir --overlay $env_dir/$overlay.ext3:rw $env_dir/$singularity_file /bin/bash"
