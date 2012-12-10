#!/bin/bash

echo "Configurando apt-get..."

#Atualizando a lista de pacotes.
apt-get update

#Removendo pacotes obsoletos.
apt-get -y autoremove
apt-get -fy install