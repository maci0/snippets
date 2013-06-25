sudo umount ldif
sudo modprobe zram num_devices=1
SIZE=128 #megabytes
echo $(($SIZE*1024*1024)) | sudo tee /sys/block/zram0/disksize
sudo mkfs.xfs -f /dev/zram0
sudo mount -t xfs /dev/zram0 ldif
sudo chown marcel:marcel ldif/ -R

sleep 2


uri="ldap://127.0.0.1:2222"
/usr/sbin/slapd -h ${uri} -f slapd.conf -d0 &
echo $! > slapd.pid
