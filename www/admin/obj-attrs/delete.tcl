ad_page_contract {

    Query Writer Delete Object Attribute
    @author Russell Sorensen (russell.todd.sorensen@gmail.com)
    @creation-date 17 March 2002
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
