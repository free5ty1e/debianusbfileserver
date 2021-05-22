#!/bin/bash

echo "Installing / enabling camgrid.service and reloading systemctl daemon..."
# sudo service camgrid stop
sudo systemctl --user stop camgrid
sudo cp -vf debianusbfileserver/reference/camgrid.service /etc/systemd/user/
systemctl --user daemon-reload
systemctl --user enable camgrid
camgridservicestart.sh
