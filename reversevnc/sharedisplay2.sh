#!/bin/sh
PORT=`ssh -t display@display.local /home/display/port.sh`

ssh -C -L ${PORT}:localhost:${PORT} display@display.local "DISPLAY=:0 vncviewer -listen ${PORT} -FullScreen=1" &
ssh -t display@display.local "/home/display/waitport.sh ${PORT}"

x11vnc -coe localhost:${PORT} -rfbport 0 -noclipboard -nosetclipboard -repeat -timeout 5 -clip 1920x1200+1920+0 -scale 1920x1080
