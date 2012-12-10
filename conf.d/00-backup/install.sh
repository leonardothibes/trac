#!/bin/bash

echo "Fazendo backup das configurações..."
DIR=$HOME/bkp-confs

#Criando diretório de configurações.
if [ ! -d $DIR ]; then
	mkdir -p $DIR/etc
fi

#Fazendo backup do arquivo /etc/hosts.
if [ ! -f $DIR/etc/hosts ]; then
	cp /etc/hosts $DIR/etc
fi

#Fazend backup do arquivo /etc/fstab.
if [ ! -f $DIR/etc/fstab  ]; then
	cp /etc/fstab $DIR/etc
fi

#Fazend backup do arquivo /etc/inittab.
if [ ! -f $DIR/etc/inittab  ]; then
	cp /etc/inittab $DIR/etc
fi

#Fazendo backup do arquivo /etc/vim/vimrc
if [ ! -d $DIR/etc/vim ]; then
	mkdir $DIR/etc/vim
	cp -f /etc/vim/vimrc $DIR/etc/vim
fi

#Fazendo backup do arquivo /etc/adduser.conf
if [ ! -f $DIR/etc/adduser.conf ]; then
	cp /etc/adduser.conf $DIR/etc
fi

#Fazendo backup do diretírio /etc/apt.
if [ ! -d $DIR/etc/apt ]; then
	cp -Rfp /etc/apt $DIR/etc
fi

# Fazendo backup do diretório /etc/skel.
if [ ! -d $DIR/etc/skel ]; then
	cp -Rfp /etc/skel $DIR/etc
fi

# Fazendo backup do diretório do root.
if [ ! -d $DIR/root ]; then
	mkdir $DIR/root
	if [ -f /root/.bashrc ]; then
		cp -f /root/.bashrc $DIR/root
	fi
	if [ -f /root/.profile ]; then
		cp -f /root/.profile $DIR/root
	fi
fi
