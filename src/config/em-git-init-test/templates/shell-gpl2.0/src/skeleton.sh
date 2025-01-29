#!/bin/bash
## SPDX-License-Identifier: GPL-2.0-only 
##.###########################################################################.
##| Copyright (C) @@username@@ @@year@@
##!
##! \file    @@skeleton@@
##! \author  @@username@@ <@@useremail@@>
##! \date    @@timestamp@@
##! \version 0.1
##!
##! \brief  ...
##!         ...
##!
##! ...
##! ...
##!
##! \copyright GNU General Public License v2.
##|
##'###########################################################################'

SN=$(basename $0)
EM_SN=$(basename $(realpath "${0}"))
EM_DN=$(dirname $0) 

EM_VERSION=0.1

 
## 8< DEBUG 8< @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
##.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.
##| EM_D - вывод в файл.
##'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
# Задать переменную окружения 'EM_DEBUG_OTPUT' (разрешить export), в которой
# задан путь до файла для вывода отладочной информации  ф-ей 'EM_D'.
# Ф-ию 'EM_D' можно использовать в этом скрипте и во всех скриптах,
# запущенных из этого скрипта.
# export EM_DEBUG_OTPUT="/tmp/${SN}.debug"

# Если не разрешать export, то ф-ия бадет работать только в этом скрипте
EM_DEBUG_OTPUT="/tmp/${EM_SN}.debug"

if [ -n "${EM_DEBUG_OTPUT}" ];then

    ## Весь вывод в файл ${EM_DEBUG_OTPUT}
    # exec >> "${EM_DEBUG_OTPUT}" 2>&1; function EM_D(){ echo "${@}"; }

    # Только вывод ф-ии 'EM_D' в файл ${EM_DEBUG_OTPUT}
    function EM_D(){ echo "${@}" >> "${EM_DEBUG_OTPUT}"; }

    # Если экспортируется переменная окружения EM_DEBUG_OTPUT,
    # то экспортируется и ф-я EM_D
    [ "$(sh -c 'echo -n ${EM_DEBUG_OTPUT}')" ] && export -f EM_D
else
    function EM_D { return; }
fi

EM_D ""
EM_D ".================="
EM_D "| ${EM_DN}/${SN} (${EM_SN}) $(date "+%Y-%m-%d %H:%M:%S")"
EM_D "'================="
## >8 DEBUG >8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'



##.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.
##| Установка значение локали для help2man с помощью переменной окружения
##| EM_HELP_LOCALE
##'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
EM_HLP_L=C
[ -n "${EM_HELP_LOCALE}" ] && EM_HLP_L=${EM_HELP_LOCALE}


##.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.
##| Проверка наличия команд в системе.
##|
##'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
EM_CHECK_CMD="cmd1 cmd2 ..."
EM_FL=
for cmd in ${EM_CHECK_CMD};do
    if ! type ${cmd} > /dev/null 2>&1; then
        cmd=$(printf "*** Error: %s: command not found." "${cmd}")
        logger -p local2.info -t ${SN} "${cmd}"; echo "${cmd}" >&2
        EM_FL=yes
    fi
done
[ y${EM_FL} = yyes ] && exit 1



## 8< DEBUG 8< @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
##.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.
##| Для отладки c использованием em-libshell.
##|
##'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
# set -x
# logger -p local2.info -t ${SN} "><"
 exec > "/tmp/${SN}.log" 2>&1
. "../../ext/em-libshell/lib/em-source.sh"
{
    echo
    echo
    echo " =========================="
# }
} > "/tmp/${SN}.log"
## >8 DEBUG >8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'



##.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.
##| Logging.
##|
##'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
# Уровень логирования в виде двух разрядного числа. Младший разряд отвечает
# за syslog, старший - за stderr.
EM_LIB_SYSLOG_LEVEL=00 # 99 - показывать все;
                       # 00 - только самое необходимое.

# Глобальные переменные для раздельной блокировки каналов логирования.
EM_LIB_SYSLOG_SYSLOG= # пустая строка - разрешает syslog
EM_LIB_SYSLOG_STDERR= # пустая строка - разрешает stderr



##.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
##| External library.
##|
##'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

em_source "../../ext/em-libshell/lib/syslog/em_lib_syslog_logger.sh"
em_source "../../ext/em-libshell/lib/syslog/em_lib_syslog_cmd_not_found.sh"

em_source "../../ext/em-libshell/lib/misc/em_lib__debug.sh"

em_source "../../ext/<category>/<name>.sh"

# Verifying that commands are available.
em_lib_syslog_cmd_not_found "${EM_LIB_CHECK_CMD}" || exit 1


##.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
##| Local library
##|
##'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

##.=======================================================================.
##! \brief .
##!
##! \param $1 - .
##!
##! \return  - return code :
##!                 0 -
##!                 1 -
##!            stdout :
##!            stderr :
##|
##'======================================================================='
em_lib_ () {
    local xxx

}
#export -f em_lib_


##.===============================================================.
##! \brief Short information about arguments.
##|
##'==============================================================='
help_message_short ()
{
    local usage options fl
    
    while IFS= read -r line; do

        if [ y${usage} != yyes ];then
            echo "${line}"|sed -n 's/^Usage:.*$/\0/gp;tx;q100;:x'
            if [ ${?} -eq 0 ];then
                usage=yes
            else
                continue
            fi
        elif [ y${options} != yyes ];then
            echo "${line}"| \
                sed 's/^Options:.*$/\0/g;tx;q100;:x'
            if [ ${?} -eq 0 ];then
                options=yes
            fi
        else
            echo "${line}"|sed -n 's/^.\+$/\0/gp;tx;q100;:x'
            [ ${?} -eq 100 ] && break
        fi
    done
}


##.=======================================================================.
##! \brief Information about arguments.
##|
##'======================================================================='
help_message ()
{
    case "${EM_HLP_L}" in
        ru_RU.UTF-8)
            cat << EOF
Описание объясняет, что делает команда, функция или формат. 

Использование: ${SN} {--help}|{-h}|{--version|-V}
   или: ${SN} -o 

Параметры:
  -o             опция.
  -V, --version  версия.
  -h             вывести краткую справку скрипта.
  --help         вывести справку скрипта.

Примеры:
   Содержит один или несколько примеров использования данной функции, файла
   или команды.

Файлы:
   Список файлов, используемых программой или функцией, таких как
   конфигурационные файлы, файлы запуска и файлы, с которыми непосредственно
   работает программа.

Окружение:
     Перечень переменных окружения, влияющих на программу и оказываемый ими
     эффект.

Автор: @@username@@ <@@useremail@@>.
EOF
            ;;
        C|POSIX)
            cat << EOF
An explanation of what the program, function, or format does.

Usage: ${EM_SN} {--help}|{-h}|{--version|-V}
   or: ${SN} -o 

Options:
  -o             the option.
  -V, --version  version info.
  -h             print short help end exit.
  --help         print this help end exit.

Examples:
   One or more examples demonstrating how this function, file, or command
   is used.

Files:
   A  list  of  the files the program or function uses, such as
   configuration files, startup files, and files the program directly
   operates on.

Environment:
   A list of all environment variables that affect the program or function
   and how they affect it.

Written by @@username@@ <@@useremail@@>.
EOF
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}



##.=======================================================================.
##! \brief Information about version.
##|
##'======================================================================='
version_message ()
{
    cat << EOF
${SN} v${EM_VERSION}

Copyright (c) @@username@@ @@year@@
License GPLv2: GNU GPL version 2
https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
EOF
    return 0
}



##.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
##| Main part.
##|
##'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

HELP_MESS=
VER_MESS=
ERROR_OPTION=
ERROR_OPTION_LST=

EM_OPTION=

EM_VAL=

while [ -n "$1" ]
do
    case "$1" in
        -V|--version) VER_MESS=yes;;
        --help|-h) HELP_MESS=yes;;
        --option|-o) OPTION="yes";;
        --Option|-O) shift; EM_OPTION1="${1}";;
        -*) ERROR_OPTION=yes;ERROR_OPTION_LST="${ERROR_OPTION_LST} $1";;
        *) EM_VAL="${1}";;
    esac
    shift
done

if [ -n "${ERROR_OPTION}" ]; then
    echo "***Error: ${ERROR_OPTION_LST}: no such options."
    help_message
    exit 1
fi

if [ -n "$HELP_MESS" ]; then help_message; exit 0; fi

if [ -n "$VER_MESS" ]; then version_message; exit 0; fi


## 8< DEBUG 8< @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.
# EM_D ">>>>> EM_ =  >${EM_}<"

## >8 DEBUG >8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
...

exit

## 8< DEBUG 8< @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.

# (em:timestamp-insert)

#* Doc
#** _

## >8 DEBUG >8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
