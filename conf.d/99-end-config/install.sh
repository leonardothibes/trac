#!/bin/bash

echo "Finalizando configuração..."
source ~/.profile

#Removendo pacotes obsoletos.
apt-get -y autoremove
apt-get -fy install

clear
echo "Logue-se novamente para aplicar as alteracoes."
