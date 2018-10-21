ad_page_contract {

    Query Writer Edit Object Attribute
    @author Tom Jackson <tom@junom.com>
    @creation-date 22 February 2002
    @cvs-id $Id: edit.tcl,v 1.2 2003/12/18 17:31:19 tom Exp $
} {
    object_id:trim,notnull
    attr_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
}


set title "Add Object Attribute"

set context [list "$title"]

if {![db_0or1row qw_attr_query "
select
 * 
from
 qw_attrs
where 
 object_id = :object_id
and
 attr_id = :attr_id"] } {
    ad_return_complaint 1 "Attribute $attr_id for object $object_id not found."
}



