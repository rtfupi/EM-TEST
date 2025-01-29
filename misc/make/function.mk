##.###########################################################################.
##! Copyright (C) Марков Евгений 2022
##!
##! \file   function.mk
##! \author Марков Евгений <mark@gitlab.utis.lan>
##! \date   2022-09-20 22:36
##!
##! \brief  Библиотека ф-ий.
##|
##'###########################################################################'

# (org-open-file "~/doc/make/GNU_make.htm")

# $(warning "---> function.mk")


comma := ,
null  :=
space := $(null) #


DEVNULL := /dev/null 2>&1



##.=======================================================================.
##! \def get_timestamp_str
##! \brief Ф-ия создание timestamp как строки формата %Y%m%d%H%M%S.
##!
##! \return - timestamp как строка.
##|
##'======================================================================='
get_timestamp_str = $(shell date "+%Y%m%d%H%M%S")



##.=======================================================================.
##! \def insert_instace_hash
##! \brief  Ф-ия заменяет в файле скрипта метку вида {{INSTANCE_HASH_VALUE}}
##!         на hash случайного числа.
##!
##!  $1 - path to file.
##!
##! \return - timestamp как строка.
##|
##'======================================================================='
define insert_instace_hash
fn() { \
	local hs=$$(echo "$${RANDOM}"|sha1sum| head -c 40);\
	sed -i "s/\(Instance hash: \){{INSTANCE_HASH_VALUE}}/\1$${hs}/g" $(strip $(1));\
    }; export -f fn; sh -i -c fn
endef

#get_rundom_hash = $(shell echo "$RANDOM"|sha1sum| head -c 40)


##.===========================================================================.
##! \def rsync_bak
##! \brief Rsync with increment backup.
##!
##! Example:
##!
##! ~/projects/em-dk/develop/bin     ${HOME}/bin
##! +-- dirs or files          ==>   +-- dirs or files
##!     +-- ...                          +-- ...
##!                                      |
##!                                      +-- .ATTIC/backup
##!                                          +-- inc_dir1
##!                                          |   +-- bak dirs or files
##!                                          |   +-- ...
##!                                          +-- inc_dirN
##!                                          |   +-- bak dirs or files
##!                                          |   +-- ...
##!                                          +-- xxxx1.log
##!                                          +-- ...
##!                                          +-- xxxxN.log
##!
##!  $1 - --include 'file1' ... --include 'fileN --exclude '*'
##!  $2 - .ATTIC/backup
##!  $3 - xxxxN
##!  $4 - .ATTIC/backup/xxxxN.log
##!  $5 - .
##!  $6 - $(HOME)/bin
##!
##! \param[in] $1 - a additional rsync options;
##! \param[in] $2 - relative path to destination backup diretory;
##! \param[in] $3 - a name of increment backup diretory;
##! \param[in] $4 - path to logfile;
##! \param[in] $5 - path to source diretory;
##! \param[in] $6 - path to destination diretory.
##|
##'==========================================================================='
define rsync_bak
fn() { \
    rsync $(strip $(1)) \
          --backup --backup-dir="$(strip $(2))/$(strip $(3))" \
          --log-file="$(strip $(4))" --log-file-format="%o %b %f" \
          -Cavz "$(strip $(5))/" "$(strip $(6))/"; \
    }; export -f fn; sh -i -c fn
endef


##.===========================================================================.
##! \def rsync_bak
##! \brief Rsync with increment backup.
##!
##! Example:
##!
##! ~/projects/em-dk/develop/bin     ${HOME}/bin
##! +-- dirs or files          ==>   +-- dirs or files
##!     +-- ...                          +-- ...
##!                                      |
##!                                      +-- .ATTIC/backup
##!                                          +-- inc_dir1
##!                                          |   +-- bak dirs or files
##!                                          |   +-- ...
##!                                          +-- inc_dirN
##!                                          |   +-- bak dirs or files
##!                                          |   +-- ...
##!                                          +-- xxxx1.log
##!                                          +-- ...
##!                                          +-- xxxxN.log
##!
##!  $1 - --include 'file1' ... --include 'fileN --exclude '*'
##!  $2 - .ATTIC/backup
##!  $3 - xxxxN
##!  $4 - .ATTIC/backup/xxxxN.log
##!  $5 - .
##!  $6 - $(HOME)/bin
##!
##! \param[in] $1 - a additional rsync options;
##! \param[in] $2 - relative path to destination backup diretory;
##! \param[in] $3 - a name of increment backup diretory;
##! \param[in] $4 - path to logfile;
##! \param[in] $5 - path to source diretory;
##! \param[in] $6 - path to destination diretory.
##|
##'==========================================================================='
define replace_marked_line
fn() { \
    local bingo=no
    while IFS= read -r line; do \
        if [ n${bingo} == nno ];then
            echo "${line}"|sed 's|^$(strip $(3))$$|;tx;q100;:x'
            if [ ${?} -eq 0 ];then
                bingo=yes
            fi
        else
            echo "$(strip $(4))"
            bingo=no
        fi

     }; export -f fn; sh -i -c fn
endef




    while IFS= read -r line; do
        for mp in ${1};do
            l="$(echo "${line}"|sed -n "s|^[\t ]*MANDB_MAP[\t ]\+${mp}[\t ]\+\(.*\)$|\1|gp")"
            if [ -n "${l}" ];then
                if [ -z "${p}" ]; then p="${l}"; else p="${p}:${l}"; fi
            fi
        done
    done



# $(warning "<--- function.mk")
