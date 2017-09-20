create table customer_types (
	customer_type_id integer not null primary key,
	cust_type_name  varchar(127) not null unique,
	cust_type_descr varchar(1023) not null
);

insert into customer_types values (1,'Program Participant','Normal Customer');
insert into customer_types values (99,'Terminated','Terminated Customer');

create table customers (
	customer_id integer 
	  CONSTRAINT cust_customer_id_nn NOT NULL
	  CONSTRAINT cust_customer_id_pk PRIMARY KEY
	  CONSTRAINT cust_customer_id_fk REFERENCES acs_objects(object_id),
	cust_name varchar(127)
	  CONSTRAINT cust_cust_name_nn NOT NULL
	  CONSTRAINT cust_cust_name_un UNIQUE,
	cust_type integer
	  CONSTRAINT cust_cust_type_nn NOT NULL
	  CONSTRAINT cust_cust_type_fk REFERENCES customer_types(customer_type_id)
	  CONSTRAINT cust_cust_type_df DEFAULT 1,
	cust_external_id varchar(127)
	  CONSTRAINT cust_cust_external_id_nn NOT NULL
);
	  