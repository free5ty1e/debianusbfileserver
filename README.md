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

See the example `reference/rc.local` file to see what this might look like.


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

### SyncThing and Managing Your Own Local Google Photos-esque Sync Service
The point of this service is to completely replace Google Photos functionality with something I am in complete control over.
The main features I want to keep from GPhotos are:

1. Can sync videos and images from my Android phone whenever I'm on my WiFi / same network as my SyncThing fileserver (automatic? perhaps. I'll be happy with manual - so that I know when I can "clear" my photos to make space on the phone and not worry about having to indicate in the photo list somehow)
2. Once photos have been sync'd to the fileserver and are on a hard drive, a periodic cron job will go through the sync folder and perform the following tasks:
3. Recompress / optimize and shrink (in the best order to achieve optimum results) each image file for archival (scan will recognize already processed photos and skip them so processed files can stay in place - probably by dimensions and / or file size)
4. Transcode (and shrink if above a threshold) each video file aggressively with H.265 and 2-pass to really shrink video files (scan will recognize videos already encoded with H.265 and skip them so processed files can stay in place)
  
Links:
1. https://syncthing.net/ 
2. https://linuxconfig.org/batch-image-resize-using-linux-command-line
3. https://guides.wp-bullet.com/batch-resize-images-using-linux-command-line-and-imagemagick/
4. https://guides.wp-bullet.com/batch-compress-jpeg-images-lossless-linux-command-line/
5. https://guides.wp-bullet.com/batch-optimize-jpg-lossy-linux-command-line-with-jpeg-recompress/
6. https://geoffruddock.com/bulk-compress-videos-x265-with-ffmpeg/

