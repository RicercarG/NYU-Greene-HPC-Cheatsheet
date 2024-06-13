#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")
bashrc_file="$HOME/.bashrc"

ssl_cert='export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt'

# Check if the line already exists in .bashrc
if ! grep -qF "$ssl_cert" ~/.bashrc; then
    # Append the line to .bashrc if it doesn't exist
    echo "$ssl_cert" >> ~/.bashrc
    echo "Added ssl certificate file to .bashrc"
else
    echo "ssl certificate file already exists in .bashrc"
fi


if ! echo "$PATH" | grep -q "$script_dir"; then
    echo "export PATH=\$PATH:$script_dir" >> ~/.bashrc
    source ~/.bashrc
    echo "NYU-Greene-HPC-Cheatsheet Directory added to PATH"
else
    echo "NYU-Greene-HPC-Cheatsheet Directory already in PATH"
fi

chmod +rx "$script_dir/chsdevice.sh"
chmod +rx "$script_dir/chslauncher.sh"

if ! grep -Fxq "alias cdv='$script_dir/chsdevice.sh'" "$bashrc_file"; then
    echo "alias cdv='$script_dir/chsdevice.sh'" >> "$bashrc_file"
    echo "Alias cdv for allocating device runtime is added to ~/.bashrc"
else
    echo "Alias cdv already exsits in ~/.bashrc"
fi

if ! grep -Fxq "alias clc='$script_dir/chslauncher.sh'" "$bashrc_file"; then
    echo "alias clc='$script_dir/chslauncher.sh'" >> "$bashrc_file"
    echo "Alias clc for launching singularity environment is added to ~/.bashrc"
else
    echo "Alias clc already exsits in ~/.bashrc"
fi

if ! grep -Fxq "alias se='source /ext3/env.sh'" "$bashrc_file"; then
    echo "alias se='source /ext3/env.sh'" >> "$bashrc_file"
echo "Alias se for source /ext3/env.sh is added to ~/.bashrc"
else
    echo "Alias se already exsits in ~/.bashrc"
fi

# apply changes
# source "$bashrc_file"

echo "NYU-Greene-HPC-Cheatsheet lazy launcher setup complete."