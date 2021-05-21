#!/bin/bash

echo "Installing camgrid.service and reloading systemctl daemon..."
sudo cp -vf debianusbfileserver/reference/camgrid.service /etc/systemd/system/
sudo systemctl daemon-reload
