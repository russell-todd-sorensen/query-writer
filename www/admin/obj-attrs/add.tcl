ad_page_contract {

    Query Writer Add Object Attribute
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: add.tcl,v 1.3 2003/12/18 17:31:19 tom Exp $
} {
    object_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


set title "Add Object Attribute"

set context [list "$title"]

db_multirow attrs qw_object_attrs_qry "
select
 * 
from
 qw_attrs
where 
 object_id = :object_id
order by
 attr_order"

set return_url "[qw_this_url]?object_id=$object_id"
