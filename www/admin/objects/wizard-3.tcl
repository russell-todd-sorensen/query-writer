ad_page_contract {

    Query Writer Wizard 3 Add/Choose Groups
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 21
    @revision-author Russell Sorensen <russ@semitasker.com>
} {
    object_id:notnull
} -properties {
    title:onevalue
    context:onevalue
    groups:multirow
}

set title "Object Wizard Step 3: Add/Choose Groups"

set context [list "$title"]

db_multirow groups qw_group_qry "
select
 *
from
 qw_groups
order by
 name"
