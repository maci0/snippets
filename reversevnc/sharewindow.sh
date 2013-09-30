#!/bin/sh
set -x
PORT=`ssh -t display@display.local /home/display/port.sh`

ssh -L ${PORT}:localhost:${PORT} display@display.local "DISPLAY=:0 vncviewer -listen ${PORT}" &
ssh -t display@display.local "/home/display/waitport.sh ${PORT}"

x11vnc -rfbport 0 -noclipboard -nosetclipboard -repeat -timeout 15 -id pick -coe localhost:${PORT}

