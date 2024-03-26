# NYU-Greene-HPC-Cheatsheet
A beginner guide for getting started with running python on nyu greene hpc. 

## This repo is still under construction
* Prereq
	- [x] Apply for NYU Greene HPC access
	- [x] Basic Linux commands
	- [x] Vim
	- [x] Vscode
* Quick Starting Pack
	- [x] Connect to HPC
	- [x] Request CPU/GPU Sessions
	- [x] Interactive sessions for conda
	- [ ] Batch jobs
	- [ ] Jupyter Notebook
* Manual Setup
	- [x] Offical guide links
	- [ ] Set up your own singularity and conda
	- [ ] Set up your own jupyter notebook
* Trouble Shooting
	- [x] How can I quit python/singualrity/runtime?
	- [x] How can I jump back when kicked off by accident?
	- [x] Disk quota exceeded
	- [x] Could not login server through vscode
	- [x] Out of Memory Error
	- [ ] Could not open singularity environment
	- [ ] Some linux commands could not be executed
* Advanced Tricks
	- [ ] Setup bashrc
	- [ ] Setup ssh key pairs
	- [x] File management commands
	- [x] Access through iPad

## Prereq
### Apply for NYU Greene HPC access
Just follow the [official guide](https://www.nyu.edu/life/information-technology/research-computing-services/high-performance-computing/high-performance-computing-nyu-it/hpc-accounts-and-eligibility.html#eligibility). If you are an NYU student, you do need a faculty sponsor to apply for an account.

### Basic Linux commands
There are lots of linux beginner guide online. Pick anyone you like, for example the cheat sheet from [GeeksforGeeks](https://www.geeksforgeeks.org/linux-commands-cheat-sheet/). Or just ask chatGPT, it knows everything.

### Vim
Vim is the default text editor in HPC. It's not mendatory, but learning vim will make life much easier. I personally recommend this [guide](https://github.com/iggredible/Learn-Vim?tab=readme-ov-file). You can also learn vim through playing a [video game](https://vim-adventures.com/)

### Vscode
One of the killer features in vscode is being able to connect to a remote server easily. Even though I'm a fan of sublime and zed, I turn to vscode when using HPC. 


## Access HPC
### Option1: Connect through terminal
Open terminal app on your mac/windows/linux, and type
```
ssh <netid>@greene.hpc.nyu.edu
```
Replace <netid> with your own. You will be prompted to enter your password, which is the same as your nyu account. (Your password won't be shown on the screen, but it's still being typed in.) <br>
If you see your terminal prompt changes to `netid@log-n:~$`, then you are successfully logged in.


### Option2: Connect through vscode
#### Step1: 
Install the `Remote - SSH` extension in vscode. You can find it by searching `Remote - SSH` in the extension marketplace.

#### Step2:
Open command palette (using `F1`) and type `Remote-SSH: Connect to Host...`. You will see a list of hosts that you have connected to before. Click on `Add New SSH Host...`, then type in
```
<netid>@greene.hpc.nyu.edu
```
Replace <netid> with your own. You will be prompted to enter your password, which is the same as your nyu account.

## HPC File System
### Overview of the four folders that you have access to
```
/home/$USER
/scratch/$USER
/archive/$USER
/vast/$USER
```
### Home [space50GB/files30K]
This is where you will land when you log in. The quota is really small so you should not store your data here.

### Scratch [space5TB/files1M]
This is where you should store your data. You have a lot of space here, but be aware that the data will be deleted after 60 days if not used. Conda environment for python should be installed in singularity overlays, which is stored in scratch. You will know what it means later.

### Archive [space2.0TB/files20K]
This is where you can archive your large data. It's not often used.

### Vast [space2TB/files5M]
Another place to store your data, ideal for high I/O data that may bottleneck on the scratch file system. I don't use it personally.


## Quick Start for Conda Environment
If you are not interested in how HPC operates, and just want to set up a python environment to run your code, then use the following steps to get started.
### Interactive Sessions
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



## Table of Contents
* [Manual Setup](MaunalSetup.md)
* [Trouble Shooting](TroubleShooting.md)
* [Advanced Tricks](AdvancedTricks.md)

## Acknowledgement
* [HPC Home](https://sites.google.com/nyu.edu/nyu-hpc/home?authuser=0)
* I started my journey with HPC by following [HPC Notes by Hammond Liu](https://abstracted-crime-34a.notion.site/63aae4cc39904d11a5c744f480a42017?v=261a410e1fe24d0294ed744c21a41015&p=7ed5e95ce1dc400898f6462f6de47d2c&pm=s)