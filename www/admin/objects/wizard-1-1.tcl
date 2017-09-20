ad_page_contract {

    Query Writer Add Object Page 2
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 20
    @cvs-id $Id: wizard-1-1.tcl,v 1.1 2003/07/28 21:51:21 tom Exp $
} {
    object:trim,notnull
    object_id:trim,notnull
    {obj_table:trim ""}
    {key:trim ""}
    {to_eval:trim ""}
    {set_perm_check:trim ""}
    {del_perm_check:trim ""}
    {ops:trim ""}
    {new_fn:trim ""}
    {set_fn:trim ""}
    {del_fn:trim ""}
    {rst_fn:trim ""}
    {perm_p:trim "1"}
} 


foreach var [list new_fn set_fn del_fn rst_fn] {
 
    if {[string match "__*" [set $var]]} {
	set "$var" "${object}[set $var]"
    }
}

set sql "
insert into
 qw_objects 
(
 object_id,
 object,
 obj_table,
 key,
 to_eval,
 set_perm_check,
 del_perm_check,
 ops,
 new_fn,
 set_fn,
 del_fn,
 rst_fn,
 perm_p
)
values 
( 
 :object_id, 
 :object,
 :obj_table,
 :key,
 :to_eval,
 :set_perm_check,
 :del_perm_check,
 :ops,
 :new_fn,
 :set_fn,
 :del_fn,
 :rst_fn,
 :perm_p
 )"


db_dml "insert_object_dml" $sql


ad_returnredirect wizard-2?object_id=$object_id
