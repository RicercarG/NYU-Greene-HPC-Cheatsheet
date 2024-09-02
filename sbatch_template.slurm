#!/bin/bash

#SBATCH --job-name=YourNameHere
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=64GB
#SBATCH --time=6:00:00         # max time for running this job
#SBATCH --gres=gpu:1           # request for any gpu available
##SBATCH --gres=gpu:rtx8000:4     # [alternative]request for gpu(s) with specific type
##SBATCH --output=log/slurm-%j.out # [optional] output log file, need to create a folder named log

# Singularity path
ext3_path=YourEXT3PATH.ext3
sif_path=YourSIFPATH.sif

# start running
singularity exec --nv \
--overlay ${ext3_path}:ro \
${sif_path} /bin/bash -c "
    source /ext3/env.sh
    REPLACE THIS WITH YOUR COMMANDS
"