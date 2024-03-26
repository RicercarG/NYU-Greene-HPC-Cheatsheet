#Trouble Shooting

## How Can I quit?
* `Ctrl + C` for killing a running python program (or other running programs) in terminal (not sure for windows, but it works for mac and linux)
* `Ctrl + D` or type `exit` for exitting the singularity container
* Type `exit` for exitting a CPU/GPU node that you are in 
* To kill a running job, type `scancel <jobid>`. You can see all your job ids using `squeue -u <netid>` (replace <netid> with your own)


## How Can I jump back when kicked off by accident?
Sometimes you might be kicked off from hpc by accident, and lost everything when you login back. In most cases, your interactive CPU/GPU jobs will be killed, and you have to start everything again. However, you can try your luck to jump back to your cpu/gpu node by:
* See the running job using `squeue -u <netid>` (replace <netid> with your own). Find the <node-name> you want under `NODELIST`
* Log back in using `ssh <node-name>`. 


## Disk Quota Exceeded 
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

## Could not login server through vscode
If you successfully logged in HPC through vscode before, but now you cannot it is most probably because of "Disk quota exceeded". You can login with terminal and check disk quota using `myquota`. 
If use find `.vscode-server` contains a lot of files, then delete them and you will be fine:
```
rm -rf .vscode-server
```

The reason is mainly because you installed too many extensions in vscode. After delecting `.vscode-server`, all extensions on HPC vscode will be removed (it won't affect vscode on your local machine).


## Out of Memory Error
### Check GPU Runtime
When encounting error of "CUDA out of memory", you might want to monitor the GPU memory usage. You can check the GPU memory usage by:
```
nvidia-smi
```
or watch in realtime using
```
watch -n 1 nvidia-smi
```
I personally recommend logging in the same GPU node using two terminals, one for running your code, the other for monitoring the GPU memory usage. It's easy to do in both terminal and vscode integrated terminal. <br>
Check [this](#how-can-i-jump-back-when-kicked-off-by-accident) for how to jump to the desired node.



### Check CPU Runtime
```
ssh <node-name>
top -u $USER
```


