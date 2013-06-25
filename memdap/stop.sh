kill -9 `cat slapd.pid`
sleep 2
sudo umount ldif
sudo modprobe -r zram
rm slapd.pid
