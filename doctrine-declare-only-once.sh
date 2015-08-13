#!/bin/sh

# Edit the line here for your db instance, or export in your shell to override

: ${MYSQLCMD:="mysql -h localhost -u root  symfony"}
# you can override in the env if you didn't copy to here
: ${SQLDIR:="."}

CONSOLE=app/console

if [ ! -x "$CONSOLE" ]; then
    echo "Are you in a symfony folder?  No app/console to call..."
    exit 1
fi

if echo 'show tables;' | $MYSQLCMD >/dev/null ; then 
    echo Database settings seem okay..
else
    echo Edit script to customize database settings or export MYSQLCMD.
    echo Then we may proceed.
    exit 2
fi

read -p 'WARNING - proceding will possibly wipe out existing entities, maybe do something to your db. "Y" to Proceed?' are_you_sure
if [ "$are_you_sure" != "Y" ]; then
  echo chicken.
  exit 3
fi

clean_test() {
    local SQL=$1
    if [ -e "$SQL" ]; then
	rm -f src/AppBundle/Entity/* \
	    &&  $MYSQLCMD < "$SQL"   \
	    && php $CONSOLE  doctrine:mapping:import  AppBundle annotation
    else
	echo " >>>>>>>>>>>>>> CAN'T FIND  $SQL (did you copy to local? "
	sleep 2
    fi
}


echo "======= 1.  two tables, both reference same with foreign key ======"
clean_test "$SQLDIR"/doctrine-declare-only-once.c1-only.sql
# this one looks fine
ls -lt src/AppBundle/Entity/*

echo
echo "======= 2.  two tables, both reference same two tables with foreign key ======"
clean_test "$SQLDIR"/doctrine-declare-only-once.sql
                   
# this is what you get:
#
#  [Doctrine\ORM\Mapping\MappingException]                                             
#  Property "c2" in "C1Table" was already declared, but it must be declared only once  

# Variation:
# comment out one of the fk's in either table (tab1 or tab2), and no error.
# but one entity will not be generated...  why not?


echo
echo "======= 3.  two tables, both reference same with foreign key, second table columns renamed ======"
clean_test "$SQLDIR"/doctrine-declare-only-once.tab2-renamed.sql
echo
ls -lt src/AppBundle/Entity/*
echo
echo 'Note!  no Tab1 or Tab2 classes!  What'\''s up with that?'

