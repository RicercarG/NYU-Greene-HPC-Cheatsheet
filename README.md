# NYU-Greene-HPC-Cheatsheet
Written by [Yuanhe Guo](https://ricercarg.github.io) (yg2709@nyu.edu)

A beginner guide for getting started with running python on nyu greene hpc.

Each time I want to setup a new environment on NYU Greene HPC, I have to go through the official documentation and search for the commands I need. Meanwhile, there exist quite a few common issues whose solutions are not covered by the offical documentation. So I decided to write a cheatsheet for myself and others who may need it. 

I wrote some complex commands into bash scripts, so that getting python run flawlessly on NYU Greene HPC is as simple as ordering a burger in a fast food restaurant.

**Check the [wiki page](https://github.com/RicercarG/NYU-Greene-HPC-Cheatsheet/wiki) to get started.**

## Acknowledgement
* The official documentation: [HPC Home](https://sites.google.com/nyu.edu/nyu-hpc/home?authuser=0)
* I started my journey with HPC by following [HPC Notes by Hammond Liu](https://abstracted-crime-34a.notion.site/63aae4cc39904d11a5c744f480a42017?v=261a410e1fe24d0294ed744c21a41015&p=7ed5e95ce1dc400898f6462f6de47d2c&pm=s)

## Important updates (planning to move this section to Releases)
- [2025.8.1] Added custom CUDA version support. Singularity will be built from scratch from Docker Hub. Note that this singularity has no cuDNN so you will need to install cuDNN yourself. The easiest way is to go to [Nvidia cuDNN Archive](https://developer.nvidia.com/rdp/cudnn-archive), download the version you want, scp to greene and install it.  

- [2025.5.29] A [y]/n option is added when the user is prompted to create a new environment. A new folder will only be created if the user enters "y" or "yes". This is to prevent creating unnecessary folders when the user made a typo when activating existing environment.

- [2024.6.13] The file structure has undergone a significant change. Now you can clone the entire repo. **If you have used this cheatsheet before, please first remove `chsdevice.sh` and `chslauncher.sh` on your hpc. Then follow the updated wiki instruction to setup your environment.** New features are as following:
	- The new file structure is more organized and easier to maintain.
	- A new run_setup.sh script is added to help you setup `~/.bashrc` file automatically.
	- Added options for H100 GPU and cuda 12.1

- [2024.4.7] Bug fix for handling conda installation failure in Lazy Launcher. Check [[ this part of troubleshooting|Trouble Shooting#conda-environment-installation-failed ]] for detail.

## Topics covered in this cheatsheet
Please feel free to open an issue if you have any questions or suggestions.
* Prereq
	- [x] Apply for NYU Greene HPC access
	- [x] Basic Linux commands
	- [x] Vim
	- [x] Vscode
* Quick Starting Pack
	- [x] Connect to HPC
	- [x] Request CPU/GPU Sessions
	- [x] Interactive sessions for conda
	- [x] Jupyter Notebook
	- [x] Batch jobs
* Manual Setup
	- [x] Offical guide Index
* Trouble Shooting
	- [x] How can I quit python/singualrity/runtime?
	- [x] How can I jump back when kicked off by accident?
	- [x] Disk quota exceeded
	- [x] Could not login server through vscode
	- [x] Out of Memory Error
	- [x] Could not open singularity environment
	- [x] Some linux commands could not be executed
* Advanced Topics (Useful Tricks)
	- [x] Setup bashrc
	- [x] Setup ssh key pairs
    - [ ] Collection of useful linux commands
    - [x] Sharing files with Other HPC Users
    - [x] Sending files to/from HPC
    - [ ] SSH Tunneling on GPU Nodes
    - [x] AWS S3 Connection
    - [x] Access through iPad
