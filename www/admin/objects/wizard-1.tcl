ad_page_contract {

    Query Writer Add Object
    @author Tom Jackson <tom@junom.com>
    @creation-date 20 February 2002
} {

} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


set title "Object Wizard Step 1: Create Object"

set context [list "$title"]


ad_return_template
