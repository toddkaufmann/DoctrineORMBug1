  drop table c1_table;
  drop table c2_table;

  drop table tab1;

  drop table tab2;

  drop table tab3;


-- very simple: a table with id and a value
  create table c1_table ( id int not null auto_increment, v1 int, primary key (id)) engine=innodb;
  create table c2_table ( id int not null auto_increment, v1 int, primary key (id)) engine=innodb;
  
-- this references one
  
  create table tab1 (  
    c1 int not null, c2_id int not null, 
    primary key (c1,c2_id), 
    constraint fk_c2 foreign key (c2_id) REFERENCES `c2_table`(id) 
  ) engine=innodb;

xxx above note used  

-- forgot had no index there; try with

  drop table tab2;
  create table tab2 (  
    c1_id int not null, c2_id int not null, 
 abccd_value int,
    primary key (c1_id,c2_id), 
    INDEX c1_idx (c1_id),
    INDEX c2_idx (c2_id),
    constraint fk_c1_2 foreign key (c1_id) REFERENCES `c1_table`(id),
    constraint fk_c2_2 foreign key (c2_id) REFERENCES `c2_table`(id)
  ) engine=innodb;

  -- make another similar ?

  drop table tab1;
  create table tab1 (  
    c1_id int not null, c2_id int not null, 
 xyzzy_value int,
    primary key (c1_id,c2_id), 
    INDEX c1_3_idx (c1_id),
    INDEX c2_3_idx (c2_id),
-- comment out either line below to make it go away!
--    constraint fk_c1_3 foreign key (c1_id) REFERENCES `c1_table`(id),
    constraint fk_c2_3 foreign key (c2_id) REFERENCES `c2_table`(id)
  ) engine=innodb;

-- hey, 
-- tab1 tab2 are similar tables, but no code gen'd for 1 ?

-- then run
-- php app/console       doctrine:mapping:import               AppBundle annotation