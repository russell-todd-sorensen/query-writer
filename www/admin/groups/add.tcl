ad_page_contract {

    Query Writer Add Group
    @author Tom Jackson <tom@junom.com>
    @creation-date 22 February 2002
    @cvs-id $Id: add.tcl,v 1.3 2003/12/18 17:30:47 tom Exp $
} {

} -properties {
    title:onevalue
    context_bar:onevalue
    groups:multirow
}


set title "Add Group"

set context [list $title]

db_multirow groups qw_group_qry "
select
 * 
from
 qw_groups
order by
 name"
