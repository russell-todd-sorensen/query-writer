ad_page_contract {

    Query Writer Edit Object Attribute Page 2
    @author Tom Jackson <tom@junom.com>
    @creation-date 22 February 2002
    @cvs-id $Id: edit-2.tcl,v 1.2 2002/03/17 01:19:29 nsadmin Exp $
} {

    object_id:trim,notnull
    attr_id:trim,notnull
    attr:trim,notnull
    datatype:trim,notnull
    {filters:trim ""}
    {values:trim ""}
    {default_value:trim ""}
    {length:trim ""}
    {description:trim ""}
    {help_text:trim ""}

} 

set sql "
update
 qw_attrs
set
 attr = :attr,
 description = :description,
 default_value = :default_value,
 help_text = :help_text,
 filters = :filters,
 values = :values,
 length = :length,
 datatype = :datatype
where
 object_id = :object_id
and
 attr_id = :attr_id"

db_dml "update_object_attr" $sql

ad_returnredirect "add?object_id=$object_id"