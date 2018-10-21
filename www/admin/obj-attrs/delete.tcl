ad_page_contract {

    Query Writer Delete Object Attribute
    @author Tom Jackson <tom@junom.com>
    @creation-date 17 March 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
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
