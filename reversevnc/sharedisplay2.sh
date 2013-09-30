#!/bin/sh

ssh display@display.local /home/display/killstale.sh
#ssh display@display.local killall vncviewer


OUTPUT=`ssh -t display@display.local /home/display/vnclistener.sh -FullScreen=1`
PORT=`echo $OUTPUT | cut -d\: -f2`

x11vnc -noclipboard -nosetclipboard -repeat -clip 1920x1200+1920+0 -scale 1920x1080 -coe display.local:$PORT -timeout 5
