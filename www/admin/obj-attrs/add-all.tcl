ad_page_contract {
    Query Writer Bulk Add Attributes
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 17
    @cvs-id $Id: add-all.tcl,v 1.1 2003/07/28 21:49:35 tom Exp $
   
} {

    object_id:trim,notnull
} -properties {
    triggers:multirow
}


# get table name from object

set table [db_string table_name "select obj_table from qw_objects where object_id = :object_id"]


if {![empty_string_p $table]} {
    set table_oid [db_string table_oid_qry "select oid from pg_class where relname = :table"]
}

set parent_table $table
append tables "$parent_table "
set required_attributes 0
while {1} {

    if {![db_0or1row first_trigger_query "
select 
 class.oid as table_oid,
 trig.tgargs
from
 pg_class class,
 pg_trigger trig
where
 class.relname = :parent_table and
 trig.tgtype = 21 and 
 class.relfilenode = trig.tgrelid
limit 1 "]} {
        break
    }
    set index 0
    set count 1
    set args [list]
    set nextbreak [string first {\000} $tgargs $index]
    while {$nextbreak > -1} {
        
        lappend args [string range $tgargs $index [expr $nextbreak -1]]
        set index [expr $nextbreak + 4]
        set nextbreak [string first {\000} $tgargs $index]
        incr count
    }
    
    set table_name $table
    set trigger_name [lindex $args 0]
    set from_table [lindex $args 1]
    set ref_table [lindex $args 2]
    set from_attr [lindex $args 4]
    set ref_attr [lindex $args 5]  


    db_multirow  -append -extend { 
        default
        table_name
    } attributes  "attribute_query_2" "
select
 att.attname,
 att.attnum,
 typ.typname,
 (att.atttypmod - 4) as length,
 att.attnotnull,
 att.atthasdef
from
 pg_attribute att,
 pg_type typ
where
 att.attrelid = :table_oid and
 att.attnum > 0 and
 att.atttypid = typ.oid 
order by att.attnum
" {
   set table_name $parent_table
   set default ""
   if {[string match "t" $atthasdef]} {
       set default [db_string adsrc_query "
select 
 adsrc 
from 
 pg_attrdef 
where
 adrelid = :table_oid
and
 adnum = :attnum"]
    }  
      if {[string match "f" $attnotnull ] && [string match "f" $atthasdef]} {
          incr required_attributes
      }

    }
    ns_log Notice "ft: $from_table, rt: $ref_table, fa: $from_attr, ra: $ref_attr"
    if {[string match "$from_table" "$ref_table"] } {
 	break
    }
    if {[string match "acs_objects" $parent_table]} {
        break
    }

    set parent_table $ref_table
    append tables "$parent_table "

}
