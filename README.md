# NYU-Greene-HPC-Cheatsheet
A beginner guide for getting started with nyu greene hpc

## This repo is still under construction
* Quick Starting Pack
	[ ] Connect to HPC
	[ ] Request CPU/GPU Sessions
	[x] Interactive sessions for conda
	[ ] Batch jobs
	[ ] Jupyter Notebook
* Manual Setup
	[ ] Recommended tools to learn
	[x] Offical guide links
	[ ] Set up your own singularity and conda
	[ ] Set up your own jupyter notebook
* Trouble Shooting
	[x] Disk quota exceeded
	[x] Could not login server through vscode
	[x] Out of Memory Error
	[ ] Could not open singularity environment
* Useful Tricks
	[ ] Setup bashrc
	[ ] Setup ssh key pairs
	[x] File management commands
	[ ] Access through ipad

## Quick Start
If you are not interested in how HPC operates, and just want to set up a python environment to run your code, then use the following steps to get started.
### Interactive Sessions
* Step1: Log in to greene
```
ssh <netid>@greene.hpc.nyu.edu
```
* Step2: change to your scratch directory
HPC Greene grants you an extremely small disk quota of `space50GB/files30K` in your home directory, which is not sufficient for storing your project and python libraries. You should always save your data in scratch directory.

```
cd /scratch/<netid>
```
* Step3: setup the singularity environment with conda
You can consider `singularity` as a container that wraps up all small programs in python libraries into one large file. In this way, you won't be bothered with errors cause by exceeding quota of file number. <br>
Good news is that you don't have to setup singularity with conda installed from scratch any more. <br>
Download the shell script I wrote, and it will do all the work for you.
```
wget https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/launcher.sh
chmod +rx launcher.sh
./launcher.sh
```
<details>
	<summary>What do these prompted options mean during installation?</summary>
	* `Name Your Singularity Folder`: Since you can have multiple singularity environments, you should give a unique name to your singularity folder. You will use this name to activate your singularity environment. It's a good practice to set up a new singularity environment for each project.
	* `cuda version`: This should be based on your project. If not specified, cuda 11.8 works for most cases.
	* `Size of overlay`: This decides how large and how many python libraries you can install. For LLM or Diffusers projects, I empirically recommand `overlay-50G-10M`.
</details>

* Step4: Activate the singularity and conda environment
Run the sample script again, and type in the name of your singularity folder that you have created in the previous step.
```
./launcher.sh
```
<details>
	<summary>What's the different between Read and Write mode?</summary>
	* `Read and Write`: You can add files into the singularity. This is useful when you are setting up your conda environment. However, one singularity overlay can only be written by one process at a time.
	* `Read only`: You can only read the files in the singularity environment. This is useful when you want to use a pre-built singularity environment.
</details>



## Table of Contents
* [Manual Setup](MaunalSetup.md)
* [Trouble Shooting](TroubleShooting.md)
* [Useful Tricks](UsefulTricks.md)

## Acknowledgement
* [HPC Home](https://sites.google.com/nyu.edu/nyu-hpc/home?authuser=0)
* I started my journey with HPC by following [HPC Notes by Hammond Liu](https://abstracted-crime-34a.notion.site/63aae4cc39904d11a5c744f480a42017?v=261a410e1fe24d0294ed744c21a41015&p=7ed5e95ce1dc400898f6462f6de47d2c&pm=s)