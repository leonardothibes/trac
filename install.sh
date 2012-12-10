#!/bin/bash

#Verificando permissão de root.
clear
if [ "`id -u`" -ne 0 ]; then
	echo "É necessário ter permissão de root para rodar este script"
	exit 1
fi
#Verificando permissão de root.

#Percorrendo todos os diretórios de configuração e executando as instalações individuais.
export CONF=`dirname $0`/conf.d
for dir in `ls $CONF`
do
	./$CONF/$dir/install.sh
done
#Percorrendo todos os diretórios de configuração e executando as instalações individuais.
