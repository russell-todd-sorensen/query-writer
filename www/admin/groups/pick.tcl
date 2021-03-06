ad_page_contract {

    Query Writer Admin Pick Group
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
} {
    object_id:trim,notnull
    final_form:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    final_form:onevalue
    groups:multirow
}


set title "Query Writer Pick Group"

set context [list "$title"]


db_multirow groups group_query "
select
 group_id,
 name
from
 qw_groups
order by
 name"


set form_vars [export_form_vars object_id]
