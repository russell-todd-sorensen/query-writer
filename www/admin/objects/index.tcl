ad_page_contract {

    Query Writer Admin Object Index
    @author Tom Jackson <tom@junom.com>
    @creation-date 20 February 2002
    @cvs-id $Id: index.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {

} -properties {
    title:onevalue
    context:onevalue
}

set title "Objects"

set context  [list "$title"]

ad_return_template
