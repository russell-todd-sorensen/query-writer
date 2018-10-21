-- qw-fns-create.sql
-- Create Query Writer PL Functions Data Model
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 20 February 2002
-- @cvs-id $Id: qw-fns-create.sql,v 1.6 2002/03/18 03:21:38 nsadmin Exp $
--

create table qw_fn_types (
 type integer 
  constraint qfty_type_nn not null
  constraint qfty_type_pk primary key,
 -- name should usually correspond to the input array to qw.tcl
 name varchar(30) 
  constraint qfty_name_nn not null,
 description varchar(100)

);

insert into qw_fn_types values (1,'new','Create New Object');
insert into qw_fn_types values (2,'set','Update Object Attributes');
insert into qw_fn_types values (3,'del','Delete Object');
insert into qw_fn_types values (4,'rst','Reset Object Attributes');

-- qw_fns holds information on which function defs need to be generated
-- functions are the procedural language thing that accesses the objects
-- regular dml access can be achieved without this

create sequence qw_fn_sequence start 99;


create table qw_fns (
 fn_id integer 
  constraint qwfn_fn_id_nn not null
  constraint qwfn_fn_id_pk primary key,
 object_id varchar(100) 
  constraint qwfn_object_id_nn not null
  constraint qwfd_object_id_fk references qw_objects,
 type integer 
  constraint qwfn_type_nn not null
  constraint qwfn_type_fk references qw_fn_types,
 name varchar(30) 
  constraint qwfn_name_nn not null,
 description varchar(100),
 joiner varchar(10) 
  constraint qwfn_joiner_df default null,
 active_p integer
  constraint qwfn_active_p_df default '0'
  constraint qwfn_active_p_nn not null
);



create table qw_fn_attrs (
 attr varchar(100) 
  constraint qwfa_attr_nn not null,
 fn_id integer
  constraint qwfa_fn_id_nn not null
  constraint qwfa_fn_id_fk references qw_fns,
 default_value varchar(100),
 attr_order integer
  constraint qwfa_attr_order_nn not null,
 constraint qwfa_table_pk primary key (fn_id, attr)
);


