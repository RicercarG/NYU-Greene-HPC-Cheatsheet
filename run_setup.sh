#!/bin/bash
script_dir=$(dirname "$(realpath "$0")")

chmod +rx "$script_dir/setup.sh"
$script_dir/setup.sh
source $HOME/.bashrc