#!/bin/bash

echo "Configurando ambiente bash..."
ETC=`dirname $0`/etc

#Copiando colourrc para deixar o ls colorido.
cp -f $ETC/colourrc /etc

#Copiando arquivos de ambiente.
cp -f $ETC/profile /etc
cp -f $ETC/bashrc /etc
rm -f /etc/bash.bashrc

#Substituindo /etc/skel
rm -Rf /etc/skel
cp -Rf $ETC/skel /etc
chmod 755 -R /etc/skel
#Substituindo /etc/skel

#Removendo arquivos de login do root.
rm -f /root/.bash_history
rm -f /root/.bash_logout
rm -f /root/.bashrc
rm -f /root/.profile

cp -f /etc/skel/.profile /root
cp -f /etc/skel/.bash_logout /root
cp -f /etc/skel/.bash_history /root

if [ ! -d /root/tmp ]; then
	mkdir /root/tmp
	chmod 700 /root/tmp
fi

if [ ! -d /root/.bin ]; then
	mkdir /root/.bin
	chmod 700 /root/.bin
fi

chmod 700 /root
#Removendo arquivos de login do root.

#Criando diretório de scripts globais.
if [ ! -d /usr/local/bin ]; then
	mkdir /usr/local/bin
	chmod 755 /usr/local/bin
fi
#Criando diretório de scripts globais.
