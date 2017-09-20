select 
 table_name,
 column_name,
 constraint_name
from
 information_schema.constraint_column_usage
where
 table_name = 'customers'
and
 column_name = 'customer_id';
 
 
create table zz_test (
    aa integer not null references acs_objects(object_id),
    bb integer not null,
    cc varchar(100) unique,
     primary key (aa,bb)
);
 
    
select 
 constraint_name,
 ordinal_position
from 
 information_schema.key_column_usage
where
 table_name = 'zz_test'
and
 column_name = 'aa';
 
 
select
 unique_constraint_name
from 
 information_schema.referential_constraints
where
 constraint_name = 'cust_customer_id_fk';
 
select 
 table_name,
 column_name
from
 information_schema.constraint_column_usage
where
 constraint_name = 'acs_objects_object_id_pk'
 limit 1;
 
