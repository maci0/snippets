#!/bin/sh

sh stop.sh

sudo modprobe zram num_devices=1
SIZE=20480 #megabytes
echo $(($SIZE*1024*1024)) | sudo tee /sys/block/zram0/disksize
sudo mkfs.xfs -f /dev/zram0
sudo mount /dev/zram0 ldif
sudo chown `whoami`:`whoami` ldif/ -R

/usr/sbin/slapd -h "ldapi://%2Ftmp%2Fslapd.socket" -f slapd.conf
/usr/sbin/slapd -h "ldap://0.0.0.0:389" -f slapd-ro.conf
