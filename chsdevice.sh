#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")

is_integer() {
  [[ $1 =~ ^[0-9]+$ ]]
}

GREEN='\033[0;32m'
GRAY='\033[0;30m'
NC='\033[0m' # No Color

echo "Allocating device runtime"
read -p "How many CPUs do you want? " num_cpu
if ! is_integer "$num_cpu"; then
  echo "Error: Input is not an integer."
  exit 1
fi
if [ "$num_cpu" -ne 0 ]; then
  read -p "How many GPUs do you want? (Type 0 to use CPU only): " num_gpu
  if ! is_integer "$num_gpu"; then
    echo "Error: Input is not an integer."
    exit 1
  fi
  if [ "$num_gpu" -ne 0 ]; then
    echo "What GPU do you want":
    options=("rtx8000" "v100" "a100" "h100")
    select opt in "${options[@]}"; do
      case $opt in
      "rtx8000")
        gpu_type="rtx8000"
        break
        ;;
      "v100")
        gpu_type="v100"
        break
        ;;
      "a100")
        gpu_type="a100"
        break
        ;;
      "h100")
        gpu_type="h100"
        break
        ;;
      *)
        echo "Invalid option"
        exit 1
        ;;
      esac
    done
  fi
  read -p "How much memory (GB) do you want? (Enter integer only): " mem
  if ! is_integer "$mem"; then
    echo "Error: Input is not an integer."
    exit 1
  fi
  read -p "How long (hours) will you use these device? (Enter integer only): " time
  if ! is_integer "$time"; then
    echo "Error: Input is not an integer."
    exit 1
  fi

  # load the account if possible
  if [ -f "$script_dir/account.txt" ]; then
    account=$(cat "$script_dir/account.txt")
  else
    account=""
  fi

  # write the base command
  cmd="srun --nodes=1 --cpus-per-task="$num_cpu" --mem="$mem"GB --time="$time":00:00"

  # request for gpu if necessary
  if [ "$num_gpu" -ne 0 ]; then
    cmd="$cmd --gres=gpu:"$gpu_type":"$num_gpu""
  fi

  # add account name if there's any
  if [ ${#account} -ne 0 ]; then
    cmd="$cmd --account="$account""
    echo -e "${GREEN}Requesting device with project account $account ${NC}"
  fi

  # add interactive flag
  cmd="$cmd --pty /bin/bash"

  # run the final command to ask for devices
  eval "$cmd"

else
  echo "Device allocation is skipped."
fi
