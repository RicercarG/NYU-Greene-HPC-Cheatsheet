#Trouble Shooting
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
If you successfully logged in HPC through vscode before, but now you cannot it is most probably because of "Disk quota exceeded". You can login with terminal and check disk quota. 
If use find `.vscode-server` contains a lot of files, then delete them and you will be fine:
```
rm -rf .vscode-server
```

The reason is mainly because you installed too many extensions in vscode. After delecting `.vscode-server`, all extensions on HPC vscode will be removed (it won't affect vscode on your local machine).


## Out of Memory Error
* Check CPU Runtime
```
ssh <node-name>
top -u $USER
```
* Check GPU Runtime
If you meet error of "CUDA out of memory", and you want to see 
```
ssh <node-name>
nvidia-smi
```

