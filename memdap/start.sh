sudo umount ldif
sudo modprobe zram num_devices=1
SIZE=20480 #megabytes
echo $(($SIZE*1024*1024)) | sudo tee /sys/block/zram0/disksize
sudo mkfs.xfs -f /dev/zram0
sudo mount /dev/zram0 ldif
sudo chown `whoami`:`whoami` ldif/ -R




sed -i 's@readonly on@readonly off@' slapd.conf
sed -i 's@memdap2.pid@memdap.pid@' slapd.conf
sleep 2

uri="ldapi://%2Ftmp%2Fmemdap.socket"
/usr/sbin/slapd -h ${uri} -f slapd.conf





sed -i 's@readonly off@readonly on@' slapd.conf
sed -i 's@memdap.pid@memdap2.pid@' slapd.conf
sleep 2

uri="ldap://0.0.0.0:389"
/usr/sbin/slapd -h ${uri} -f slapd.conf



