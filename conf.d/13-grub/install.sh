#!/bin/bash

echo "Configurando timeout do Grub..."
TMP=/tmp/tmpfile

#Alterando o valor do timeout default.
sed "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/" /etc/default/grub > $TMP
cat $TMP > /etc/default/grub

#Atualizando configurações do grub.
update-grub

#Removendo arquivo temporário.
rm -f $TMP
