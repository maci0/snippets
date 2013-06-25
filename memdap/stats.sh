#!/bin/sh

compr=$(< /sys/block/zram0/compr_data_size)
orig=$(< /sys/block/zram0/orig_data_size)
ratio=$(echo "scale=2; $orig*100/$compr" | bc -q)

echo -e "Number of entries:\t `find ldif/ |wc -l`"
echo -e "Uncompressed size:\t $((${orig}/1024/1024)) MB"
echo -e "Compressed size:\t $((${compr}/1024/1024)) MB"
echo -e "Compression ratio:\t ${ratio}%"
