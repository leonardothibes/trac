#!/bin/bash

clear
echo "Adicionando um usuário..."

#Removendo todos os usuários criados até o momento.
for user in `ls /home`
do
	userdel -r $user
done
#Removendo todos os usuários criados até o momento.

#Adicionando o usuário.
read -p "Informe um login de usuário para adicionar: " USER_INSTALL
read -p "Digite uma pequena descrição para este usuário: " DESC_INSTALL
useradd $USER_INSTALL -g users -G admin -s /bin/bash -d /home/$USER_INSTALL -c "$DESC_INSTALL"
passwd $USER_INSTALL
#Adicionando o usuário.

#Criando o HOME deste usuário.
cp -Rf /etc/skel/ /home/$USER_INSTALL
chown -Rf $USER_INSTALL.users /home/$USER_INSTALL
chmod -Rf 700 /home/$USER_INSTALL
