#!/bin/bash

echo "Instalando o Trac..."
ETC=`dirname $0`/etc

#Instalando o trac.
apt-get -y install trac

#Criando diretório dos projetos e atribuindo permissão.
mkdir /var/lib/trac
chown www-data: /var/lib/trac

#Copiando arquivo do serviço init.
cp $ETC/init.d/trac /etc/init.d
chmod 755 /etc/init.d/trac

#Incluíndo o trac no boot do sistema.
TMP=/tmp/tmpfile
sed "s/clear/service trac start/" /etc/rc.local > $TMP
cat $TMP > /etc/rc.local
rm -f $TMP
echo "clear" >> /etc/rc.local

#Configurando página inicial do servidor.
TMP=`dirname $0`/template
cp -f $TMP/index.html /usr/share/pyshared/trac/templates

#Configurando redirecionamento para a porta do trac.
TMP=/tmp/tmpfile
HST=`cat /tmp/hostname`
rm -f /etc/apache2/sites-enabled/*
sed "s/HOSTNAME/$HST/" $ETC/apache2/sites-enabled/trac > $TMP
cat $TMP > /etc/apache2/sites-available/trac
cd /etc/apache2/sites-enabled
ln -sf ../sites-available/trac 00-trac
cd -

#Iniciando o trac.
service trac start

#Reiniciando o Apache.
service apache2 restart
