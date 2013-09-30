#!/bin/sh
function random_range()
{
    if [ "$#" -lt "2" ]; then
        echo "Usage: random_range <low> <high>"
        return
    fi
    low=$1
    range=$(($2 - $1))
    echo $(($low+$RANDOM % $range))
} 
export PORT=`random_range 5900 10000`
export DISPLAY=:0
export ARGS=${*}


#check if port is already in use, if so generate new
while [ -n "`netstat -antp 2>/dev/null | grep LISTEN | grep $PORT`" ];
do 
	export PORT=`random_range 5900 10000`
done

#echo free port
echo -n $PORT
exit 0
