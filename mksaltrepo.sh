TMP_DIR=$(mktemp -d)
sudo chcon -Rt svirt_sandbox_file_t ${TMP_DIR}
sudo docker run --rm -t -i -v /tmp/out:/out centos:centos6 /bin/bash -c 'yum -y localinstall http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm; yum -y install createrepo yum-utils; mkdir -p /out/salt-repo/el6; cd /out/salt-repo/el6; yumdownloader `repoquery --requires --resolve --repoid=epel salt salt-minion salt-master | sort | uniq` ; createrepo .'
sudo docker run --rm -t -i -v /tmp/out:/out centos:centos7 /bin/bash -c 'yum -y localinstall http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-1.noarch.rpm; yum -y install createrepo yum-utils; mkdir -p /out/salt-repo/el7; cd /out/salt-repo/el7; yumdownloader `repoquery --requires --resolve --repoid=epel salt salt-minion salt-master | sort | uniq` ; createrepo .'
cp -a ${TMP_DIR}/salt-repo .
sudo rm -Rf ${TMP_DIR}
