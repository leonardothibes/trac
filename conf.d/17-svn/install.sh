#!/bin/bash

echo "Instalando o subversion..."
ETC=`dirname $0`/etc

#Instalando o subversion.
apt-get -y install subversion subversion-tools

#Removendo o irritante exim.
apt-get -y remove exim4 exim4-base exim4-config exim4-daemon-light
dpkg --purge exim4 exim4-base exim4-config exim4-daemon-light

#Criando o diretório dos repositórios e atribuindo permissão.
mkdir /var/lib/svn
chown www-data: /var/lib/svn

#Configurando o subversion.
apt-get -y install libapache2-svn
cp -f $ETC/apache2/mods-enabled/dav_svn.conf /etc/apache2/mods-enabled/

#Criando arquivo de senhas do subversion.
touch /etc/apache2/passwd
chmod 644 /etc/apache2/passwd

#Reiniciando o Apache.
service apache2 restart
