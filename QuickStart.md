# Quick Start for Conda Environment
If you are not interested in how HPC operates, and just want to set up a python environment to run your code, then use the following steps to get started.
## Interactive Sessions
#### Step1: Log in to greene
```
ssh <netid>@greene.hpc.nyu.edu
```
#### Step2: Change to your scratch directory
HPC Greene grants you an extremely small disk quota of `space50GB/files30K` in your home directory, which is not sufficient for storing your project and python libraries. You should always save your data in scratch directory.<br>
Replace <netid> with your own.

```
cd /scratch/<netid>
```

#### Step3: Request an interactive CPU/GPU session
It's always a good practice to request for a CPU/GPU node before running any code. I wrote a shell script to help you request a CPU/GPU node.
```
wget https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/HPC_DEVICE_REQUEST.sh
chmod +rx HPC_DEVICE_REQUEST.sh
```
(You only need to run the previous download command once. After that, you can run the following command to request a CPU/GPU node.)
```
./HPC_DEVICE_REQUEST.sh
```


#### Step4: Setup the singularity environment with conda
You can consider `singularity` as a container that wraps up all small programs in python libraries into one large file. In this way, you won't be bothered with errors cause by exceeding quota of file number. <br>
Good news is that you don't have to setup singularity with conda installed from scratch any more. <br>
Download the shell script I wrote, and it will do all the work for you.
```
wget https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/HPC_SING_LAUNCHER.sh
chmod +rx HPC_SING_LAUNCHER.sh
```
(You only need to run the previous download command once.)
```
./HPC_SING_LAUNCHER.sh
```
<details>
	<summary>What do these prompted options mean during installation?</summary>
	- `Name Your Singularity Folder`: Since you can have multiple singularity environments, you should give a unique name to your singularity folder. You will use this name to activate your singularity environment. It's a good practice to set up a new singularity environment for each project.<br>
	- `cuda version`: This should be based on your project. If not specified, cuda 11.8 works for most cases.<br>
	- `Size of overlay`: This decides how large and how many python libraries you can install. For LLM or Diffusers projects, I empirically recommand `overlay-50G-10M`.
</details>

#### Step5: Activate the singularity and conda environment
Run the sample script again, and type in your singularity folder name that you created in the previous step.
```
./HPC_SING_LAUNCHER.sh
```
<details>
	<summary>What's the different between Read and Write mode?</summary>
	- `Read and Write`: You can add files into the singularity. This is useful when you are setting up your conda environment. However, one singularity overlay can only be written by one process at a time. <br>
	- `Read only`: You can only read the files in the singularity environment. This is useful when you want to use a pre-built singularity environment.
</details>