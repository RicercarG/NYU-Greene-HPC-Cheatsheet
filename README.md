# NYU-Greene-HPC-Cheatsheet
A beginner guide for getting started with nyu greene hpc

## Quick Start
If you are not interested in how HPC works, and just want to set up a python environment and run your code, you can use the following steps to get started.
* Step1: Log in to greene
```
ssh <netid>@greene.hpc.nyu.edu
```
* Step2: change to your scratch directory (always remember to save everything in your scratch directory)
```
cd /scratch/<netid>
```
* Step3: setup the singularity environment with conda
download the shell script I wrote for setting up the environment
```
wget https://raw.githubusercontent.com/RicercarG/NYU-Greene-HPC-Cheatsheet/main/launcher.sh
chmod +rx launcher.sh
./launcher.sh
```

## Table of Contents
* [Manual Setup](MaunalSetup.md)
* [Trouble Shooting](TroubleShooting.md)
* [Useful Tricks](UsefulTricks.md)

## Acknowledgement
* [HPC Home](https://sites.google.com/nyu.edu/nyu-hpc/home?authuser=0)
* I started my journey with HPC by following [HPC Notes by Hammond Liu](https://abstracted-crime-34a.notion.site/63aae4cc39904d11a5c744f480a42017?v=261a410e1fe24d0294ed744c21a41015&p=7ed5e95ce1dc400898f6462f6de47d2c&pm=s)