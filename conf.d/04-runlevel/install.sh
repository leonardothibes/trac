#!/bin/bash

echo "Configurando runlevel padrão para 3..."
TMP=/tmp/tmpfile

sed "s/id:2:initdefault:/id:3:initdefault:/" /etc/inittab > $TMP
cat $TMP > /etc/inittab
rm -f $TMP
