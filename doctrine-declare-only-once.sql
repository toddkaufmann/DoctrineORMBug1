  drop table c2_table;
  drop table tab2;

-- very simple: a table with id and a value
  create table c1_table ( id int not null auto_increment, v1 int, primary key (id)) engine=innodb;
  create table c2_table ( id int not null auto_increment, v1 int, primary key (id)) engine=innodb;
  
-- this references one
  
  create table tab1 (  
    c1 int not null, c2_id int not null, 
    primary key (c1,c2_id), 
    constraint fk_c2 foreign key (c2_id) REFERENCES `c2_table`(id) 
  ) engine=innodb;
  

  create table if not exists tab2 (  
    c1_id int not null, c2_id int not null, 
    primary key (c1_id,c2_id), 
    constraint fk_c1 foreign key (c1_id) REFERENCES `c1_table`(id),
    constraint fk_c2_2 foreign key (c2_id) REFERENCES `c2_table`(id)
  ) engine=innodb;

-- forgot had no index there; try with

  drop table tab2;

  create table tab2 (  
    c1_id int not null, c2_id int not null, 
    primary key (c1_id,c2_id), 
    constraint fk_c1 foreign key (c1_id) REFERENCES `c1_table`(id),
    INDEX c1_idx (c1_id),
    INDEX c2_idx (c2_id),
  --  constraint fk_c2 foreign key (c2_id) REFERENCES `c2_table`(id),
  -- 'fk_c2' is already used as a name above, so we have to change
    constraint fk_c2_2 foreign key (c2_id) REFERENCES `c2_table`(id)
  ) engine=innodb;

  -- make another similar ?

  drop table tab3;
  create table tab3 (  
    c1_id int not null, c2_id int not null, 
    primary key (c1_id,c2_id), 
    INDEX c1_3_idx (c1_id),
    INDEX c2_3_idx (c2_id),
-- comment out either line below to make it go away!
    constraint fk_c1_3 foreign key (c1_id) REFERENCES `c1_table`(id),
    constraint fk_c2_3 foreign key (c2_id) REFERENCES `c2_table`(id)
  ) engine=innodb;
