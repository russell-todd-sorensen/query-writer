ad_page_contract {

    Query Writer Wizard Step 5-1: Choose Procedural Language 
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 25
    @cvs-id $Id: wizard-5-1.tcl,v 1.1 2003/07/28 21:51:21 tom Exp $
} {
    object_id:notnull
    type:array,notnull
    {new_fn:trim ""}
    {set_fn:trim ""}
    {del_fn:trim ""}

}

foreach name [array names type] {
    set value $type($name)
    set sql "
insert into 
 qw_nsv_map 
  (nsv_name,nsv_element,nsv_value)
 values
  ('qw_$name', :object_id , :value)"

    db_dml map_nsv $sql
}


set sql2 "
update
 qw_objects
set
 new_fn = :new_fn,
 set_fn = :set_fn,
 del_fn = :del_fn
where
 object_id = :object_id"

db_dml update_object $sql2


ad_returnredirect /qw/admin/objects/one?object_id=$object_id

