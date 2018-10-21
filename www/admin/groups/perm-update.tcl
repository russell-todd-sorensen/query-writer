ad_page_contract {

    Query Writer Admin Update Group Permissions
    @author Tom Jackson <tom@junom.com>
    @creation-date 25 March 2002
    @cvs-id $Id: perm-update.tcl,v 1.2 2003/12/18 17:30:47 tom Exp $
} {
    object_id:notnull
    {group_id:integer "1"}
} -properties {
    title:onevalue
    context:onevalue
}



set sql "
select
 a.attr_id,
 a.object_id,
 a.attr,
 a.default_value,
 m.values as values,
 m.group_id as group_id,
 m.ops as ops
from
 qw_attrs a,
 qw_group_attr_map m
where
 m.object_id = :object_id
and
 a.attr_id = m.attr_id
and
 a.object_id = m.object_id 
order by
 m.group_id , a.attr"

db_multirow perms object_perms_query $sql


set title "Query Writer Update Group Permissions for $object_id "

set context [list "$title"]

set return_url  "/qw/admin/objects/one?object_id=$object_id"

