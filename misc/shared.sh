#!/bin/sh
while true; 
do
	if [[ `tty` == "/dev/tty1" ]];
	then
		screen -x shared
		if [ $? -ne 0 ]; then
			screen -dmS shared
			sleep 5 
			screen -x shared
		fi	
    fi
	
	sleep 10
done
