#!/bin/sh
set -e

sudo systemctl start glusterd
mkdir gluster ldif

sudo modprobe zram num_devices=1
SIZE=20480 #megabytes
echo $(($SIZE*1024*1024)) | sudo tee /sys/block/zram0/disksize
sudo mkfs.xfs -f /dev/zram0
sudo mount /dev/zram0 gluster

sudo gluster volume create LDIF transport tcp `hostname -f`:`pwd`/gluster
sudo gluster volume start LDIF
sudo mount.glusterfs `hostname -f`:LDIF ldif
sudo chown `whoami`:`whoami` ldif/ -R
