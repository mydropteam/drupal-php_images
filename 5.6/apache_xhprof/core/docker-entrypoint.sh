#!/bin/bash -e
set -eo pipefail
# Apache2 custom servername, alias and documentroot
sed -i "s/MYSERVERNAME/$XHPROF_SERVERNAME/g" /etc/apache2/apache2.conf
sed -i "s/MYSERVERALIAS/$XHPROF_SERVERALIAS/g" /etc/apache2/apache2.conf
sed -i "s/MYDOCUMENTROOT/$DOCUMENTROOT/g" /etc/apache2/apache2.conf

exec "$@"
