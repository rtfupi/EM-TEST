# (org-open-file "~/doc/make/GNU_make.htm")
#---------------------------------------------------------------------
#$(info D>>>> ...)
#$(warning D>>>> ...)

include ../misc/make/function.mk

#export AT := @
export AT :=

EM_DEBUG := em-git-init


EM_LIBSHELL   := no
EM_SOURCE_SH  := ../ext/em-libshell/lib/em-source.sh
SHELLSUBS_AWK := ../ext/em-libshell/utils/shellsubs/em_shellsubs.awk

TIMESTAMP     := $(call get_timestamp_str)

DST_DIR       := $(HOME)/bin
SRC_DIR       := .ATTIC
BAK_DST_DIR   := .ATTIC/backup
BAK_LOG       := $(DST_DIR)/$(BAK_DST_DIR)/$(TIMESTAMP).log

#DST_CONF_DIR     := $(HOME)/.config
DST_CONF_DIR     := $(HOME)/tmp/0.TEST/.config
SRC_CONF_DIR     := config
BAK_CONF_DST_DIR := .ATTIC/backup
BAK_CONF_LOG     := $(DST_CONF_DIR)/$(BAK_CONF_DST_DIR)/$(TIMESTAMP).log


CP_ONLY :=

AWK := awk
SED := sed
RM  := rm

EM_FILES_SRC := em-git-init

EM_FILES     := $(patsubst %,.ATTIC/%,$(EM_FILES_SRC))
EM_FILES_BIN := $(patsubst %,$(HOME)/bin/%,$(EM_FILES_SRC))

.PHONY: all scripts_install misc_install install clean help

all: help

##.===========================================================================.
##! \fn scripts_install
##! \brief Собрать все целевые скрипты  из исходных скрипт-файлов и
##!        скопировать в каталог ~/bin. Скрипты перечисленны в переменной 
##!        EM_FILES_SRC.
##|
##| \hlp  scripts_install - собрать все целевые скрипты  из исходных
##| \hlp                    скрипт-файлов и скопировать в каталог ~/bin.
##| \hlp                    Пример:
##| \hlp                      make scripts_install
##| \hlp                    или только копирование из ./.ATTIC/
##| \hlp                      make scripts_install CP_ONLY=yes ;
##| \hlp
##'==========================================================================='
scripts_install: $(EM_FILES_BIN)


##.===========================================================================.
##! \fn conf_install.
##! \brief Установить конфигурационные файлы.
##|
##| \hlp  misc_install    - установить конфигурационные файлы.
##| \hlp                    Пример:
##| \hlp                      make conf_install ;
##| \hlp
##'==========================================================================='
conf_install: 
	@echo -en ".----------------\n"
	$(AT)mkdir -p $(HOME)/.config/$(BAK_CONF_DST_DIR)
	$(AT)$(call rsync_bak,\
		--delete,\
		$(BAK_CONF_DST_DIR),\
		$(TIMESTAMP),\
		$(BAK_CONF_LOG),\
		$(SRC_CONF_DIR),\
		$(DST_CONF_DIR))
	@echo -en "'----------------\n"

#	$(AT)mkdir -p $(HOME)/.config/em-git-init-test

##.===========================================================================.
##! \fn misc_install.
##! \brief Установить вспомогательные файлы.
##|
##| \hlp  misc_install    - установить вспомогательные файлы.
##| \hlp                    Пример:
##| \hlp                      make misc_install ;
##| \hlp
##'==========================================================================='
misc_install: 
	@echo -en ".----------------\n"
	$(AT)mkdir -p $(HOME)/.config/.ATTIC
	$(AT)mkdir -p $(HOME)/.config/em-git-init-test
	$(AT)$(call rsync_bak,\
		,\
		$(BAK_DST_DIR),\
		$(TIMESTAMP),\
		$(BAK_LOG),\
		$(SRC_DIR),\
		$(DST_DIR))
	@echo -en "'----------------\n"


##.===========================================================================.
##! \fn Цель - скрипт в кталоге ~/bin
##! \brief Собрать целевой скрипт из исходного скрипт-файла, скопировать в
##!        в каталог ~/bin, сделать backup уже установленного скрипта.
##|
##| \hlp  ~/bin/<script>  - cобрать целевой скрипт из исходного скрипт-файла,
##| \hlp                    скопировать в каталог ~/bin, сделать backup уже
##| \hlp                    установленного скрипта.
##| \hlp                    Пример:
##| \hlp                      make ~/bin/script_name
##| \hlp                    или только копирование из ./.ATTIC/
##| \hlp                      make ~/bin/script_name CP_ONLY=yes ;
##| \hlp
##'==========================================================================='
$(HOME)/bin/%: .ATTIC/%
	@echo -en ".----------------\n"
	$(AT)mkdir -p $(HOME)/bin/.ATTIC
	$(AT)mkdir -p $(HOME)/bin/$(BAK_DST_DIR)
	$(AT)$(call rsync_bak,\
		--include $(subst .ATTIC/,,$<) --exclude '*',\
		$(BAK_DST_DIR),\
		$(TIMESTAMP),\
		$(BAK_LOG),\
		$(SRC_DIR),\
		$(DST_DIR))
	@echo -en "'----------------\n"


##.===========================================================================.
##! \fn Цель - скрипт в ./.ATTIC
##! \brief Собрать целевой скрипт из исходного скрипт-файла и скопировать в
##!        ./.ATTIC
##|
##| \hlp  ./.ATTIC/<script> - собрать целевой скрипт из исходного скрипт-файла
##| \hlp                      и скрипт-файла и скопировать в ./.ATTIC
##| \hlp                      Пример:
##| \hlp                        make ./.ATTIC/<script> ;
##| \hlp
##'==========================================================================='
.ATTIC/%: %
ifneq ($(CP_ONLY),yes)
	if [ n$(EM_LIBSHELL) != nno ];then \
		cat $<|$(AWK) -v debug=0 -v cdir="./" -f $(SHELLSUBS_AWK) > $@;\
	else \
		cp $< $@; \
	fi; \
	sed -i '/^[ \t]*# 8< DEBUG 8<.*$$/,/^[ \t]*# >8 DEBUG >8.*$$/d' $@;\
	sed -i '/^[ \t]*echo "D>>>>.*$$/d' $@;\
	chmod ugo+x $@
endif


##.===========================================================================.
##! \fn clean.
##! \brief Удалить все целевые скрипты.
##|
##| \hlp  clean           - удалить все целевые скрипты:
##| \hlp                    Пример:
##| \hlp                      make clean ;
##| \hlp
##'==========================================================================='
clean:
	$(RM) $(EM_FILES)


##.===========================================================================.
##! \fn help
##! \brief Help message.
##|
##| \hlp
##| \hlp  help            - this message.
##'==========================================================================='
help:
	@echo ""
	@echo "Use:"
	@echo " make [GOAL [VAR=val]]"
	@echo ""
	@echo "GOALS:"
	@echo ""
	@grep '^##| \\hlp' ./Makefile|sed 's/^##| \\hlp//g'


##.===========================================================================.
##| \hlp
##| \hlp Работа с subrepo.
##| \hlp Подключение em-libshell к каталогу ext/em-libshell текущего проекта.
##| \hlp Подготовка:
##| \hlp  1. cd в корень каталога репозитория em-libshell.
##| \hlp  2. Создать ветку в именем проекта, в котором будем использовать
##| \hlp     ф-ии из em-libshell.
##| \hlp  3. cd в корень рабочего каталога текущего проекта.
##| \hlp  4. mkdir -p ext/em-libshell
##| \hlp  5. Создаем subrepo
##| \hlp    git subrepo clone <path_to_em-libshell> ext/em-libshell -b em-git-init
##| \hlp
##'==========================================================================='
