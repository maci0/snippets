uri="ldapi://%2Ftmp%2Fmemdap.socket"
suffix=`cat slapd.conf |grep suffix|cut -d\" -f2`
rootdn=`cat slapd.conf |grep rootdn|cut -d\" -f2`
rootpw=`grep rootpw slapd.conf|awk '{ print $2 }'`

ldapadd -x -H ${uri} -D "${rootdn}" -w ${rootpw} <<_EOF
dn: dc=example,dc=com
objectClass: dcObject
objectClass: organization
dc: example
o: example com
_EOF


END=100000000
i=1 ; while [[ $i -le $END ]] ; do

echo "dn: cn=${i},${suffix}
cn: ${i}
uid: ${i}
objectClass: inetOrgPerson
objectClass: posixAccount
displayName: ${i}
givenName: ${i}
sn: ${i}
uidNumber: ${i}
gidNumber: ${i}
homeDirectory: /tmp"  | ldapadd -x -H ${uri} -D ${rootdn} -w ${rootpw}  > /dev/null

    ((i = i + 1))
done
