#!/bin/sh

compr=$(< /sys/block/zram0/compr_data_size)
orig=$(< /sys/block/zram0/orig_data_size)
ratio=$(echo "scale=2; $orig*100/$compr" | bc -q)

NUM_AGIS=`xfs_info /dev/zram0 |grep agcount| cut -d\= -f4|cut -d\, -f1`
ICOUNT=0
for i in `seq 0 $((${NUM_AGIS}-1))`
do
CURRENT_AGI=`xfs_db -r -c "agi $i" -c "print count" /dev/zram0 | cut -d\  -f3`
ICOUNT=$((${ICOUNT}+${CURRENT_AGI}))
done


echo -e "Inode count:\t\t ${ICOUNT}"
#echo -e "Number of entries:\t `find ldif -type f 2>/dev/null | wc -l`"
echo -e "Free space:\t\t `df -m| grep zram0 |awk '{ print $4 }'` MB"
echo -e "Uncompressed size:\t $((${orig}/1024/1024)) MB"
echo -e "Compressed size:\t $((${compr}/1024/1024)) MB"
echo -e "Compression ratio:\t ${ratio}%"
echo -e "Fragmentation:\t\t `xfs_db -c frag -r /dev/zram0`"
