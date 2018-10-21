ad_page_contract {

    Query Writer Create Tcl Namespaced API for Object
    @author Tom Jackson <tom@junom.com>
    @creation-date 2003 July 21
    @cvs-id $Id: tcl-api-create.tcl,v 1.2 2003/12/18 17:31:31 tom Exp $
} {
    object_id:notnull
} -properties {
   code:onevalue
}


db_1row object_data "
select
 *
from
 qw_objects
where
 object_id = :object_id"

set keys [split $key ";"]

if {[llength $keys] > 1} {
    # require keys to be passed in
    set key_attrs [llength $keys]
} else {
    set required_attributes ""
    set key_attrs 1
}

foreach object_key $keys {
    lappend required_keys "       $object_key"
}

set required_keys [join $required_keys "\n"]

db_foreach attributes_query "
select
 *
from
 qw_attrs
where
 object_id = :object_id" {

     if {[lsearch $keys $attr] > -1} {
	 continue
     }
     if {[string match "" $default_value]} {
	 # required
	 lappend required $attr
	 append required_attributes "       $attr\n"
     } else {
	 if {[string match "null" $default_value]} {
	     set default_value ""
         }
	 lappend optional $attr
	 append optional_attributes "       \{ -$attr \"$default_value\" \}\n"
     }
     append set_attributes "       \{ -$attr \"\" \}\n"

 }

ad_return_template
