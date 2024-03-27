# Trouble Shooting

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


## "Man-In-The-Middle" Warning
If you see warning like 
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
```
when trying to login HPC, don't be alarmed. That's an issue caused by HPC having multiple login nodes.


To avoid this, simply open ssh config file at `~/.ssh/config` with your favorite text editor, and add the following lines:
```
Host *.hpc.nyu.edu
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel ERROR
```
Now you can login HPC without seeing the warning.


## Could not login server through vscode
If you successfully logged in HPC through vscode before, but now you cannot it is most probably because of "Disk quota exceeded". You can login with terminal and check disk quota using `myquota`. 
If use find `.vscode-server` contains a lot of files, then delete them and you will be fine:
```
rm -rf .vscode-server
```

The reason is mainly because you installed too many extensions in vscode. After delecting `.vscode-server`, all extensions on HPC vscode will be removed (it won't affect vscode on your local machine).



## Out of Memory Error
### Check GPU Status
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

### Check CPU Status
```
ssh <node-name>
top -u $USER
```


## Could not open singularity environment
If you encounter the following error
```
FATAL:   while loading overlay images: failed to open overlay image ...
```
It's most probably because you are trying to open the singularity environment while another process is writing the overlay. <br>

The command for opening the singularity environment is: `singularity exec --nv --bind $data_dir --overlay $overlay:rw $singularity_file /bin/bash`, here `:rw` stands for `Read and Write` mode, and you can change it to `:ro` for `Read only` mode. <br>

An singularity overlay could only be opened in multiple processes using `Read Only` mode. <br>

If you open the overlay in `Read and Write` mode in a CPU/GPU node, <span style="color:orange"> then go to that node and exit the overlay, or kill that node </span>. Go back and check [How Can I Quit](#how-can-i-quit) for instructions.<br>

If you open the overlay in `Read and Write` mode in login node, and you are kicked off from HPC by accident, <span style="color:orange"> then unfortunately you have to delete the overlay and start again. </span> <br>

The recommended way is to open the overlay in `Read and Write` mode in CPU/GPU node only when you want to install python packages, and open in `Read only` mode in all other cases. 

## Some linux commands could not be executed
If commands like `myquota`, `squeue`, `scancel` could not be executed, then probably you are inside the singularity environment. You can only use these commands outside the singularity environment. <br>
