#!/bin/bash

#Diretório de repositórios.
SVN=/var/lib/svn
if [ ! -d $SVN ]; then
	mkdir $SVN
	chown www-data: $SVN
	chmod 755 $SVN
fi

# Lista os repositórios svn.
# @return void
function svn-list()
{
	for dir in `ls $SVN`
	do
		echo $dir
	done
}

# Cria um novo repositório.
#
# @param string $1 Nome do novo repositório.
# @return void
function svn-create()
{
	if [ "$1" == "" ]; then
		echo "Informe o nome do repositório."
		exit 1
	fi

	if [ -d $SVN/$1 ]; then
		echo "O repositório $1 já existe."
		exit 1
	fi

	svnadmin create $SVN/$1
	svn-configure $1

	chown -R $WWW: $SVN/$1
	chmod -R 755 $SVN/$1
}

# Configura um repositório recém criado.
#
# @param string $1 Nome do repositório.
# @return void
function svn-configure()
{
	svn mkdir -m "" file://$SVN/$1/trunk    > /dev/null
	svn mkdir -m "" file://$SVN/$1/tags     > /dev/null
	svn mkdir -m "" file://$SVN/$1/branches > /dev/null
}

# Deleta um repositório.
#
# @param string $1 Nome do novo repositório.
# @return void
function svn-delete()
{
	if [ ! -d $SVN/$1 ]; then
		echo "O repositório $1 não foi localizado."
		exit 1
	fi
	
	rm -Rf $SVN/$1
}

# Executa um backup de um repositório svn.
#
# @param string $1 Nome do repositório.
# @return void
function svn-backup()
{
    #Verificando se informou o nome do projeto.
	if [ "$1" == "" ]; then
		echo "Informe o nome do projeto."
		exit 1
	fi
    #Verificando se informou o nome do projeto.

	#Verificando se o repositório existe.
	if [ ! -d $SVN/$1 ]; then
		echo "O repositório $1 não foi localizado."
		exit 1
	fi
	#Verificando se o repositório existe.

	echo "Executando backup do svn..."

	#Deletando o arquivo de dump caso exista previamente.
	DUMP="/backups/$1/$1_"`date +%Y-%m-%d`"/$1.svndump"
	if [ -f $DUMP ]; then
		rm -f $DUMP
	fi
	#Deletando o arquivo de dump caso exista previamente.

	#Executando backup do svn.
	svnadmin dump $SVN/$1 > $DUMP

	echo "Feito!"
}
