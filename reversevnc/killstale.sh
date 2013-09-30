#!/bin/sh

for PORT in `ps a -u display|grep vncviewer|grep -v grep |awk '{print $7}'`;
do
	netstat -antp 2>/dev/null | grep vncviewer | grep $PORT
	if [ $? -ne 0 ]; then
		STALE_PID=`ps a -u display|grep vncviewer|grep -v grep |grep $PORT |awk '{print $1}'`
		kill -9 $STALE_PID
	fi	
done
