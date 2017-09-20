ad_page_contract {

    Query Writer Add Group
    @author Russell Sorensen (russell.todd.sorensen@gmail.com)
    @creation-date 22 February 2002
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
