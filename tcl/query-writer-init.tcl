# @file: query-writer-init.tcl
# @author: Tom Jackson <tom@junom.com>
# @creation-date: 7 February 2002
# @cvs-id: $Id: query-writer-init.tcl,v 1.11 2003/11/07 06:58:43 tom Exp $

# load qw bootstrap data if the qw tables are empty.

set rowcount [db_string count_rows_query "
select
 count(*) as rowcount
from
 qw_objects"]

if {[string match "0" $rowcount]} {
    
    ns_log Notice "Loading Query Writer Bootstrap Data..."
    source "[acs_package_root_dir query-writer]/tcl/query-writer-bootstrap.tcl.data"
    ns_log Notice "Done loading Query Writer Bootstrap Data."
}

db_foreach qw_group_attr_map_qry "
select
 group_id,
 object_id,
 attr_id,
 values,
 ops
from
 qw_group_attr_map
order by
 group_id,object_id,attr_id" {

      qw_attr_perm_map $group_id $object_id $attr_id $values $ops 
 
 } 

## MAP IDS TO OBJECTS AND ATTRS ##

db_foreach map_id_to_attr_qry "    
select    
 object_id,   
 attr_id, 
 attr 
from 
 qw_attrs 
order by object_id " {   
    qw_map_id_to_attr $object_id $attr_id $attr
   
}  
  
 
db_foreach map_id_to_object_qry "    
select    
 object_id,    
 object 
from  
 qw_objects " {   
  
    qw_map_id_to_object $object_id $object
  
} 


## MAP FILTERS AND ATTR DATATYPE#

db_foreach qw_attr_filters_qry "
select
 object_id,
 attr_id,
 filters,
 datatype
from
 qw_attrs " {

     qw_map_filter $object_id $attr_id $filters
     qw_map_datatype $object_id $attr_id $datatype
 
 }

###### MAP OBJECT PROPERTIES #########

db_foreach object_properties_qry "
select
 object_id 
from
 qw_objects " {

    qw_map_obj_properties $object_id 


 }


## OBJECT PROCEDURES ##


db_foreach qw_nsv_map_qry "
select
 nsv_name,
 nsv_element,
 nsv_value
from
 qw_nsv_map " {

    qw_map_nsv $nsv_name $nsv_element $nsv_value
 


 }

# ATTR LENGTH #

db_foreach qw_length_qry "
select
 object_id,
 attr_id,
 length
from
 qw_attrs
where
 length is not null and
-- length != '' and
 length > 0 " {

    qw_map_attr_length $object_id $attr_id $length
  
}

# ATTR DESCRIPTION AND HELP TEXT #

db_foreach qw_attr_desc_help_qry "
select
 object_id,
 attr_id,
 description,
 help_text
from
 qw_attrs" {

    qw_map_attr_txt $object_id $attr_id "$description" "$help_text"
 

 }

# Load function defs:

qw_write_obj_functions

# Init callbacks

qw::init::callbacks

# Filters 

ad_page_contract_filter write_permission {name value} { 

 <p>Checks if the current user has write permission on the object. 

} {
    ns_log Notice "Checking permission for [ad_conn user_id] to write $value"
    if { ![ad_permission_p $value write] } {
        ad_complain "You do not have permission to use $name"
        return 0
    } else {
        return 1
    }
    
}
ad_page_contract_filter read_permission {name value} { 

 <p>Checks if the current user has read permission on the object. 

} {
    ns_log Notice "Checking permission for [ad_conn user_id] to read $value"
    if { ![ad_permission_p $value read] } {
        ad_complain "You do not have permission to use $name"
        return 0
    } else {
        return 1
    }
    
}

