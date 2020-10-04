#!/bin/bash

cat /proc/self/mountinfo | grep '/media'
cat /proc/self/mountinfo | grep retropie
cat /proc/self/mountinfo | grep usb
