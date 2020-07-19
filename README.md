# debianusbfileserver
Debian scripts to support an rsync'd &amp;&amp; redundant USB file server (mine, but it might help you too) ¯\_(ツ)_/¯

To install: Make sure you are connected to the Internet, and copy / paste the following command into your terminal via a nice handy SSH session (or type it, whatever):
```
sudo apt-get -y install git && pushd ~ && rm -rf debianusbfileserver && git clone https://github.com/free5ty1e/debianusbfileserver.git && debianusbfileserver/scripts/installfiles.sh && popd && finishinstall.sh
```

(Note: If you are like me and starting with such a barebones Debian load that `sudo` isn't even installed, the following command sequence might be of interest to you -- and me, since *my* username is `chris` too!)
```
su -
apt-get install sudo
usermod -aG sudo chris
exit
```
(Then relaunch the terminal or relaunch the SSH session to continue)
