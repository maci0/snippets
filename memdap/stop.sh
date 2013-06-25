kill -9 `cat /tmp/memdap.pid`
kill -9 `cat /tmp/memdap2.pid`

sleep 2
sudo umount ldif
sudo modprobe -r zram
