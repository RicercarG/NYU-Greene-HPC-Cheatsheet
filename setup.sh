#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")
bashrc_file="$HOME/.bashrc"

if ! echo "$PATH" | grep -q "$script_dir"; then
    echo "export PATH=\$PATH:$script_dir" >> ~/.bashrc
    source ~/.bashrc
    echo "Directory added to PATH."
else
    echo "Directory already in PATH."
fi

chmod +rx "$script_dir/chsdevice.sh"
chmod +rx "$script_dir/chslauncher.sh"

if ! grep -Fxq "alias cdv=\"$script_dir/chsdevice.sh\"" "$bashrc_file"; then
    echo "alias cdv=\"$script_dir/chsdevice.sh\"" >> "$bashrc_file"
    echo "Alias cdv for allocating device runtime is added to ~/.bashrc"
else
    echo "Alias cdv already exsits in ~/.bashrc"
fi

if ! grep -Fxq "alias clc=\"$script_dir/chslauncher.sh\"" "$bashrc_file"; then
    echo "alias clc=\"$script_dir/chslauncher.sh\"" >> "$bashrc_file"
    echo "Alias clc for launching singularity environment is added to ~/.bashrc"
else
    echo "Alias clc already exsits in ~/.bashrc"
fi

# apply changes
# source "$bashrc_file"

echo "NYU-Greene-HPC-Cheatsheet lazy launcher setup complete."