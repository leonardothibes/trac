#!/bin/bash

echo "Instalando o vim..."
ETC=`dirname $0`/etc

#Instalando o VIM.
apt-get -y install vim

#Substituindo o arquivo de configuração original
cp -f $ETC/vim/vimrc /etc/vim
