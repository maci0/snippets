#!/bin/sh
export PORT=`shuf -i 2000-65000 -n 1`
export DISPLAY=:0
export ARGS=${*}

#check if port is already in use, if so generate new
while [ -n "`netstat -antp 2>/dev/null | grep LISTEN | grep $PORT`" ];
do 
	export PORT=`shuf -i 2000-65000 -n 1`
done

#echo free port
echo -n $PORT
exit 0
