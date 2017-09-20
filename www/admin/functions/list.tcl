ad_page_contract {

    Query Writer Add Object Function
    @author Russell Sorensen (russell.todd.sorensen@gmail.com)
    @creation-date 22 February 2002
} {

} -properties {
    title:onevalue
    context:onevalue
    functions:multirow
}


set title "List Functions"
set context [list "$title"]

db_multirow functions qw_obj_functions_qry "
select
 qo.*,
 qwf.*,
 ft.name as type_name,
 ft.description as type_description
from
 qw_objects qo,
 qw_fns qwf,
 qw_fn_types ft
where
 qo.object_id = qwf.object_id
and
 qwf.type = ft.type
order by
 qwf.object_id,
 qwf.name"


ad_return_template
