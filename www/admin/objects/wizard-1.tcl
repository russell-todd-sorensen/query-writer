ad_page_contract {

    Query Writer Add Object
    @author Tom Jackson <tom@junom.com>
    @creation-date 20 February 2002
    @cvs-id $Id: wizard-1.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {

} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


set title "Object Wizard Step 1: Create Object"

set context [list "$title"]


ad_return_template
