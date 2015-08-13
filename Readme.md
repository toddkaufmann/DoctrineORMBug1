To run the examples here:
1. copy (or link) *.sql *.sh  to your symfony folder,
2. have correct db settings in parameters.yml
3. export MYSQLCMD with your proper credentials or edit the .sh file,
4. run
./doctrine-declare-only-once.sh

you should see something like the contents of test-output.txt


This is the initial bug text submitted
http://www.doctrine-project.org/jira/browse/DDC-3873
-----------------------------------------------------------------------------

I'm reverse engineering a large (100+ tables) schema and encountered the 

    Property "X" in "TableY" was already declared, but it must be declared only once

message and was unable to find a satisfactory solution or explanation,
so I tried to find a small example of the problem.  In doing so I may
have also found another bug where entities do not get generated for
existing tables.  Attached are 

1.  Two tables referencing the same table.column as foreign key.  This
seems to have been the problem in the past, but here seems to work fine.

   doctrine-declare-only-once.c1-only.sql

2.  This example has two tables both referencing the same  two other
tables, and results in the error

  Property "c2" in "C1Table" was already declared, but it must be declared only once  

besides being two foreign key constraints, isn't that different than the first.

    doctrine-declare-only-once.sql

2(b).  NOTE:  if you comment out either of the foreign key constraints in
either table tab1 or tab2, the error goes away.  But one of them will not be
generated...  try it.


3.  The column c2_id is renamed to c2_idxx from the above, and now the
message goes away.  But neither tab1 nor tab2 are generated!
If you look at the other two files there are references to tab1 & tab2 though.

    doctrine-declare-only-once.tab2-renamed.sql



These files and a script to call them are also at
https://github.com/toddkaufmann/DoctrineORMBug1

Thanks.
