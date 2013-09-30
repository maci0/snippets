#!/bin/sh
PORT=$1

#wait until everything is ready
while [ -z "`netstat -antp 2>/dev/null | grep vncviewer | grep $PORT`" ];
do
  sleep 1
done

echo Success, listening on port:${PORT}
exit 0
