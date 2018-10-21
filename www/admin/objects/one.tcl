ad_page_contract {

    Query Writer One Object
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: one.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {
    object_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


if {![db_0or1row qw_object_qry "
select
 * 
from
 qw_objects
where
 object_id = :object_id" ]} {
    ad_return complaint 1 "Object $object_id not found"
}


set title "One Object: $object"

set context [list "$title"]

ad_return_template
