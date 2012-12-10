#!/bin/bash

echo "Instalando o configuradores de sistema..."
CONF=`dirname $0`/configurator

cp -Rf $CONF /usr/local
chmod 755 /usr/local/configurator
chmod 755 /usr/local/configurator/project

echo 'PATH=/usr/local/configurator:${PATH}' >> ~/.profile
