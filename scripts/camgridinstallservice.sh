#!/bin/bash

echo "Installing / enabling camgrid.service and reloading systemctl daemon..."
# sudo service camgrid stop
systemctl --user stop camgrid
cp -vf debianusbfileserver/reference/xsession /home/pi/.xsession
chmod +x /home/pi/.xsession
sudo cp -vf debianusbfileserver/reference/xsession.target /etc/systemd/user/
sudo cp -vf debianusbfileserver/reference/camgrid.service /etc/systemd/user/
systemctl --user daemon-reload
systemctl --user enable camgrid
camgridservicestart.sh
