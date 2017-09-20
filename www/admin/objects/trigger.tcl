ns_log Notice "%%%%% INSIDE TRIGGER.TCL"

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

