#!/bin/sh
if [ ! -d "gluster" ]; then
sh stop.sh
sudo modprobe zram num_devices=1
SIZE=20480 #megabytes
echo $(($SIZE*1024*1024)) | sudo tee /sys/block/zram0/disksize
sudo mkfs.xfs -f /dev/zram0
mkdir ldif
sudo mount /dev/zram0 ldif
sudo chown `whoami`:`whoami` ldif/ -R
fi


/usr/sbin/slapd -h "ldapi://%2Ftmp%2Fslapd.socket" -f slapd.conf
/usr/sbin/slapd -h "ldap://0.0.0.0:1389" -f slapd-ro.conf
