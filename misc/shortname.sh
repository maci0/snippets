spacecmd -- custominfo_createkey short_hostname short_hostname


for SYSTEM in `spacecmd -- system_list 2> /dev/null`; 
do 

SHORTNAME=`spacecmd -- system_details $SYSTEM |grep Hostname |awk '{print $2}'|awk -F'.' '{print $1}'`

echo adding short_hostname $SHORTNAME to system $SYSTEM

spacecmd -- system_addcustomvalue short_hostname $SHORTNAME $SYSTEM


done
