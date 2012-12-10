#!/bin/bash

echo "Configurando adduser.conf..."
ETC=`dirname $0`/etc

cp -f $ETC/adduser.conf /etc
chmod 644 /etc/adduser.conf
