uri="ldap://127.0.0.1:2222"
suffix=`cat slapd.conf |grep suffix|cut -d\" -f2`
rootdn=`cat slapd.conf |grep rootdn|cut -d\" -f2`
rootpw=`grep rootpw slapd.conf|awk '{ print $2 }'`

randint32 ()
{
random32=$(( ( ($RANDOM & 3)<<30 | $RANDOM<<15 | $RANDOM ) - 0x80000000 ))
echo $random32
}

randstring ()
{
    chars="abcdefghijklmnopqrstuvwxyz0123456789"
    for ((i=0; $i < 64; i++))
    do        
        pass+=${chars:$(($RANDOM % 36)):1}
    done
    
    echo $pass
}


ldapadd -x -H ${uri} -D "${rootdn}" -w ${rootpw} <<_EOF
dn: dc=example,dc=com
objectClass: dcObject
objectClass: organization
dc: example
o: example com
_EOF


for i in {1..10000}
do
for i in {1..100}
do
echo "dn: cn=`randstring`,${suffix}
cn: `randstring`
uid: `randstring`
objectClass: inetOrgPerson
objectClass: posixAccount
displayName: `randstring`
givenName: `randstring`
sn: `randstring`
uidNumber: `randint32`
gidNumber: `randint32`
homeDirectory: /tmp" | ldapadd -x -H ${uri} -D ${rootdn} -w ${rootpw}  > /dev/null &
done
done


