# debianusbfileserver
Debian scripts to support an rsync'd &amp;&amp; redundant USB file server (mine, but it might help you too) ¯\_(ツ)_/¯

To install: Make sure you are connected to the Internet, and copy / paste the following command into your terminal via a nice handy SSH session (or type it, whatever):
```
sudo apt-get -y install git && pushd ~ && rm -rf debianusbfileserver && git clone https://github.com/free5ty1e/debianusbfileserver.git && debianusbfileserver/scripts/installfiles.sh && popd && finishinstall.sh
```

## Options


### Automount USB Drives By Volume Name At Startup
The installer will add auto symlinks by volume name in `/media/$VOLUME_NAME` when USB drives are connected, and the symlinks will be cleared upon disconnection.
This is handled by the `/etc/usbmount/mount.d/02_create_label_symlink` and `/etc/usbmount/umount.d/01_remove_label_symlink` scripts.

Some of you (like me!) may find that `usbmount` fails to reliably handle multiple simultaneous USB drive connections, such as when connecting a USB hub with external drives already attached to it; only the first 3 or maybe 4 drives mount properly and the rest fail to obtain a mount lock (failing with such errors as `cannot acquire lock /var/run/usbmount/.mount.lock`).

After much experimentation, failure, and frustration, I have devised a reliable way to start up such a USB fileserver with many USB drives attached during startup.  The solution is to disable the `usbmount` feature (via `/etc/usbmount/usbmount.conf`'s `ENABLED=0` flag) normally, and at the appropriate time during the startup procedure we need to sequence initialization of each drive and then wait a couple seconds before initializing the next drive.  

Once the system (Raspbian Buster, when this was written 2020.11.25) has launched the `/etc/rc.local` service, all of the drives should be available under `/dev/sd?` (type `ls /dev/sd?` to see them).  So at this point, we want to launch the `sequentialUsbDriveStartup.sh` script.  

If you (like me!) are also using this USB fileserver as a Plex media server, and one of the USB drives contains your `plexdata` library, then you will want to also `sudo systemctl disable plexmediaserver.service` to disable the Plex server autostart and also add the following to the `rc.local`:  `service plexmediaserver start`

See the example `rc.local` file to see what this might look like.


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
   dfree command = /usr/local/bin/dfree
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

...where `dfree` is a simple script (example at `bin/dfree`, install with the following commands)
```
sudo cp -vf debianusbfileserver/bin/dfree /usr/local/bin/
sudo chown root:root /usr/local/bin/dfree
sudo chmod 777 /usr/local/bin/dfree
sudo service smbd restart
```

...If you'd like to create this `dfree` script manually:
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
sudo chown root:root /usr/local/bin/dfree
sudo chmod 777 /usr/local/bin/dfree
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


### Adding an anonymous FTP server to access a USB share
Copy over the example config and then edit it to your liking (mainly the `anon_root` location)
```
sudo apt-get -y install vsftpd
sudo cp -fv reference/vsftpd.conf /etc/
sudo nano /etc/vsftpd.conf
```
