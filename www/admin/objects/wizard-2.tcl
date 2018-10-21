ad_page_contract {

    Query Writer Add Attributes Page 1
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 21
    @cvs-id $Id: wizard-2.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {
    object_id:trim,notnull
}

set title "Object Wizard Step 2: Add Attributes"
set context [list "$title"]

# get starting table name, object from object_id

db_1row table_info "select obj_table as table, object, key as id_column_name from qw_objects where object_id = :object_id"

set this_table $table
append tables "$this_table "

set required_attributes 0

proc qw_parent_table {table_name id_column_name} {
    
    set result_list [list]
    
    db_multirow key_columns "key_columns_query" "
select 
 constraint_name,
 ordinal_position
from 
 information_schema.key_column_usage
where
 table_name = :table_name
and
 column_name = :id_column_name" {
 
        ns_log Notice "constraint_name = '$constraint_name"

        if {[db_0or1row ref_constraint "
select
 unique_constraint_name
from 
 information_schema.referential_constraints
where
 constraint_name = :constraint_name"]} {
            ns_log Notice "%%% unique_constraint_name = '$unique_constraint_name'"
            if {[db_0or1row ref_constraint2 "select 
 table_name,
 column_name
from
 information_schema.constraint_column_usage
where
 constraint_name = :unique_constraint_name
     limit 1"]} {
                ns_log Notice "table_name='$table_name' column_name='$column_name'"
               set result_list [list $table_name $column_name]
            }
        }
  
    }
    return $result_list
}

set available_filters [lsort [string map {ad_page_contract_filter_proc_ ""} [info commands ad_page_contract_filter_proc_*]]]
ns_log Notice "Available filters $available_filters"

while {1} {
    ns_log Notice "@@@@@@@@@@-- STARTING "
    set tableData [list]

    db_multirow  -append -extend {
        exclude
        filters
    } attributes  "attribute_query_2" "
select
 table_name as table_name,
 column_name as attname,
 ordinal_position as attnum,
 data_type as typname,
 character_maximum_length as length,
 case 
  when column_default is null then 'f'
  else 't'
 end
 as atthasdef,
 case 
  when is_nullable = 'NO' then 't'
  else 'f'
 end 
 as attnotnull,
 column_default as \"default\"
 from 
  information_schema.columns
 where
  table_name = :this_table
" {
    set table_name $this_table
    
	ns_log Notice "@@@@@ table_name= '$this_table', attribute = '$attname' @@@"
	
    set excluded_attributes [list "tree_sortkey" "object_id"]
    
    if {[string match "acs_objects" $table_name] && [lsearch $excluded_attributes $attname] > -1 } {
    	set exclude "1"
    } else {
    	set exclude "0"
    }
    
    if {[string match "acs_objects" $table_name] && [string match "object_type" $attname] } {
    	set default "'$object'"
    }
    
    if {[string match "int*" $typname]} {
    	set filters "integer"

    } else {
    	set filters ""
    }
    
    if {[string match "f" $attnotnull ] && [string match "f" $atthasdef]} {
    	set default "null"
	
    } else {
    	incr required_attributes
    }
}
    ns_log Notice "@@@ this_table = '$this_table', table_name = '$table_name'"

    #source {C:\naviserver\servers\openacs\packages\query-writer\www\admin\objects\trigger.tcl}

    lappend primary_keys $id_column_name
    set parent_table_data [qw_parent_table $this_table $id_column_name]
    
    if {[llength $parent_table_data] ne 2} {
        ns_log Notice "@@@@--@@ No Parent Table Data Found"
        break
    }
    
    set parent_table [lindex $parent_table_data 0]
    set parent_id_column_name [lindex $parent_table_data 1]
    

    set this_table $parent_table
    append tables "$this_table "

}


ad_return_template


