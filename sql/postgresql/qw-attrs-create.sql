-- qw-attrs-create.sql
-- Create Query Writer Attributes Data Model
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 27 January 2002
-- @cvs-id $Id: qw-attrs-create.sql,v 1.9 2003/11/07 07:01:04 tom Exp $
--

create table qw_attrs (
 attr_id varchar(100) 
  constraint qwa_attr_id_nn not null,
 object_id varchar(100)
  constraint qwa_object_id_nn not null
  constraint qwa_object_id_fk references qw_objects,
 attr varchar(100) 
  constraint qwa_attr_nn not null,
 attr_order integer,
 attr_table varchar(100),
 description varchar(100)
  constraint qwa_description_nn not null,
 default_value varchar(100),
 help_text text, 
 filters varchar(1000),
 values varchar(1000),
 length integer,
 datatype varchar(100) 
  constraint qwa_datatype_nn not null
  constraint qwa_datatype_df default 'varchar',
 constraint qwa_table_pk primary key (attr_id,object_id)
); 
