#!/bin/bash

#Variables
#these variables should be automatically correct
DOMAIN=`hostname -d`
IPA_SERVER=`dig _kerberos._udp.$DOMAIN. srv +noall +answer +short | awk '{print substr($4,0,(length($4)-1))}'` # resolves to something like foo.local
REALM=`echo "${DOMAIN^^}"`
BASEDN=`echo dc=${DOMAIN} | sed 's@\.@,dc=@'` #converts foo.local to "dc=foo,dc=local" and so on.....
FQDN=`hostname -f`

if [ -z "${DOMAIN}" ]; then
	echo "no DOMAIN specified"
	exit 1;
fi

if [ -z "${IPA_SERVER}" ]; then
	echo "no IPA_SERVER specified"
	exit 1;
fi

if [ -z "${FQDN}" ]; then
	echo "no FQDN specified"
	exit 1;
fi

####### Dont edit below this line, unless you know what you are doing,
####### and even then you probably still shouldn't.

#Create Config files
echo "
[domain/"${DOMAIN}"]

cache_credentials = True
krb5_store_password_if_offline = True
ipa_domain = "${DOMAIN}"
id_provider = ipa
auth_provider = ipa
access_provider = ipa
ipa_hostname = "${FQDN}"
chpass_provider = ipa
ipa_server = _srv_, "${IPA_SERVER}"
ldap_tls_cacert = /etc/ipa/ca.crt
[sssd]
services = nss, pam, ssh
config_file_version = 2

domains = "${DOMAIN}"
[nss]

[pam]

[sudo]

[autofs]

[ssh]

[pac]

" > /etc/sssd/sssd.conf

echo "
[global]
basedn = "${BASEDN}"
realm = "${REALM}"
domain = "${DOMAIN}"
server = "${IPA_SERVER}"
xmlrpc_uri = https://"${IPA_SERVER}"/ipa/xml
enable_ra = True
" > /etc/ipa/default.conf

echo "
#File modified by ipa-client-install

includedir /var/lib/sss/pubconf/krb5.include.d/

[libdefaults]
  default_realm = "${REALM}"
  dns_lookup_realm = true
  dns_lookup_kdc = true
  rdns = false
  ticket_lifetime = 24h
  forwardable = yes

[realms]
  "${REALM}" = {
    pkinit_anchors = FILE:/etc/ipa/ca.crt
  }

[domain_realm]
  ."${DOMAIN}" = "${REALM}"
  "${DOMAIN}" = "${REALM}"

" > /etc/krb5.conf

#run setup commands
ipa-getkeytab -s ${IPA_SERVER} -p host/${FQDN} -k /etc/krb5.keytab

chown root:root /etc/krb5.keytab
chmod 0600 /etc/krb5.keytab
restorecon -v /etc/krb5.keytab

chown root:root /etc/sssd/sssd.conf
chmod 0600 /etc/sssd/sssd.conf
restorecon -v /etc/sssd/sssd.conf

wget -O /etc/ipa/ca.crt http://${IPA_SERVER}/ipa/config/ca.crt
certutil -A -d /etc/pki/nssdb -n "IPA CA" -t CT,C,C -a -i /etc/ipa/ca.crt
service certmonger restart
chkconfig certmonger on

ipa-getcert request -d /etc/pki/nssdb -n Server-Cert -K HOST/${FQDN} -N "CN="${FQDN}",O="${REALM}""
authconfig --enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --update
service sssd restart
chkconfig sssd on

