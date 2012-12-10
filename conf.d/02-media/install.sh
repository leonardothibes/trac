#!/bin/bash

echo "Configurando mídias removíveis..."
TMP=/tmp/tmpfile

#Removendo diretórios desnecessários.
rm -Rf /media
rm -Rf /cdrom
rm -Rf /floppy

#Configurando cdrom.
sed "s/\/media\/cdrom0/\/mnt\/cdrom/" /etc/fstab > $TMP
cat $TMP > /etc/fstab

if [ ! -d /mnt/cdrom ]; then
	mkdir /mnt/cdrom
fi

if [ ! -f /cdrom ]; then
	ln -sf /mnt/cdrom /cdrom
fi
#Configurando cdrom.

#Configurando drive de disquete.
sed "s/\/media\/floppy0/\/mnt\/floppy/" /etc/fstab > $TMP
cat $TMP > /etc/fstab

if [ ! -d /mnt/floppy ]; then
	mkdir /mnt/floppy
fi

if [ ! -f /floppy ]; then
	ln -sf /mnt/floppy /floppy
fi
#Configurando drive de disquete.

#removendo arquivos temporário.
rm -f tmpfile
