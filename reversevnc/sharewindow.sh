#!/bin/sh

ssh display@display.local /home/display/killstale.sh

OUTPUT=`ssh -t display@display.local /home/display/vnclistener.sh`
PORT=`echo $OUTPUT | cut -d\: -f2`

x11vnc -noclipboard -nosetclipboard -repeat -rfbport 0 -id pick -coe display.local:$PORT -timeout 5
