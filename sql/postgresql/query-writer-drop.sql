-- query-writer-drop.sql

-- Drop Query Writer Data Model
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 17 March 2002
-- @cvs-id $Id: query-writer-drop.sql,v 1.1 2002/03/18 03:15:30 nsadmin Exp $
--

drop table qw_fn_attrs;
drop table qw_fns;
drop sequence qw_fn_sequence;
drop table qw_fn_types;

drop table qw_nsv_map;

drop table qw_group_attr_map;
drop table qw_groups;

drop table qw_attrs;

drop table qw_objects;