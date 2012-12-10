#!/bin/bash

echo "Instalando o Apache..."

#Instalando o Apache.
apt-get -y install apache2 apache2-utils

#Ativando o mod_rewrite
cd /etc/apache2/mods-enabled
ln -sf ../mods-available/rewrite.load
cd -

#Reiniciando o apache
service apache2 restart
