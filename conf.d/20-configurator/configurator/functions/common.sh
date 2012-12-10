#!/bin/bash

#Importando funções.
. $FUNC/svn.sh
. $FUNC/trac.sh
. $FUNC/apache.sh

# Lista todos os projetos.
# @return void
function common-list()
{
	svn-list
}

# Cria um projeto.
#
# @param string $1 Nome do novo projeto.
# @return void
function common-create()
{
	svn-create $1
	trac-create $1
	echo "Feito!"
}

# Deleta um projeto.
#
# Após deletar um projeto os arquivos não podem ser recuperados.
# Tenha certeza do que está fazendo. Recomenda-se fazer backup.
#
# @param string $1 Nome do porjeto a ser deletado.
# @return void
function common-delete()
{
	if [ "$1" == "" ]; then
		echo "Informe o nome do projeto."
		exit 1
	fi
	
	read -p "Remover o projeto $1? " OPT
	if [[ $OPT != "s" && $OPT != "S" && $OPT != "y" && $OPT != "Y" ]]; then
		echo "Abortando."
		exit 1
	fi

	svn-delete $1
	trac-delete $1
	echo "Feito!"
}

# Definine senha para um usuário de projeto.
#
# Caso o usuário ainda não exista então será criado.
# Um usuário logado possui acesso a todos os projetos.
#
# @param string $1 Login do usuário.
# @return void
function common-passwd()
{
	if [ "$1" == "" ]; then
		echo "Informe um usuário."
		exit 1
	fi

	apache-passwd $1
}

# Deleta um usuário.
#
# @param string $1 Login do usuário.
# @return void
function common-user-remove()
{
	#Verificando se informou um usuário.
	if [ "$1" == "" ]; then
		echo "Informe um usuário."
		exit 1
	fi
	#Verificando se informou um usuário.

	#Prompt de certeza de exclusão.
	read -p "Remover o usuário $1? " OPT
	if [[ $OPT != "s" && $OPT != "S" && $OPT != "y" && $OPT != "Y" ]]; then
		echo "Abortando."
		exit 1
	fi
	#Prompt de certeza de exclusão.

	#Removendo privilégio de administrador deste usuário em todos os projetos.
	for project in `trac-list`
	do
		trac-revokeadm $project $1
	done
	#Removendo privilégio de administrador deste usuário em todos os projetos.

	#Removendo o usuário do Apache.
	apache-user-remove $1

	echo "Feito!"
}

# Lista todos os usuários.
# @return void
function common-user-list()
{
	apache-user-list
}

# Atribui um admin ao projeto
#
# @param string $1 Nome do projeto.
# @param string $2 Login do usuário.
#
# @return void
function common-admin()
{
	#Verificando a existência do projeto.
	if [ ! -d $TRAC/$1 ]; then
		echo "O projeto $1 não foi localizado."
		exit 1
	fi
	#Verificando a existência do projeto.
	
	#Verificando validade do usuário.
	apache-user-exists $2
	if [ $? == 0 ]; then
		echo "O usuário $2 não foi localizado."
		exit 1
	fi
	#Verificando validade do usuário.

	#Atribuindo permissão de admin.
	trac-configadm $1 $2 > /dev/null 2> /dev/null
	echo "Feito!"
}

# Remove de um usuário o status de admin de um projeto.
#
# @param string $1 Nome do projeto.
# @param string $2 Login do usuário.
#
# @return void
function common-admin-remove()
{
	#Verificando a existência do projeto.
	if [ ! -d $TRAC/$1 ]; then
		echo "O projeto $1 não foi localizado."
		exit 1
	fi
	#Verificando a existência do projeto.

	#Verificando validade do usuário.
	apache-user-exists $2
	if [ $? == 0 ]; then
		echo "O usuário $2 não foi localizado."
		exit 1
	fi
	#Verificando validade do usuário.

	#Revogando permissão de admin.
	trac-revokeadm $1 $2 > /dev/null 2> /dev/null
	echo "Feito!"
}

# Executa um backup geral do projeto.
#
# Por padrão todos os backups são salvos em /backups/[projeto]
# mas se pode especificar este comportamento pode ser alterado
# passando o caminho desejado como segundo parâmetro.
#
# Caso o diretório de backup não exista então este será criado
# na primeira execussão desta rotina.
#
# Por padrão são mantidos os últimos quatro backups. Os mais
# antigos são automaticamente excluídos.
#
# @param string $1 Nome do projeto.
# @param string $2 Diretório de backup(opcional).
#
# @return void
function common-backup()
{
	#Verificando se informou o nome do projeto.
	if [ "$1" == "" ]; then
		echo "Informe o nome do projeto."
		exit 1
	fi
	#Verificando se informou o nome do projeto.

	#Criando o diretório de backup caso não exista.	
	DIR="/backups/$1/$1_"`date +%Y-%m-%d`
	if [ ! -d $DIR ]; then
		mkdir -p $DIR
		chmod -R 755 $DIR
	fi
	#Criando o diretório de backup caso não exista.	

	#Executando os backups.
	trac-backup $1
	svn-backup $1
	apache-backup $1
	#Executando os backups.

	#Gerando arquivo de backup.
	BKP="/backups/$1/$1_"`date +%Y-%m-%d`.tar.gz
	if [ -f $BKP ]; then
		rm -f $BKP
	fi
	cd /backups/$1
	tar -zcf $1_"`date +%Y-%m-%d`.tar.gz" "$1_"`date +%Y-%m-%d`
	rm -Rf "/backups/$1/$1_"`date +%Y-%m-%d`
	cd - > /dev/null
	#Gerando arquivo de backup.
}

# Exibe o texto do help.
# @return void
function help()
{
	cat $FUNC/help.txt
}
