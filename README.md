# NYU-Greene-HPC-Cheatsheet
A beginner note for getting started with nyu greene hpc

## NYU HPC Websites
* [Home](https://sites.google.com/nyu.edu/nyu-hpc/home?authuser=0)
* [Set up conda environment with python](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda)
* [Open On Demand for running jupyter notebook](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/open-ondemand-ood-with-condasingularity)

## Useful Liunx Commands
### Quota Storage
* Check disk storage
If you encounter the problem of "Disk quota exceeded", don't panic, you can check your disk storage by:

```
myquota
```
* Check the size of each folder
```
du -h --max-depth 1
```
* Check file numbers in each folder
```
for d in $(find $(pwd) -maxdepth 1 -mindepth 1 -type d | sort -u); do n_files=$(find $d | wc -l); echo $d $n_files; done
```

Delete files in `$Home` (most probably python packages), then you will be fine

### File Management
* delete files by file name recursively
```
rm -rf `find . -type $filetype -name $filename`
```

## CPU&GPU Runtime
* Check CPU
```
ssh <node-name>
top -u $USER
```
* Check GPU
```
ssh <node-name>
nvidia-smi
```