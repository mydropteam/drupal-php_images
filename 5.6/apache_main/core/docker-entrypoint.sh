#!/bin/bash -e
# Apache2 custom servername, alias and documentroot
sed -i "s/MYSERVERNAME/$XDEBUG_SERVERNAME/g" /etc/apache2/apache2.conf
sed -i "s/MYSERVERALIAS/$XDEBUG_SERVERALIAS/g" /etc/apache2/apache2.conf
sed -i "s/MYDOCUMENTROOT/$DOCUMENTROOT/g" /etc/apache2/apache2.conf
