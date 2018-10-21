ad_page_contract {

    Query Writer Wizard Step 4: Map Group Permissions
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: wizard-4.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {
    object_id:notnull
    group:array,notnull
} -properties {
    title:onevalue
    context:onevalue
}

set group_list [array names group]
set groups [list] 

db_foreach group_query "
select
 *
from 
 qw_groups
where
 group_id in ([join $group_list ,])" {

     lappend groups $name

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


set primary_keys [split $key ";"]


set sql "
select
 a.attr_id,
 a.object_id,
 a.attr,
 a.default_value
from
 qw_attrs as a
where
 a.object_id = :object_id
order by
 a.attr"

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
order by
 a.attr_order"


db_multirow -extend {
    admin_ops
} attrs "qw_attrs_query" $sql {


    set acs_objects_attrs [list "object_id" "object_type" \
				   "creation_date" "creation_user" \
				   "creation_ip" "context_id" \
				   "security_inherit_p" "last_modified" \
				   "modifying_user" "modifying_ip"]

    ns_log Notice "Ops default...."
    if {[lsearch "$primary_keys" "$attr"] > -1 } {
	ns_log Notice "Ops on primary key $attr"
	set ops "new;del"
	
    } elseif {[lsearch $acs_objects_attrs $attr] == -1} {
	
	set ops "new;set"
    }
    
    # admin = default for object
    set admin_ops $ops
    
    # attrs in acs_objects table, usually
    switch -exact -- [string tolower "$attr"] {
	"object_type" {
	    set admin_ops "new;set"
	    set ops "new"
	}
	"creation_date" - "creation_user" - "creation_ip" {
	    set admin_ops "new;set"
	    set ops "new"
	}
	"context_id" - "security_inherit_p" {
	    set admin_ops "new;set"
	    set ops "new;set"
	}
	"last_modified" - "modifying_user" - "modifying_ip" {
	    set admin_ops "set"
	    set ops ""
	}
    }

}


set title "Object Wizard Step 4: Map Group Permissions for $object"

set context [list "$title"]

set return_url [ad_quotehtml "/qw/admin/objects/wizard-5?object_id=$object_id"]

