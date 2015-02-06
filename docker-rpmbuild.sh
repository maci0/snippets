#!/bin/bash
IMAGE="fedora:21"
PACKAGE=${1}
PACKAGE_NAME=$(rpm -qp --queryformat "%{NAME}" ${PACKAGE})
PACKAGE_BASENAME=$(basename ${PACKAGE})
BUILD_DIR=$(mktemp -d /tmp/docker-rpmbuild.XXXXXXXXXXXX)
mv ${BUILD_DIR} $(echo ${BUILD_DIR,,})
BUILD_DIR=$(echo ${BUILD_DIR,,})
TMP_NAME=$(echo ${BUILD_DIR,,} | cut -d\/ -f3)

cp ${PACKAGE} ${BUILD_DIR}

cd ${BUILD_DIR}

echo ${BUILD_DIR}

cat <<EOF > compile.sh
#!/bin/bash
set -e
export CC="/usr/bin/ccache gcc"
export CXX="/usr/bin/ccache g++"
export CCACHE_DIR=/ccache

sed -i 's/keepcache=0/keepcache=1/' /etc/yum.conf

yum -y install @buildsys-build yum-utils ccache
ccache -M 8G

rpm -i /${PACKAGE_BASENAME}

yum-builddep -y /root/rpmbuild/SPECS/${PACKAGE_NAME}.spec
yum -y upgrade

rpmbuild -ba /root/rpmbuild/SPECS/${PACKAGE_NAME}.spec
EOF

cat <<EOF > Dockerfile
FROM ${IMAGE}
VOLUME ["/ccache"]
VOLUME ["/var/cache/yum"]
ADD compile.sh /
ADD ${PACKAGE_BASENAME} /
EOF

sleep 1

sudo docker run -d --name=docker-rpmbuild-cache -v /ccache -v /var/cache/yum --restart=always busybox

sudo docker build --rm -t ${TMP_NAME} .
sudo docker run -t -i --name=${TMP_NAME} --volumes-from docker-rpmbuild-cache ${TMP_NAME} /bin/bash /compile.sh
sudo docker cp ${TMP_NAME}:/root/rpmbuild/RPMS ${BUILD_DIR}
sudo docker cp ${TMP_NAME}:/root/rpmbuild/SRPMS ${BUILD_DIR}

sudo docker rm ${TMP_NAME} 
sudo docker rmi ${TMP_NAME} 

echo ${BUILD_DIR}
find ${BUILD_DIR} | grep \\.rpm
