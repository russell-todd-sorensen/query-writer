ad_page_contract {

    Query Writer Admin Dump All Data
    @author Russell Sorensen (russell.todd.sorensen@gmail.com)
    @creation-date 27 February 2002
} {
    {prefix:trim ""}
} -properties {
    title:onevalue
    context:onevalue
}

# this proc looks messed up.
proc escapeTcl { string } {

    set open_bracket {\[}
    set close_bracket {\]}
    set quote {\"}
    set backslash {\\}
    set dollar {\$}

    regsub -all $open_bracket $string $open_bracket string
    regsub -all $close_bracket $string $close_bracket string
    regsub -all $quote $string $quote string
    regsub -all $dollar $string $dollar string
    return $string

}

global object_id_list

set title "Query Writer Dump All Data"

set context [list "$title"]

set object_id_list [list]
set data ""

db_foreach groups_query "
select
 distinct(group_id)
from
 qw_group_attr_map
where
 object_id
in
 (select
   object_id
  from
   qw_objects
  where
   obj_table like '${prefix}%'
 )" {

    db_1row qroup_data_query "
select
 *
from
 qw_groups
where
 group_id = :group_id"

		append data "catch {db_dml insert_group \"insert into qw_groups (group_id, name) values (
'$group_id','[DoubleApos $name]')\" } \n"


 }

db_foreach objects_query "
select
 *
from
 qw_objects
where
 obj_table like '${prefix}%'" {

   append data "db_dml insert_qw_object \"insert into qw_objects (object_id,object,obj_table,key,
to_eval,set_perm_check,del_perm_check,ops,new_fn,set_fn,del_fn,rst_fn,
perm_p) values ('$object_id','$object','$obj_table','$key',
'[escapeTcl [DoubleApos $to_eval]]','$set_perm_check','$del_perm_check','$ops','$new_fn','$set_fn','$del_fn','$rst_fn',
'$perm_p')\"\n"


   db_foreach attr_query "
select
 *
from
 qw_attrs
where
 object_id = :object_id" {

     append data "db_dml insert_object_attr \"insert into qw_attrs (attr_id,object_id,attr,
description,default_value,help_text,filters,values,length,datatype) values (
'$attr_id','$object_id','$attr',
'[DoubleApos $description]','[DoubleApos $default_value]',
'[DoubleApos $help_text]','[DoubleApos $filters]',
'[DoubleApos $values]','$length','$datatype')\"\n"



   }
   global object_id_list
   lappend object_id_list $object_id

 }

ns_log Notice "OOOobject_id_list: $object_id_list"

foreach object_id $object_id_list {
   db_foreach fn_query "
select
 *
from
 qw_fns
where
 object_id = :object_id" {

		 append data "
set fn_id \[db_string fn_nextval \"select nextval('qw_fn_sequence')\"]

db_dml insert_qw_fn \"insert into qw_fns (fn_id,object_id,type,
name,description,joiner,active_p) values ('\$fn_id','$object_id',
'$type',
'[DoubleApos $name]','[DoubleApos $description]','$joiner',
'$active_p')\"\n"

       db_foreach fn_attr_query "
select
 *
from
 qw_fn_attrs
where
 fn_id = :fn_id" {

       append data "db_dml insert_fn_attr \"insert into qw_fn_attrs (attr,fn_id,
default_value, attr_order) values ('$attr','\$fn_id',
'[DoubleApos $default_value]','$attr_order')\"\n"


        }
       }

    # Map some group_privs
    db_foreach group_attr_map_query "
select
 *
from
 qw_group_attr_map
where
object_id = :object_id" {

    append data "db_dml  insert_qroup_attr_mapping \"insert into qw_group_attr_map
(group_id,object_id,attr_id,values,ops) values ('$group_id','$object_id','$attr_id',
'[DoubleApos $values]','$ops')\"\n"

    }
}

foreach object_id $object_id_list {

    db_foreach nsv_query "
select
 *
from
 qw_nsv_map
where
 nsv_element = :object_id" {
     append data "db_dml nsv_map \"insert into qw_nsv_map (nsv_name, nsv_element, nsv_value)
values
 ('[DoubleApos $nsv_name]','[DoubleApos $nsv_element]','[DoubleApos $nsv_value]')\"\n"

 }

}

if {[string match "qw_" $prefix]} {

    # write file to disk
    set filename "[acs_package_root_dir query-writer]/tcl/query-writer-bootstrap.tcl.data"
    set file [open $filename w]
    catch {puts $file "\# cvs-id: \$Id\$ "}
    catch {puts $file $data}
    close $file
    ns_log Notice "query-writer/www/admin/dump/dump-all: dumped qw_ data. to '$filename'"
}
