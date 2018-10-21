ad_page_contract {

    Query Writer Add Object Attribute Page 2
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: add-2.tcl,v 1.3 2003/12/18 17:31:19 tom Exp $
} {

    object_id:trim,notnull
    attr_id:trim,notnull
    attr:trim,notnull
    datatype:trim,notnull
    attr_table:trim,notnull
    attr_order:integer,trim,notnull
    {filters:trim ""}
    {values:trim ""}
    {default_value:trim ""}
    {length:trim ""}
    {description:trim ""}
    {help_text:trim ""}

} 


set sql "
insert into
 qw_attrs
 (
 attr_id,
 object_id,
 attr,
 attr_order,
 attr_table,
 description,
 default_value,
 help_text,
 filters,
 values,
 length,
 datatype
 )
values 
 (
 :attr_id,
 :object_id,
 :attr,
 :attr_order,
 :attr_table,
 :description,
 :default_value,
 :help_text,
 :filters,
 :values,
 :length,
 :datatype
) "

db_dml "insert_object_attr" $sql

ad_returnredirect "add?object_id=$object_id"
