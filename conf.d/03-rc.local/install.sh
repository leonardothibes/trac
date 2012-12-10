#!/bin/bash

echo "Habilitando limpeza de tela no rc.local depois no boot..."
TMP=/tmp/tmpfile

sed "s/exit 0/clear/" /etc/rc.local > $TMP
cat $TMP > /etc/rc.local
rm -f $TMP
