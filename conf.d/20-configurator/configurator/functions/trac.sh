#!/bin/bash

#Diretório de repositórios.
SVN=/var/lib/svn

#Diretório de projetos trac.
TRAC=/var/lib/trac
if [ ! -d $TRAC ]; then
	mkdir $TRAC
	chown www-data: $TRAC
	chmod 755 $TRAC
fi

# Lista os projetos do trac.
# @return void
function trac-list()
{
    for dir in `ls $TRAC`
	do
		echo $dir
	done
}

# Cria um projeto do trac.
#
# @param string $1 Nome do projeto.
# @return void
function trac-create()
{
	if [ "$1" == "" ]; then
		echo "Informe o nome do projeto trac."
		exti 1
	fi

	if [ -d $TRAC/$1 ]; then
		echo "O projeto trac $1 já existe."
		exit 1
	fi

	trac-admin $TRAC/$1 initenv $1 sqlite:db/trac.db svn $SVN/$1 > /dev/null
	chown -R $WWW: $TRAC/$1
	chmod -R 755 $TRAC/$1

	trac-configure $1
	service trac restart > /dev/null
}

# Configura um projeto trac recém criado.
#
# @param string $1 Nome do projeto trac.
# @return void
function trac-configure()
{
	trac-configadm $1
	trac-configenv $1
	trac-configini $1
}

# Configura o administrador do projeto.
#
# @param string $1 Nome do projeto trac.
# @param string $2 Login do usuário(opcional).
#
# @return void
function trac-configadm()
{
	if [ "$2" == "" ]; then
		read -p "Informe o usuário administrador deste projeto: " TRAC_ADMIN_USER
	else
		TRAC_ADMIN_USER=$2
	fi
	
	if [ "$TRAC_ADMIN_USER" != "" ]; then
		trac-admin $TRAC/$1 permission add $TRAC_ADMIN_USER TRAC_ADMIN
	fi
}

# Retira a permissão de administrador de um projeto.
#
# @param string $1 Nome do projeto.
# @param string $2 Login do usuário(opcional).
#
# @return void
function trac-revokeadm()
{
	if [ "$2" == "" ]; then
		read -p "Informe o usuário a perder privilégios neste projeto: " TRAC_ADMIN_USER
	else
		TRAC_ADMIN_USER=$2
	fi
	
	if [ "$TRAC_ADMIN_USER" != "" ]; then
		trac-admin $TRAC/$1 permission remove $TRAC_ADMIN_USER TRAC_ADMIN
	fi
}

# Configura as permissões.
#
# @param string $1 Nome do projeto trac.
# @return void
function trac-configenv()
{
	#Removendo as permissões de visualização anônima.
	trac-admin $TRAC/$1 permission remove anonymous TICKET_VIEW
	trac-admin $TRAC/$1 permission remove anonymous BROWSER_VIEW
	trac-admin $TRAC/$1 permission remove anonymous REPORT_VIEW
	trac-admin $TRAC/$1 permission remove anonymous TIMELINE_VIEW
	trac-admin $TRAC/$1 permission remove anonymous ROADMAP_VIEW

	#Atribuindo permissões de visualização autenticada.
	trac-admin $TRAC/$1 permission add authenticated TICKET_VIEW
	trac-admin $TRAC/$1 permission add authenticated BROWSER_VIEW
	trac-admin $TRAC/$1 permission add authenticated REPORT_VIEW
	trac-admin $TRAC/$1 permission add authenticated TIMELINE_VIEW
	trac-admin $TRAC/$1 permission add authenticated ROADMAP_VIEW

	#Alterando as definições de tipos
	trac-admin $TRAC/$1 ticket_type change defect Manutencao_Emergencial
	trac-admin $TRAC/$1 ticket_type change enhancement Melhoria
	trac-admin $TRAC/$1 ticket_type change task Inovacao
	trac-admin $TRAC/$1 ticket_type add Adequacao
	trac-admin $TRAC/$1 ticket_type add Consulta_Eventual

  	#Alterando as definições de prioridades
	trac-admin $TRAC/$1 priority change blocker Critica
	trac-admin $TRAC/$1 priority change critical Alta
	trac-admin $TRAC/$1 priority change major Media
	trac-admin $TRAC/$1 priority remove minor
	trac-admin $TRAC/$1 priority remove trivial
   
	#Alterando as definições de componentes
	trac-admin $TRAC/$1 component rename component1 Processos
	trac-admin $TRAC/$1 component rename component2 Banco_de_Dados
	trac-admin $TRAC/$1 component add Interface somebody
	trac-admin $TRAC/$1 component add Front_End somebody

	#Alterando as definições de soluções
	trac-admin $TRAC/$1 resolution change fixed Resolvido
	trac-admin $TRAC/$1 resolution change invalid Invalido
	trac-admin $TRAC/$1 resolution change wontfix Nao_Resolvido
	trac-admin $TRAC/$1 resolution change duplicate Duplicado
	trac-admin $TRAC/$1 resolution change worksforme Ambiente
}

# Altera as configurações default do trac.
#
# @param string $1 Nome do projeto trac.
# @return void
function trac-configini()
{
	TEMP=/tmp/tmpfile-$1
	FILE=$TRAC/$1/conf/trac.ini
	
	#Alterando a descrição do projeto.
	sed "s/descr = My example project/descr = /" $FILE > $TEMP
	cat $TEMP > $FILE
	#Alterando a descrição do projeto.

	#Alterando o logo do cabeçalho.
	sed "s/(please configure the \[header_logo\] section in trac\.ini)/logo.png/" $FILE > $TEMP
	cat $TEMP > $FILE

	sed "s/link = /link = \/$1/" $FILE > $TEMP
	cat $TEMP > $FILE

	sed "s/src = site\/your_project_logo.png/src = site\/logo.png/" $FILE > $TEMP
	cat $TEMP > $FILE
	#Alterando o logo do cabeçalho.
	
	#Alterando configurações do visualizador de código.
	sed "s/tab_width = 8/tab_width = 4/" $FILE > $TEMP
	cat $TEMP > $FILE

	sed "s/pygments_default_style = trac/pygments_default_style = manni/" $FILE > $TEMP
	cat $TEMP > $FILE
	#Alterando configurações do visualizador de código.
	
	rm -f $TEMP
}

# Deleta um projeto trac.
#
# @param string $1 Nome do projeto trac.
# @return void
function trac-delete()
{
	if [ ! -d $TRAC/$1 ]; then
		echo "O projeto trac $1 não foi localizado."
		exit 1
	fi

	rm -Rf $TRAC/$1
	service trac restart > /dev/null
}

# Executa um backup de um projeto trac.
#
# @param string $1 Nome do projeto trac.
# @return void
function trac-backup()
{
    #Verificando se informou o nome do projeto.
	if [ "$1" == "" ]; then
		echo "Informe o nome do projeto."
		exit 1
	fi
    #Verificando se informou o nome do projeto.

	echo "Executando backup do trac..."

	#Deletando o diretório caso exista previamente.
	DIR="/backups/$1/$1_"`date +%Y-%m-%d`"/trac"
	if [ -d $DIR ]; then
		rm -Rf $DIR
	fi
	#Deletando o diretório caso exista previamente.

	#Executando backup do trac.
	trac-admin $TRAC/$1 hotcopy $DIR
}
