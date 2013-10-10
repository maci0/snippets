#!/bin/sh
set -e

OUTFILE=/etc/hosts

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for HOST in `host -l  local.domain 192.168.0.1 | grep address`
do
  IP_ADDR=`echo $HOST | awk '{ print $(NF) }'`
  FQDN=`echo $HOST | awk '{ print $(1) }'`
  SHORTNAME=`echo $FQDN | cut -d\. -f 1`

  printf "%s\t\t%-50s%s\n" "$IP_ADDR" "$FQDN" "$SHORTNAME"

done | sort > $OUTFILE

echo -e "127.0.0.1 \t\tlocalhost localhost.localdomain localhost4 localhost4.localdomain4
::1 \t\t\tlocalhost localhost.localdomain localhost6 localhost6.localdomain6" >> $OUTFILE

exit 0
