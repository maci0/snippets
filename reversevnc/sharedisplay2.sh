#!/bin/sh

ssh display@192.168.168.111 /home/display/killstale.sh
#ssh display@192.168.168.111 killall vncviewer


OUTPUT=`ssh -t display@192.168.168.111 /home/display/vnclistener.sh -FullScreen=1`
PORT=`echo $OUTPUT | cut -d\: -f2`

x11vnc -noclipboard -nosetclipboard -repeat -clip 1920x1200+1920+0 -scale 1920x1080 -coe 192.168.168.111:$PORT -timeout 5
