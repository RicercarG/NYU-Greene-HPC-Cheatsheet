# NYU-Greene-HPC-Cheatsheet
A beginner guide for getting started with running python on nyu greene hpc. 

## Table of Contents
* Basic Information Inside README
	* [Prerequisits](#prerequisits)
	* [Access HPC](#access-hpc)
	* [HPC File System](#hpc-file-system)
* [Quick Start for Conda Environment](QuickStart.md) <- Check this if you are lazy and just want to get your python code running
* [Manual Setup](MaunalSetup.md)
* [Trouble Shooting](TroubleShooting.md)
	* [How can I quit python/singualrity/runtime?](TroubleShooting.md#how-can-i-quit)
	* [How can I jump back when kicked off by accident?](TroubleShooting.md#how-can-i-jump-back-when-kicked-off-by-accident)
	* [Disk quota exceeded](TroubleShooting.md#disk-quota-exceeded)
	* [Could not login server through vscode](TroubleShooting.md#could-not-login-server-through-vscode)
	* [Out of Memory Error](TroubleShooting.md#out-of-memory-error)
		* [Check GPU Status](TroubleShooting.md#check-gpu-status)
		* [Check CPU Status](TroubleShooting.md#check-cpu-status)
	* [Could not open singularity environment](TroubleShooting.md#could-not-open-singularity-environment)
	* [Some linux commands could not be executed](TroubleShooting.md#some-linux-commands-could-not-be-executed)
* [Advanced Tricks](AdvancedTricks.md)

## Prerequisits
### Apply for NYU Greene HPC access
Just follow the [official guide](https://www.nyu.edu/life/information-technology/research-computing-services/high-performance-computing/high-performance-computing-nyu-it/hpc-accounts-and-eligibility.html#eligibility). If you are an NYU student, you do need a faculty sponsor to apply for an account.

### Basic Linux commands
There are lots of linux beginner guide online. Pick anyone you like, for example the cheat sheet from [GeeksforGeeks](https://www.geeksforgeeks.org/linux-commands-cheat-sheet/). Or just ask chatGPT, it knows everything.

### Vim
Vim is the default text editor in HPC. It's not mendatory, but learning vim will make life much easier. I personally recommend this [guide](https://github.com/iggredible/Learn-Vim?tab=readme-ov-file). You can also learn vim through playing a [video game](https://vim-adventures.com/)

### VS Code
One of the killer features in vscode is being able to connect to a remote server easily. Even though I'm a fan of sublime and zed, I turn to vscode when using HPC.


## Access HPC
### Option1: Connect through terminal
Open terminal app on your mac/windows/linux, and type
```
ssh <netid>@greene.hpc.nyu.edu
```
Replace `<netid>` with your own. You will be prompted to enter your password, which is the same as your nyu account. (Your password won't be shown on the screen, but it's still being typed in.) <br>
If you see your terminal prompt changes to `netid@log-n:~$`, then you are successfully logged in.


### Option2: Connect through vscode
#### Step1: 
Install the `Remote - SSH` extension in vscode. You can find it by searching `Remote - SSH` in the extension marketplace.

#### Step2:
Open command palette (using `F1`) and type `Remote-SSH: Connect to Host...`. You will see a list of hosts that you have connected to before. Click on `Add New SSH Host...`, then type in
```
<netid>@greene.hpc.nyu.edu
```
Replace `<netid>` with your own. You will be prompted to enter your password, which is the same as your nyu account.

## HPC File System
There are four main directories in HPC:
```
/home/$USER
/scratch/$USER
/archive/$USER
/vast/$USER
```
You can always check your quota usage by typing `myquota`.
### Home [space50GB/files30K]
This is where you will land when you log in. The quota is really small so you should not store your data here.

### Scratch [space5TB/files1M]
This is where you should store your data. You have a lot of space here, but be aware that the data will be deleted after 60 days if not used. Conda environment for python should be installed in singularity overlays, which is stored in scratch. You will know what it means later.

### Archive [space2.0TB/files20K]
This is where you can archive your large data. It's not often used.

### Vast [space2TB/files5M]
Another place to store your data, ideal for high I/O data that may bottleneck on the scratch file system. I don't use it personally.



## Acknowledgement
* The official documentation: [HPC Home](https://sites.google.com/nyu.edu/nyu-hpc/home?authuser=0)
* I started my journey with HPC by following [HPC Notes by Hammond Liu](https://abstracted-crime-34a.notion.site/63aae4cc39904d11a5c744f480a42017?v=261a410e1fe24d0294ed744c21a41015&p=7ed5e95ce1dc400898f6462f6de47d2c&pm=s)

## This repo is still under construction
Update: The most essential parts have been finished. Here is the to-do list:
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
	- [x] Could not open singularity environment
	- [x] Some linux commands could not be executed
* Advanced Tricks
	- [ ] Setup bashrc
	- [ ] Setup ssh key pairs
	- [x] File management commands
	- [x] Access through iPad