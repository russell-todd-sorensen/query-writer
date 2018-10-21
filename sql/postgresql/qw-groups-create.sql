-- qw-groups-create.sql

-- Create Query Writer Groups Data Model
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 28 January 2002
-- @cvs-id $Id: qw-groups-create.sql,v 1.5 2003/11/07 07:01:04 tom Exp $
--

-- at first glance this datamodel sucks
-- name corresponds to a relational segment name and this column
-- is unique. So this name alone could be used to select the group_id
-- The tcl proc qw_get_group_id uses the rel_type in addition to
-- ensure that there are not duplicate relational segments. This column is
-- not unique in rel_segments, so using two columns forces a little more
-- integrety than would otherwise exist. But note the situation is not ideal.
-- the rel_type column here is also use to help create a rel_type and a rel_segment
-- during installation.

create table qw_groups (
  group_id integer
   constraint qwg_group_id_nn not null
   constraint qwg_group_id_pk primary key,
  -- name is going to correspond to a rel_segment.segment_name
  name varchar(100) 
   constraint qwg_name_nn not null
   constraint qwg_name_un unique,
  rel_type varchar(100) 
   constraint qwg_rel_type_nn not null
   constraint qwg_rel_type_df default 'membership_rel',
  constraint qwg_name_rel_type_un unique (name, rel_type)
);

comment on table qw_groups is '
  A query writer group is the main security mechanism
that allows or denies a given user the right to use the
query writer. A separate function or tcl procedure will
be used to place users into a single group. A simple 
implimentation of this procedure would be to place 
users with admin priviliges into an admin group, and
to place all other users into a default group. Users will
never see this group_id, and it will never be passed around
in form variables. The group will also determine which UI 
components to display, if UI switches are used. A UI switch
name can be determined from an object_id.attr_id.value name.
For product.state.0, the UI switch product_state_0_p would
be set to either 0 or 1.
';

create table qw_group_attr_map (
 group_id integer 
  constraint gam_group_id_nn not null
  constraint gam_group_id_fk references qw_groups,
 object_id varchar(100)
  constraint gam_object_id_nn not null,
 attr_id varchar(100) 
  constraint gam_attr_id_nn not null,
 values varchar(1000),
 ops varchar(100),
 constraint gam_table_pk primary key (group_id,object_id,attr_id)
);


-- insert the default groups

insert into qw_groups
 values (1,'QW Admin','membership_rel');
insert into qw_groups 
 values (2,'Main Site Members','membership_rel');
