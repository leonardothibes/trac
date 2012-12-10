#!/bin/bash

echo "Configurando o SUDO..."
ETC=`dirname $0`/etc

#Instalando o sudo.
apt-get -y install sudo

#Criando um grupo de administradores.
groupadd -g 1000 admin

#Substituindo o arquivo de configuração do serviço.
cp -f $ETC/sudoers /etc
chmod 0440 /etc/sudoers
