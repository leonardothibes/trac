#!/bin/bash

#Arquivo de senhas.
PASS=/etc/apache2/passwd
if [ ! -f $PASS ]; then
	touch $PASS
	chown 0.0 $PASS
	chmod 644 $PASS
fi

# Verifica se um usuário existe.
#
# @param string $1 Login do usuário.
# @return bool
function apache-user-exists()
{
	COUNT=`grep $1: $PASS | wc -l`
	if [ $COUNT == "0" ]; then
		return 0;
	fi
	return 1;
}


# Definine senha para um usuário do Apache.
# Caso o usuário ainda não exista então será criado.
#
# @param string $1 Login do usuário.
# @return void
function apache-passwd()
{
	if [ "$1" == "" ]; then
		echo "Informe um usuário."
		exit 1
	fi

	htpasswd $PASS $1
}

# Deleta um usuário do Apache.
#
# @param string $1 Login do usuário.
# @return void
function apache-user-remove()
{
	#Verificando se informou um usuário.
	if [ "$1" == "" ]; then
		echo "Informe um usuário."
		exit 1
	fi
	#Verificando se informou um usuário.
	
	#Verificando se o usuário existe.
	COUNT=`grep $1: $PASS | wc -l`
	if [ "$COUNT" == "0" ]; then
		echo "O usuário $1 não foi localizado."
		exit 1
	fi
	#Verificando se o usuário existe.

	#Deletando o usuário de fato.
	TMP=/tmp/tmpfile
	ROW=`grep $1: $PASS`
	sed "/$ROW/d" $PASS > $TMP
	cat $TMP > $PASS
	rm -f $TMP
}

# Lista todos os usuários do Apache.
# @return void
function apache-user-list()
{
	cat $PASS | cut -d ":" -f1
}

# Executa um backup do arquivo de usuários a senhas do Apache.
#
# @param string $1 Nome do projeto.
# @return void
function apache-backup()
{
	
    #Verificando se informou o nome do projeto.
	if [ "$1" == "" ]; then
		echo "Informe o nome do projeto."
		exit 1
	fi
    #Verificando se informou o nome do projeto.

	echo "Executando backup do arquivo de usuários e senhas..."

	#Executando backup do arquivo.
	DIR="/backups/$1/$1_"`date +%Y-%m-%d`
	cp -f $PASS $DIR
	#Executando backup do arquivo.

	echo "Feito!"
}
