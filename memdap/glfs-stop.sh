#!/bin/sh

sudo umount ldif
yes | sudo gluster volume stop LDIF
yes | sudo gluster volume delete LDIF
sudo umount gluster
sudo rm -Rf ldif gluster
sudo modprobe -r zram


sudo systemctl stop glusterd
