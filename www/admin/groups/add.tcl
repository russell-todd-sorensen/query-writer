ad_page_contract {

    Query Writer Add Group
    @author Tom Jackson <tom@junom.com>
    @creation-date 22 February 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
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
