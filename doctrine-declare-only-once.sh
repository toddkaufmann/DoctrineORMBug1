#!/bin/sh

# Edit the line here for your db instance, or export in your shell to override

: ${MYSQLCMD:="$HOME/bin/mysql -h localhost -P 8889 -u cal0u -pcal0upw cal0"}
 
read -p 'WARNING - proceding will possibly wipe out existing entities, maybe do something to your db. "Y" to Proceed?' are_you_sure
if [ "$are_you_sure" != "Y" ]; then
  echo chicken.
  exit 1
fi

clean_test() {
 local SQL=$1
 rm -f src/AppBundle/Entity/* \
 &&  $MYSQLCMD < "$SQL"   \
 && php app/console  doctrine:mapping:import  AppBundle annotation
}


echo "======= 1.  two tables, both reference same with foreign key ======"
clean_test ~/git/bug-report/doctrine-declare-only-once.c1-only.sql
# this one looks fine
ls -lt src/AppBundle/Entity/*

echo
echo "======= 2.  two tables, both reference same two tables with foreign key ======"
clean_test ~/git/bug-report/doctrine-declare-only-once.sql
                   
# this is what you get:
#
#  [Doctrine\ORM\Mapping\MappingException]                                             
#  Property "c2" in "C1Table" was already declared, but it must be declared only once  

# Variation:
# comment out one of the fk's in either table (tab1 or tab2), and no error.
# but one entity will not be generated...  why not?


echo
echo "======= 3.  two tables, both reference same with foreign key, second table columns renamed ======"
clean_test ~/git/bug-report/doctrine-declare-only-once.tab2-renamed.sql
echo
ls -lt src/AppBundle/Entity/*
echo
echo 'Note!  no Tab1 or Tab2 classes!  What'\''s up with that?'

