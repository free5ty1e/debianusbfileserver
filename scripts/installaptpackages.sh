#!/bin/bash

echo Applying package manager fixes...
sudo apt-get clean
sudo dpkg --configure -a
sudo apt-get -yf install

echo "Obtaining required packages / dependencies..."
sudo apt-get purge -y p7zip
sudo apt-get autoremove
sudo apt-get install -y git curl samba samba-client cifs-utils ftp curlftpfs dialog ntfs-3g cowsay pv bc expect openssl parted gdisk rsync e2fsprogs smartmontools hddtemp hdparm p7zip-full usbmount screen libavformat-dev libavcodec-dev libavutil-dev ffmpeg unzip scrot sudo apt install f3 autoconf libtool pkg-config build-essential
#joystick ntfs-3g cowsay imagemagick angband pv bc libssl-dev glib-networking expect openssl gdisk rsync
#exfat-utils (we will build exfatprogs from source as it is better)

##exfatprogs:
rm -rf exfatprogs
git clone https://github.com/exfatprogs/exfatprogs.git
cd exfatprogs
sed -i 's/2.70/2.69/' configure.ac
mkdir -p m4
./autogen.sh
./configure
make
sudo make install
fsck.exfat --version
echo "Above version should show exfatprogs"

# installGoAndAnsize.sh
#libbluetooth3 bluez bluez-utils bluez-compat bluez-hcidump bluetooth wicd-curses

installAutoMountUsbByLabelToUsbmount.sh

alias cp="rsync -ah --info=progress2"
alias ls='ls --color=auto -lha'
