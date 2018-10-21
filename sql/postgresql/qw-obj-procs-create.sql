-- qw-obj-procs-create.sql

-- Create Query Writer NSV Mapper Data Model
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 9 February 2002
-- @cvs-id $Id: qw-obj-procs-create.sql,v 1.2 2003/07/30 18:19:55 tom Exp $
--

create table qw_nsv_map (
 nsv_name varchar(100) 
  constraint qop_nsv_name_nn not null,
 nsv_element varchar(100)
  constraint qop_nsv_element_nn not null,
 nsv_value varchar(100) 
  constraint qop_nsv_value_nn not null,
 constraint qop_table_pk primary key (nsv_name, nsv_element)
);

insert into qw_nsv_map values ('qw_obj_del', 'pl', 'qw_del_pl_postgresql');
insert into qw_nsv_map values ('qw_obj_del', 'dml', 'qw_del_dml_postgresql');
insert into qw_nsv_map values ('qw_obj_del', 'pseudo', 'qw_del_pseudo_postgresql');
insert into qw_nsv_map values ('qw_obj_new', 'pl', 'qw_new_pl_postgresql');
insert into qw_nsv_map values ('qw_obj_new', 'dml', 'qw_new_dml_postgresql');
insert into qw_nsv_map values ('qw_obj_new', 'pseudo', 'qw_new_pseudo_postgresql');
insert into qw_nsv_map values ('qw_obj_set', 'pl', 'qw_set_pl_postgresql');
insert into qw_nsv_map values ('qw_obj_set', 'dml', 'qw_set_dml_postgresql');
insert into qw_nsv_map values ('qw_obj_set', 'pseudo', 'qw_set_pseudo_postgresql');
