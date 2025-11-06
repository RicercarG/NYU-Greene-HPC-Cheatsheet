#!/bin/bash

#SBATCH --job-name=YourNameHere
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=64GB
#SBATCH --time=6:00:00         # max time for running this job
#SBATCH --gres=gpu:1           # request for any gpu available

# The following flags are disabled. Change to #SBATCH if you want to enable them
##SBATCH --gres=gpu:rtx8000:4     # [alternative]request for gpu(s) with specific type
##SBATCH --output=log/slurm-%j.out # [optional] output log file, need to create a folder named log
##SBATCH --account=pr_000_tandon_advanced # [optional] type in your project account if you have any. Maybe ask your professor for priority accout.
##SBATCH --mail-type=END
##SBATCH --mail-user=your.email@nyu.edu # [optional] Change to your email account. You will receive an email if your sbatch job ends

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

