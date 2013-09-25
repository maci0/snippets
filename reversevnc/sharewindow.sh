#!/bin/sh

ssh display@192.168.168.111 /home/display/killstale.sh

OUTPUT=`ssh -t display@192.168.168.111 /home/display/vnclistener.sh`
PORT=`echo $OUTPUT | cut -d\: -f2`

x11vnc -repeat -rfbport 0 -id pick -coe 192.168.168.111:$PORT -timeout 5
