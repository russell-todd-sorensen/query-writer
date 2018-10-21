-- qw-objects-create.sql

-- Create Query Writer Objects Data Model
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 26 January 2002
-- @cvs-id $Id: qw-objects-create.sql,v 1.5 2002/02/07 20:44:15 nsadmin Exp $
--

create table qw_objects (
 object_id varchar(100) 
  constraint qwo_object_id_nn not null 
  constraint qwo_object_id_pk primary key,
 object varchar(100) 
  constraint qwo_object_nn not null 
  constraint qwo_object_un unique,
 obj_table varchar(30),
 key varchar(150) 
  constraint qwo_key_nn not null,
 to_eval text,
 set_perm_check varchar(256),
 del_perm_check varchar(256),
 ops varchar(100),
 -- following fields should be left blank
 -- and the table field filled in, if you
 -- want regular sql insert/update/delete code
 -- insert function
 new_fn varchar(40),
 -- update function
 set_fn varchar(40),
 -- delete function
 del_fn varchar(40),
 -- reset function
 rst_fn varchar(40),
 perm_p char(1)
  constraint qwo_perm_p_nn not null
  constraint qwo_perm_p_df default '1'
  constraint qwo_perm_p_ck check (perm_p in ('1','0'))
);



comment on column qw_objects.object is '
 The purpose of having an object_id 
and a separate object is to allow
hiding of the internal data structure 
as well as flexability in naming.
 The object_id is the string that will be used
in the naming of form variables. The object
is the actual name of the object. The object
is the same as the oracle package name, or
the beginning of the function name in postgresql.
';

comment on column qw_objects.obj_table is '
 The table column is used when regular sql 
insert/update/delete statements should be used.
This allows the query writer package to work without
pl/sql or plpgsql code. You cannot use the table field if
the package directly manipulates more than one table.
In this case, you can still fill in the table field, but
you must fill in all the four function fields as well.
';

comment on column qw_objects.to_eval is '
  Occasionally additional fields will need to be
assigned values that are composite or calculated
from other variables available in the environment.
The format of the to_eval field is a string with space
separated var eval pairs. Examples:
--
 context_id $user_id
--
 title {$name $description}
--
 price {[expr $cost * 1.2]}
--
  In each case all passed in variables for an object
will be available as well as the user_id and the 
qw_group_id. Additional variables can be accessed
by writing a tcl proc.
';

comment on column qw_objects.set_perm_check is '
  During updates, the object_id is checked
for the ''write'' privilege. Sometimes this is 
not the correct privilege to check. If some other
privilege should be checked for an object update,
this field should be checked.
  The format for the field is an var privilege
space separated list:
--
  $user_id admin
--
  Multiple checks can be performed as well.
';

comment on column qw_objects.del_perm_check is '
  During updates, the object_id is checked
for the ''admin'' privilege. Sometimes this is 
not the correct privilege to check. If some other
privilege should be checked for an object delete,
this field should be used.
  The format for the field is an var privilege
space separated list:
--
  $user_id read
--
  Multiple checks can be performed as well.
';
