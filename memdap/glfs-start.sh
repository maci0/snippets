#!/bin/sh
set -e

sudo systemctl start glusterd
mkdir gluster ldif

sudo gluster volume create LDIF transport tcp `hostname -f`:`pwd`/gluster
sudo gluster volume start LDIF
sudo mount.glusterfs `hostname -f`:LDIF ldif
