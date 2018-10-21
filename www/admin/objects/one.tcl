ad_page_contract {

    Query Writer One Object
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
} {
    object_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


if {![db_0or1row qw_object_qry "
select
 *
from
 qw_objects
where
 object_id = :object_id" ]} {
    ad_return complaint 1 "Object $object_id not found"
}


set title "One Object: $object"

set context [list "$title"]

ad_return_template
