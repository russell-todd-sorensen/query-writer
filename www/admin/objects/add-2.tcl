ad_page_contract {

    Query Writer Add Object Page 2
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: add-2.tcl,v 1.1 2002/02/22 09:26:53 nsadmin Exp $
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

ad_returnredirect add


