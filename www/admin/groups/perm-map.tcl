ad_page_contract {

    Query Writer Admin Map Group Permissions
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: perm-map.tcl,v 1.3 2003/12/18 17:30:47 tom Exp $
} {
    object_id:notnull
    {group_id:integer "1"}
} -properties {
    title:onevalue
    context_bar:onevalue
}


if {![db_0or1row object_query "
select
 *
from
 qw_objects
where
 object_id = :object_id"]} {

    ad_return_complaint 1 "Object Not found $object_id"
		return -code return
		ad_return_template "/blank.adp"
}

if {![db_0or1row group_query "
select
 group_id,
 name as group_name 
from
 qw_groups
where
 group_id = :group_id"]} {
    ad_return_complaint 1 "Group Not found $group_id"
    return -code return
    ad_return_template "/blank.adp"
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
 qw_attrs as a LEFT OUTER JOIN
 qw_group_attr_map as m using (attr_id, object_id)
where
 a.object_id = :object_id
and
(
 m.group_id != :group_id
or 
 m.group_id is null
 )
order by
 m.group_id , a.attr"


db_multirow attrs "qw_attrs_query" $sql

set title "Query Writer Map Group Permissions for $object to $group_name"

set context [list "$title"]

set return_url [ad_quotehtml "/qw/admin/objects?object_id=$object_id"]

