-- qw-callbacks-create.sql

-- Callbacks Datamodel
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 15 October 2003
-- @cvs-id $Id: qw-callbacks-create.sql,v 1.1 2003/11/07 07:01:04 tom Exp $
--

create table qw_operations (
 operation varchar(30) 
  constraint qcop_operation_nn not null
  constraint qcop_operation_pk primary key,
 description varchar(100)
);

insert into qw_operations 
 values ('new','Create new QW object');
insert into qw_operations 
 values ('set','Update QW object');
insert into qw_operations 
 values ('del','Delete QW object');
insert into qw_operations 
 values ('rst','Reset QW object attribute value.');
insert into qw_operations 
 values ('get','Get QW object or attribute.');

create table qw_callback_types (
 callback_type varchar(30)
  constraint qclt_callback_type_nn not null
  constraint qclt_callback_type_pk primary key,
 description varchar(100)
);

insert into qw_callback_types 
 values ('tcl','TCL Callback');
insert into qw_callback_types
 values ('plpgsql','PLPGSQL Callback');
insert into qw_callback_types
 values ('plsql','PLSQL Callback');

create table qw_callback_points (
 callback_point varchar(100)
  constraint qcap_callback_point_nn not null
  constraint qcap_callback_point_pk primary key,
 description varchar(254)
);

insert into qw_callback_points
 values ('after_object_validate','Run after attributes and object are
validated. Good point to combine attibutes, remove attributes,
or run multi-attribute validation.');
insert into qw_callback_points
 values ('after_object_new','Run after object is created.');
insert into qw_callback_points
 values ('after_object_del','Run after object is deleted.');
insert into qw_callback_points
 values ('after_object_set','Run after object is updated.');
insert into qw_callback_points
 values ('after_object_rst','Run after object attributes are reset.');
insert into qw_callback_points
 values ('after_object_get','Run after object is get.');


create table qw_callbacks (
 callback_id integer
  constraint qcal_callback_id_pk not null
  constraint qcal_callback_id_pk primary key,
 object_id varchar(100)
  constraint qcal_object_id_nn not null
  constraint qcal_object_id_fk references qw_objects,
 operation varchar(100) 
  constraint qcal_operation_nn not null
  constraint qcal_operation_fk references qw_operations,
 callback_point varchar(100)
  constraint qcal_callback_point_nn not null 
  constraint qcal_callback_point_fk 
   references qw_callback_points,
 callback_order integer
  constraint qcal_callback_order_nn not null
  constraint qcal_callback_order_df default '1',
 callback_type varchar(30)
  constraint qcal_callback_type_nn not null
  constraint qcal_callback_type_df default 'tcl'
  constraint qcal_callback_type_fk references qw_callback_types,
 enabled_p char(1) 
  constraint qcal_enabled_p_nn not null
  constraint qcal_enabled_p_df default 't'
  constraint qcal_enabled_p_ck check (enabled_p in ('t','f')),
 callback text 
  constraint qcal_callback_nn not null,
 -- without this constraint, there is no way to ensure the order of row select
 constraint qcal_obj_ord_un unique (object_id,callback_point,operation,callback_order)
);


create sequence qw_callback_seq start 1;
