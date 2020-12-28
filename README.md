# Remote Directory Synchronizer

Tool to synchronize two directory from different host automatically with ssh.

## How to use

First, you must install the inotify-tools package.

```bash
sudo dnf install inotify-tools # Fedora
sudo apt install inotify-tools # Ubuntu
```

You can now install the tool in a specific directory.

``` bash
./install.sh <path/to/your/directory>
```

Then, edit the .sync.env and .syncignore files in the directory.

The .sync.env file contain environment variable useful for the script. You must specify three different variables :
- HOST
- USERNAME
- REMOTE_DIRECTORY

The .syncignore contains all the files the script will skip.

Finally, after you have editing the two files, you can launch the script !

``` bash
./synchronizer.sh
```
