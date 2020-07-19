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
sudo cp debianusbfileserver/rc.local /etc/
```

### Passwordless SSH Logins
If you haven't already generated your SSH key, do it with the `ssh-keygen` command with all defaults.
Then, the following sequence of commands from a terminal on the you want to set up passwordless SSH from (assuming your username is also `chris`) : 
```
scp ~/.ssh/id_rsa.pub chris@primeplexlenovo:/home/chris/
mkdir ~/.ssh
cat ~/id_rsa.pub >>~/.ssh/authorized_keys
chmod 700 ~/.ssh/authorized_keys
rm id_rsa.pub
exit
```

### Samba file sharing of all USB drives
First edit the samba configuration file:
`sudo nano /etc/samba/smb.conf`

Then add the following share definition to share all USB drives:
```
[sharedusb]
   comment = Mounted USB Drives
   read only = no
   path = /media 
   guest ok = no
```

Save changes (`CTRL-X`).

Then add your user to the Samba user list and set your password:
`smbpasswd -a chris`


## Notes:
(Note: If you are like me and starting with such a barebones Debian load that `sudo` isn't even installed, the following command sequence might be of interest to you -- and me, since *my* username is `chris` too!)
```
su -
apt-get install sudo
usermod -aG sudo chris
exit
```
(Then relaunch the terminal or relaunch the SSH session to continue)
