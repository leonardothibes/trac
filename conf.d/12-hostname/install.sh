#!/bin/bash

echo "Configurando o nome do host..."

#Capturando o nome do host.
read -p "Informe o hostname que o servidor terá na rede(DNS): " HOST_INSTALL
echo $HOST_INSTALL > /tmp/hostname

#Reescrevendo o arquivo /etc/hosts.
echo "127.0.0.1    localhost localhost.localdomain" > /etc/hosts
echo "127.0.0.1    $HOST_INSTALL" >> /etc/hosts
echo "" >> /etc/hosts

#Reincluindo endereços IPV6.
echo "# The following lines are desirable for IPv6 capable hosts" >> /etc/hosts
echo "::1     ip6-localhost ip6-loopback" >> /etc/hosts
echo "fe00::0 ip6-localnet"    >> /etc/hosts
echo "ff00::0 ip6-mcastprefix" >> /etc/hosts
echo "ff02::1 ip6-allnodes"    >> /etc/hosts
echo "ff02::2 ip6-allrouters"  >> /etc/hosts
