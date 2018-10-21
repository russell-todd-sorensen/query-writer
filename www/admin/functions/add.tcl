ad_page_contract {

    Query Writer Add Object Function
    @author Tom Jackson <tom@junom.com>
    @creation-date 22 February 2002
    @cvs-id $Id: add.tcl,v 1.5 2003/12/18 17:30:37 tom Exp $
} {
    object_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    functions:multirow
}

if {![db_0or1row object_qry "
select
 *
from
 qw_objects
where
 object_id = :object_id"]} {

    ad_return_complaint 1 "Object $object_id not found"

} 

db_multirow types qw_fn_type_qry "
select
 type,
 name,
 description
from
 qw_fn_types
order by
 type"

db_multirow functions qw_obj_functions_qry "
select
 qwf.*,
 ft.name as type_name,
 ft.description as type_description 
from
 qw_fns qwf,
 qw_fn_types ft
where
 object_id = :object_id
and
 qwf.type = ft.type
order by
 qwf.object_id,
 qwf.name"


set title "Add Function for $object"

set context [list "$title"]

ad_return_template
