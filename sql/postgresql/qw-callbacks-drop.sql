-- qw-callbacks-drop.sql

-- Callbacks Datamodel Drop script
--
-- @author Tom Jackson (tom@junom.com)
-- @creation-date 15 October 2003
-- @cvs-id $Id: qw-callbacks-drop.sql,v 1.1 2003/11/07 07:01:04 tom Exp $
--


drop sequence qw_callback_seq;

drop table qw_callbacks;

drop table qw_callback_points;

drop table qw_callback_types;

drop table qw_operations;
