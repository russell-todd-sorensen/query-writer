ad_page_contract {

    Query Writer Delete Object Attribute
    @author Tom Jackson <tom@junom.com>
    @creation-date 17 March 2002
    @cvs-id $Id: delete.tcl,v 1.1 2002/03/19 04:21:33 nsadmin Exp $
} {
    object_id:trim,notnull
    attr_id:trim,notnull
} 



db_dml delete_object_attribute "
delete from
 qw_attrs
where
 object_id = :object_id
and
 attr_id = :attr_id"


ad_returnredirect "add?object_id=$object_id"

