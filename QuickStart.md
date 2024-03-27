# Quick Start for Conda Environment
If you are not interested in how HPC operates, and just want to set up a python environment to run your code, then use the following steps to get started.
## Interactive Sessions
### First Time Setup
#### Step1: Connect to NYU VPN/Wifi, log in to greene in terminal/vscode
```
ssh <netid>@greene.hpc.nyu.edu
```
#### Step2: Change to your scratch directory
You should always save your data in scratch directory.<br>
Replace `<netid>` with your own.

```
cd /scratch/<netid>
```

#### Step3: Request an interactive CPU/GPU session
It's always a good practice to request for a CPU/GPU node before running any code. <br> 
Download the shell script I wrote for requesting CPU/GPU nodes.
```
wget https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/chsdevice.sh
chmod +rx chsdevice.sh
```
Run the script to request a CPU/GPU node.
```
./chsdevice.sh
```
(fun fact: chs stands for cheatsheet. Typing the full name is too tiring.)

<details>
	<summary style="color:orange">What runtime configuration shall I use?</summary>
	- `CPU number`: In most cases, having 1 or 2 is sufficient.<br>
	- `GPU number`: Should be based on your project. If you don't know GPU parallel computing, then require for 1, or 0 for no GPU.<br>
	- `GPU Type`: A100 40GB is the fastest but you have to wait for a long time to get allocated; V100 32GB is in the middle, RTX8000 48GB is the slowest, but easy to get access.
	- `Memory (GB)`: This is the memory for CPUs. 64 works in most cases.
	- `Time (hours)`: This is the maximum time you can use the CPU/GPU node. I recommend 4 or 6 hours.
</details>


#### Step4: Setup the singularity environment with conda
You can consider `singularity` as a container that wraps up all small programs in python libraries into one large file. In this way, you won't be bothered with errors cause by exceeding quota of file number. <br>
Good news is that you don't have to setup singularity with conda installed from scratch any more. <br>
Download the shell script for setting and launching singularity.
```
wget https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/chslauncher.sh
chmod +rx chslauncher.sh
```
Run the script to setup singularity and conda.
```
./chslauncher.sh
```
<details>
	<summary style="color:orange">What do these prompted options mean during installation?</summary>
	- `Name Your Singularity Folder`: Since you can have multiple singularity environments, you should give a unique name to your singularity folder. <span style="color:orange">You will use this name to activate your singularity environment.</span> It's a good practice to set up a new singularity environment for each project.<br>
	- `cuda version`: This should be based on your project. If not specified, cuda 11.8 works for most cases.<br>
	- `Size of overlay`: This decides how large and how many python libraries you can install. For LLM or Diffusers projects, I empirically recommand `overlay-50G-10M`.
	- `Open on demand jupyter notebook?`: The way of running jupyter notebook on hpc is using `open on demand`. Some operations need to be done to enable your conda environment to be recognized by notebook. Type 'y' to let the script do the work for you.
</details>

#### Step5: Activate the singularity and conda environment
Run the sample script again, and type in your singularity folder name that you created in the previous step.
```
./chslauncher.sh
```
If you see your terminal prompt changes to `singularity:~$`, then you are successfully activated the singularity environment. <br>
Now you can activate conda by typing
```
source /ext3/env.sh
```
**I didn't include this in the shell script because it's important to remember activating conda each time you enter a singularity overlay.**<br>
<details>
	<summary style="color:orange">What's the different between Read and Write mode?</summary>
	- `Read and Write`: You can add files into the singularity. This is useful when you are setting up your conda environment. However, one singularity overlay can only be written by one process at a time. <br>
	- `Read only`: You can only read the files in the singularity environment. This is useful when you want to use a pre-built singularity environment.
</details>

#### Step6: Double check the conda environment, and start coding
When this script is finished, you will see a new folder in your scratch directory named as your singularity folder name. That's where everything used for running python is stored.


Once you activated your conda environment inside singularity using `source /ext3/env.sh`, check your conda path by
```
which conda
```
If you see `/ext3/miniconda3/bin/conda`, then you are good to go. <br>

If you get message like `Illegal option --` `Usage: /usr/bin/which [-a] args`, Don' panic, run 
```
unset -f which
```
Then type `which conda` again. <br>

You can also check python and pip using `which python` and `which pip`. Their path should be `/ext3/miniconda3/bin/python` and `/ext3/miniconda3/bin/pip` respectively. <br>

Now you are all set. Install your python libaries, and run python using `python file.py`, just like you do in the terminal on your local machine. <br>Note that vscode python debugger won't work in HPC, so you have to test the code in vscode integrated terminal.

***
**If you want to quit the singularity, or meet any other problems, check the [trouble shooting](Troubleshooting.md) guide.**

### Afterwards
The next time you login to HPC after setting up, all you need to do are:

Change to your scratch directory
```
cd /scratch/<netid>
```

Request a CPU/GPU node
```
./chsdevice.sh
```

Activate/Create the singularity environment
```
./chslauncher.sh
```

Activate conda inside singularity (and also activate/create your conda environment if necessary)
```
source /ext3/env.sh
```

Then you can start testing your python scripts. Just that easy.

## Open On Demand Jupyter Notebook 
To run jupyter notebook on HPC, you have to use [open on demand](https://ood.hpc.nyu.edu/).

The [official ood guide](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/open-ondemand-ood-with-condasingularity#h.pjqb0en5ivqf) has a nice illustration on how to use the gui. 

You don't need to be bothered with steps for setting up singularity and conda environment in the offical guide, if you follow the instructions below:

You need to create a python environment that can be recognized by the notebook. Everything is the same as setting up/opening singularity environment for interactive sessions. 

The only thing you should notice that type 'y' if prompted `Do you want to use this python environment in open on demand jupyter notebook?` when setting up a new singularity, or select `setup this environment for jupyter notebook in OOD` when launching existing singularity environment. 

This should only be done once for each singularity.

If you want to install package in the conda environment in order to use then in jupyter notebook, remember to activate 
```
conda activate base
```
Empirically, if you don't, your package will not be recognized in jupyter notebook. All packages you installed using `!pip` inside notebook will go to `/home/$USER/.local`, which will probably exceed your quota.