#!/bin/sh

kill -9 `cat /tmp/slapd.pid`
kill -9 `cat /tmp/slapd-ro.pid`

sleep 2
sudo umount ldif
sudo modprobe -r zram
rmdir ldif
