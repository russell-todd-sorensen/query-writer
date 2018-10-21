ad_page_contract {

    Query Writer Wizard Step 5: Choose Procedural Language
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 25
    @cvs-id $Id: wizard-5.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {
    object_id:notnull
} -properties {
    title:onevalue
    context:onevalue
}


set title "Object Wizard Step 5: Choose Procedural Language"

set context [list "$title"]

db_1row object_data "
select
 *
from
 qw_objects
where
 object_id = :object_id"

set return_url [ad_quotehtml /qw/admin/objects/one?object_id=$object_id]


ad_return_template
