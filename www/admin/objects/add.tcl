ad_page_contract {

    Query Writer Add Object
    @author Tom Jackson <tom@junom.com>
    @creation-date 20 February 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
} {

} -properties {
    title:onevalue
    context_bar:onevalue
    objects:multirow
}


set title "Add Object"

set context [list "$title"]

db_multirow objects qw_object_qry "
select
 *
from
 qw_objects
order by
 object"

ad_return_template
