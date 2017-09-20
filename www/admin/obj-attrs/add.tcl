ad_page_contract {

    Query Writer Add Object Attribute
    @author Russell Sorensen (russell.todd.sorensen@gmail.com)
    @creation-date 21 February 2002
} {
    object_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


set title "Add Object Attribute"

set context [list "$title"]

db_multirow attrs qw_object_attrs_qry "
select
 *
from
 qw_attrs
where
 object_id = :object_id
order by
 attr_order"

set return_url "[qw_this_url]?object_id=$object_id"
