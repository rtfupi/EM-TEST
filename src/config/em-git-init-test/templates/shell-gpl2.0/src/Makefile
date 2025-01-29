# (org-open-file "~/doc/make/GNU_make.htm")
#---------------------------------------------------------------------
#$(info D>>>> ...)
#$(warning D>>>> ...)

include ../misc/make/function.mk

#export AT := @
export AT :=

EM_DEBUG := @@skeleton@@


EM_LIBSHELL   := no
EM_SOURCE_SH  := ../ext/em-libshell/lib/em-source.sh
SHELLSUBS_AWK := ../ext/em-libshell/utils/shellsubs/em_shellsubs.awk

TIMESTAMP     := $(call get_timestamp_str)
DST_DIR       := $(HOME)/bin
SRC_DIR       := .ATTIC
BAK_DST_DIR   := .ATTIC/backup
BAK_LOG       := $(DST_DIR)/$(BAK_DST_DIR)/$(TIMESTAMP).log

CP_ONLY :=

AWK := awk
SED := sed
RM  := rm

EM_FILES_SRC := @@skeleton@@

EM_FILES     := $(patsubst %,.ATTIC/%,$(EM_FILES_SRC))
EM_FILES_BIN := $(patsubst %,$(HOME)/bin/%,$(EM_FILES_SRC))

.PHONY: all all2bin cleanall help test1

all: help

##.===========================================================================.
##! \fn all2bin
##! \brief Собрать все целевые скрипты  из исходных скрипт-файлов и
##!        скопировать в каталог ~/bin. Скрипты перечисленны в переменной 
##!        EM_FILES_SRC.
##|
##| \hlp  all2bin         - собрать все целевые скрипты  из исходных
##| \hlp                    скрипт-файлов и скопировать в каталог ~/bin.
##| \hlp                    Пример:
##| \hlp                      make all2bin
##| \hlp                    или только копирование из  ./.ATTIC/
##| \hlp                      make all2bin CP_ONLY=yes ;
##| \hlp
##'==========================================================================='
all2bin: $(EM_FILES_BIN)


##.===========================================================================.
##! \fn Цель - скрипт в кталоге ~/bin
##! \brief Собрать целевой скрипт из исходного скрипт-файла и скопировать в
##!        в каталог ~/bin.
##|
##| \hlp  ~/bin/<script>  - cобрать целевой скрипт из исходного скрипт-файла
##| \hlp                    и скопировать в каталог ~/bin
##| \hlp                    Пример:
##| \hlp                      make ~/bin/script_name
##| \hlp                    или только копирование из ./.ATTIC/
##| \hlp                      make ~/bin/script_name CP_ONLY=yes ;
##| \hlp
##'==========================================================================='
$(HOME)/bin/%: .ATTIC/%
	@echo -en ".----------------\n"
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
##! \fn cleanall.
##! \brief Удалить все промежуточные скрипты.
##|
##| \hlp  cleanall        - удалить все промежуточные скрипты:
##| \hlp                    make cleanall ;
##| \hlp
##'==========================================================================='
cleanall:
	$(RM) $(EM_FILES)


# Создать wraper для тестирования скрипта через запуск по WIN+F11.
# XFCE -> Settings -> Keyboard -> Aplication Shortcut -> em-test1 Super+F11

##.===========================================================================.
##! \fn test1.
##! \brief Создать wraper для тестирования скрипта через запуск по WIN+F11.
##!
##! XFCE -> Settings -> Keyboard -> Aplication Shortcut -> em-test1 Super+F11
##|
##| \hlp  test1           - Создать wraper для тестирования скрипта через
##| \hlp                    запуск по shotcut-у WIN+F11:
##| \hlp                    make test1;
##| \hlp
##'==========================================================================='
test1: ${HOME}/bin/em-test1

${HOME}/bin/em-test1: tests/$(EM_DEBUG) ./Makefile
	$(SED) "s|{{PWD}}|$$(pwd)|g" $<  > $@; chmod ugo+x $@


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
##| \hlp  1. cd в корень рабочего каталога em-libshell.
##| \hlp  2. Создать ветку с именем проекта, в котором будем использовать
##| \hlp     ф-ии из em-libshell.
##| \hlp  3. cd в корень рабочего каталога текущего проекта.
##| \hlp  4. mkdir -p ext/em-libshell
##| \hlp  5. Создаем subrepo
##| \hlp    git subrepo clone <path_to_em-libshell> ext/em-libshell -b em-git-init
##| \hlp
##'==========================================================================='
