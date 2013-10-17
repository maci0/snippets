#!/bin/sh

sudo umount ldif
yes | sudo gluster volume stop LDIF
yes | sudo gluster volume delete LDIF
sudo rm -Rf ldif gluster

sudo systemctl stop glusterd
