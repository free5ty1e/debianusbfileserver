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

Once the system (Raspbian Buster, when this was written 2020.11.25) has launched the `/etc/rc.local` service, all of the drives should be available under `/dev/sd?` (type `ls /dev/sd?` to see them).  So at this point, we want to clear out the symlinks in `/media/` and then launch the `sequentialUsbDriveStartup.sh` script.  

If you (like me!) are also using this USB fileserver as a Plex media server, and one of the USB drives contains your `plexdata` library, then you will want to also `sudo systemctl disable plexmediaserver.service` to disable the Plex server autostart and also add the following to the `rc.local`:  `service plexmediaserver start`

See the example `reference/rc.local` file to see what this might look like.

### Preparing USB Drive
For a fresh drive, I like to go through the following steps to set up for usage on my USB fileserver.
NOTE: When I type `/dev/sda` this might be `sdb` or `sdc` or `sdd` etc depending on which USB drive you want to manipulate.  Please be sure to identify and work with the correct drive!
1) Run a `sudo drivesmartstats.sh /dev/sda` and ensure the drive isn't obviously failing
1a) Optional: Run a `sudo drivetestbadblocksrwdestructive.sh /dev/sda` and allow at least one full cycle to pass completely before using the drive (if this fails, return the drive!!)
2) Run `sudo fdisk /dev/sda` - `m` for help.  
2a) Create new GPT partition table (`g`)
2b) Create new full-size partition (`n` then enter for all defaults)
2c) Review new partition changes (`p` then `v`)
2d) Save changes and quit (`w`)
3) Run `sudo mkfs.ext4 -L YourDriveLabelHere /dev/sda1` to create the EXT4 filesystem
4) I usually reboot the system at this point with Automount enabled and then I can see the drive mounted in `/media/YourDriveLabelHere`
5) Now to make it writeable by the guests on your simple SMB share: run `pushd /media/YourDriveLabelHere && sudo chown pi:pi . && popd`
6) Confirm you can write to the new drive as the Pi user: run `pushd /media/YourDriveLabelHere && touch hello && ls && rm hello && popd`
7) Enjoy!

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

If you would like to see what this might look like on a combined RetroPie / USB fileserver where all shares are accessible via guest login, see the `reference/smb.conf`


### Forcing `usb-storage` instead of buggy `UAS` (USB As SCSI) driver
You may not need this, I operated without even knowing about this blissfully for months with no issues... but here are some reference links for what I am about to summarize and offer a solution for:
https://www.raspberrypi.org/forums/viewtopic.php?t=237829
https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=245931
https://www.raspberrypi.org/forums/viewtopic.php?t=246128

One day, I needed a 5GB `ISO` file from my fileserver, so I connected to the Samba share from my laptop and started copying it over for local operations.  It was copying over at decent speeds indicitave of a USB3 connection, all was well.  ... until a couple minutes in, when the copy failed with an `I/O Error` mentioned.  I attempted to start the copy once more and noticed that the share was empty.  As a matter of fact, ALL my drives linked in the share were empty now.  

I remote in via SSH to take a closer look; the `/dev/sd?` entries are all gone.  The entire set of USB devices usually found on `lsusb` were gone, except for the internal Root USB 2.0 and 3.0 hubs.  

Rebooting the system, all the drives come back up normally and I can start the copy again.  This time, it fails at a different point.  It wasn't a specific spot of data corruption.  I tried copying the file from its mirror drive; same result, different spot in the copy.  I tried all sorts of other tests to further isolate (I suspected Samba, I suspected two simultaneously failing drives, I suspected a failing USB3 hub, I copied files from other USB drives just fine locally on the Pi and via Samba)

It was just 2 of my 6 drives; I could reproduce the failure by copying large files from one of these two drives to the other or vice versa.  Locally or over Samba.  They just happened to be the same make and model drive that I have as a set of data and its mirror.  For some reason, these two drives were acting as if they were failing both at once!

Then, I noticed something when I tried looking at both the `lsusb` command *and* the `lsusb --tree` command.  Whoa, why are two of my drives using a different driver than the others?  (I *STILL* have not answered this question, by the way - because they didn't always act like this....)
![](reference/pi4usb3fileserver2drivesUsingBuggyUasDriver.png?raw=true)

After reading the links above, I tried modifying my `/boot/cmdline.txt` by adding the following parameter to it (using IDs from my `lsusb` command as I matched them up to all my USB3 drives)
`usb-storage.quirks=0bc2:3322:u,1058:25fb:u,0bc2:a0a1:u,0bc2:50a2:u`

This activates the system's USB Storage "quirks", which apparently disables the buggy `UAS` driver and forces all the indicated USB drives to utilize the far more stable `usb-storage` driver instead.  Behold the results, all 6 of my drives forced into using the stable driver:
![](reference/pi4usb3fileserverAllDrivesUsingQuirksToForceUsbStorageDriver.png?raw=true)

You can see the included https://github.com/free5ty1e/debianusbfileserver/blob/master/reference/cmdline.txt for reference if needed.  (located at `reference/cmdline.txt`)


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


### Managing a CyberPower UPS 

For Raspberry Pi, you can use apcupsd. The needed configuration for my device in /etc/apcupsd/apcupsd.conf for my CyberPower UPSses (625VA) are:

```
#UPSCABLE smart
UPSCABLE usb

#UPSTYPE apcsmart
UPSTYPE usb

#DEVICE /dev/ttyS0
DEVICE
```

Then, to have this service trigger send an email when the power goes out / comes back on: 
`msmtp` https://www.raspberrypi.org/forums/viewtopic.php?t=244147#p1496767
```
sudo apt-get install msmtp msmtp-mta

sudo nano /etc/msmtprc
```

/etc/msmtprc should contain the following:
```
# Generics
defaults
auth           on
tls            on
# following is different from ssmtp:
tls_trust_file /etc/ssl/certs/ca-certificates.crt
# user specific log location, otherwise use /var/log/msmtp.log, however, 
# this will create an access violation if you are user pi, and have not changes the access rights
logfile        ~/.msmtp.log

# Gmail specifics
account        gmail
host           smtp.gmail.com
port           587

from          root@raspi-buster
user           your-gmail-accountname@gmail.com
password       your-gmail-account-password

# Default
account default : gmail
```

Test send email: 
```
echo 'your message' | msmtp destination-email-address@gmail.com
```

To also get a subject line and more control over emails, we need `mailutils`:

```
sudo apt-get install mailutils
```

Then the following works again:
```
echo 'message' | mail -s "raspi-buster" destination-email-address@gmail.com
echo 'message' | sendmail destination-email-address@gmail.com
```

I'd also like to be able to push a quick special notification to my de-googled / microG Android phone, which IFTTT can be used for as shown here https://betterprogramming.pub/how-to-send-push-notifications-to-your-phone-from-any-script-6b70e34748f6
(create If Webhook Then Notification, then go here https://ifttt.com/maker_webhooks and click "Documentation" to see your API key and to construct your `curl` command)


To automatically run these commands upon a UPS event https://tjth.co/apcupsd-to-send-email-on-power-failure/
```
nano /etc/apcupsd/apccontrol
```

Page down until you see this section:
```
#
# powerout, onbattery, offbattery, mainsback events occur
# in that order.
#
 powerout)
 ;;
```

And simply insert your commands between the delimiters for the event you'd like to hook into, such as:

```
onbattery)
 echo "Power failure on UPS ${2}. Running on batteries." | ${WALL}
 apcaccess | mail -s "WARNING - UPS running on batteries" youremail@yourdomain.me.uk
 ;;
```

An example `apccontrol` file as I use it (with an external centralized script containing all my keys and emails and phone numbers that get notified) is included in the `reference` folder.  If you choose to simply copy this file over and modify it, please be sure to 
```
sudo chmod +x /etc/apcupsd/apccontrol
sudo chown root:root /etc/apcupsd/apccontrol
```

### SyncThing and Managing Your Own Local Google Photos-esque Sync Service (CPhotos)
##### CPhotos has been extracted to its own repository here:
https://github.com/free5ty1e/cphotos


### Using the `screen` utility to kick off and come back to long-running jobs over SSH
Screen will ensure the batch command keeps on running even if your SSH session is terminated.

```
sudo apt-get install screen
```

Create a new screen session

```
screen
```

Perform your long-running command (for example, kick off processing of a large folder of media files as below)

```
processmediafolderforarchive.sh sourceFolder targetFolder
```

Detach the screen with `Ctrl+A` and pressing `D` (detach).

You can use the `top` command and look for active processes once in a while.

Reattach the screen in a later SSH session like so:

```
screen -r
```

#### Using Jellyfin for H.265 hardware decoding support on Raspberry Pi 4 (instead of Plex, which does not support this yet) :
https://jellyfin.org/
https://jellyfin.org/docs/general/administration/hardware-acceleration.html

Add the Jellyfin service user to the video group to allow Jellyfin's FFMpeg process access to the encoder, and restart Jellyfin.

```
sudo usermod -aG video jellyfin
sudo systemctl restart jellyfin
```

NOTE:
If you are using a Raspberry Pi 4, you might need to run `sudo rpi-update` for kernel and firmware updates.

Choose `OpenMAX OMX` as the Hardware acceleration on the Transcoding tab of the Server Dashboard.

The following checkbox states should be applied for the hardware acceleration options:
Enable hardware decoding for:

```
[ ] H264

[ ] MPEG2

[x] MPEG4

[x] VC1

[x] Enable 10-Bit hardware decoding for HEVC

[x] Enable 10-Bit hardware decoding for VP9

[x] Enable hardware encoding

[ ] Allow encoding in HEVC format
```

Change the amount of memory allocated to the GPU. The GPU can't handle accelerated decoding and encoding simultaneously.

```
sudo nano /boot/config.txt
```

For RPi4, add the line `gpu_mem=320` 

For RPi3, add the line `gpu_mem=256`

You can set any value, but `320` is recommended amount for 4K HEVC. (I still never got hevc decode to work)

Verify the split between CPU and GPU memory:

```
vcgencmd get_mem arm && vcgencmd get_mem gpu
```

Monitor the temperature and clock speed of the CPU:

```
vcgencmd measure_temp && vcgencmd measure_clock arm
```

More discussion around RPi 4b + Jellyfin / ffmpeg using h.265 hardware decoder is here https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=283301&start=50#p1789041
HEVC HWA Pi4 decoding guide here on Reddit: https://www.reddit.com/r/jellyfin/comments/ei6ew6/rpi4_hardware_acceleration_guide/


#### Mount remote Samba share on this system:
https://tecadmin.net/mounting-samba-share-on-ubuntu/
For the purposes of this example, I will be mounting a remote samba share named `smb://192.168.100.104/sharedusb` to local folder `/media/sharedusb`.

```
sudo apt -y install cifs-utils
sudo mkdir /media/sharedusb
```

If you don't need credentials, the next step is simple:
```
sudo mount -t cifs -o rw,vers=3.0,username=guest,password="" //192.168.100.104/sharedusb /media/sharedusb
```

If you need credentials, the next step is a bit more involved:
```
pushd ~
nano .smbcredentials

#.smbcredentials: 
username=smb_username
password=smb_password

popd 


sudo mount -t cifs -o rw,vers=3.0,credentials=~/.smbcredentials //192.168.100.104/sharedusb /media/sharedusb 
```


#### Other useful tricks / links:

Log2RAM (instead of SD) - and it's an APT package for ease:
https://github.com/azlux/log2ram

Uninstalled / disabled the swap file:
```
sudo dphys-swapfile swapoff && sudo dphys-swapfile uninstall && sudo update-rc.d dphys-swapfile remove && sudo systemctl disable dphys-swapfile
```


