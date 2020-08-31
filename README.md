# debianusbfileserver
Debian scripts to support an rsync'd &amp;&amp; redundant USB file server (mine, but it might help you too) ¯\_(ツ)_/¯

To install: Make sure you are connected to the Internet, and copy / paste the following command into your terminal via a nice handy SSH session (or type it, whatever):
```
sudo apt-get -y install git && pushd ~ && rm -rf debianusbfileserver && git clone https://github.com/free5ty1e/debianusbfileserver.git && debianusbfileserver/scripts/installfiles.sh && popd && finishinstall.sh
```

## Options


### Automount USB Drives By Volume Name At Startup
If you'd like to have any USB drives automounted by volume name (only for drives that happen to be connected during startup), copy the `rc.local` file over to `/etc/rc.local` with the following command in your user folder:
```
sudo cp debianusbfileserver/rc.local /etc/ && sudo chmod +x /etc/rc.local
```

### Passwordless SSH Logins
If you haven't already generated your SSH key, do it with the `ssh-keygen` command with all defaults.
Then, the following sequence of commands from a terminal on the you want to set up passwordless SSH from (assuming your username is also `chris`) : 
```
scp ~/.ssh/id_rsa.pub chris@primeplexlenovo:/home/chris/
ssh chris@primeplexlenovo
mkdir ~/.ssh ; cat ~/id_rsa.pub >>~/.ssh/authorized_keys && chmod 700 ~/.ssh/authorized_keys && rm id_rsa.pub && exit
```

### Samba file sharing of all USB drives
First edit the samba configuration file: 
```
sudo nano /etc/samba/smb.conf
```

Then add the following share definition to share all USB drives:
```
[sharedusb]
   comment = Mounted USB Drives
   read only = no
   path = /media 
   guest ok = no
   dfree command = /home/pi/dfree
```

Save changes (`CTRL-X`).

Then add your user to the Samba user list and set your password: 
```
sudo smbpasswd -a chris
```

If you'd like your free space to be reported correctly over Samba for each drive instead of the root filesystem, also add the following to the `[sharedusb]` section of the `smb.conf` file: (reference https://superuser.com/a/1467387/415715 and https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html )
```
[sharedusb]
   dfree command = /usr/local/bin/dfree
```

...where `dfree` is a simple script, for example created with 
```
sudo nano /usr/local/bin/dfree
```
... containing: (the commented out 2nd line is the command that *should* work but if you are sharing a folder containing other USB drives then it will always still check the `sharedusb` folder for free space, which is the root filesystem, so we have to fake it instead with `echo` - in this case, we are just always reporting 128GB free, which should be plenty)
```
#!/bin/sh
#/bin/df $1 | /bin/tail -1 | /bin/awk '{print $(NF-4),$(NF-2)}'
echo "128000000000 128000000000"
```
... and then
```
sudo chown root:root /home/pi/dfree
sudo chmod 777 /home/pi/dfree
```

Then restart the Samba service:  
```
sudo service smbd restart
```


### Mounting an FTP folder 
As gone over here https://linuxconfig.org/mount-remote-ftp-directory-host-locally-into-linux-filesystem 

One-time mount (this would, for example, mount an FTP folder in the above Samba share as another drive)
```
sudo mkdir -pv /media/Incoming
curlftpfs -o allow_other USER:PASSWORD@192.168.100.1 /media/Incoming/
```

(you will first have to `sudo nano /etc/fuse.conf`, uncomment the `user_allow_other` line and save the file - or use another editor of your choice, ya elitists, I don't care)

To automount each boot, just add the following to your `/etc/rc.local` file before the `exit 0`:
```
sudo nano /etc/rc.local
```

```
#Mount FTP share(s)
mkdir -vp /media/Incoming
chown chris:chris /media/Incoming
curlftpfs -o allow_other USERNAME:PASSWORD@192.168.100.1 /media/Incoming/
```

## Notes:
(Note: If you are like me and starting with such a barebones Debian load that `sudo` isn't even installed, the following command sequence might be of interest to you -- and me, since *my* username is `chris` too!)
```
su -
apt-get install sudo
usermod -aG sudo chris
exit
```
(Then relaunch the terminal or relaunch the SSH session to continue)


### Handy link to Plex Media Server installation commands for Debian
https://support.plex.tv/articles/235974187-enable-repository-updating-for-supported-linux-server-distributions/
(see handy script `installPlexMediaServer.sh` that attempts to automate this)

#### Additional handy link for those running on a Pi SD card
https://forums.plex.tv/t/moving-pms-library/197342

