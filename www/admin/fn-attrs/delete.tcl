ad_page_contract {

    Query Writer Delete Function Attribute
    @author Tom Jackson <tom@junom.com>
    @creation-date 23 February 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
} {
    fn_id:trim,notnull
    attr:trim,notnull
}

set dml "
delete from
 qw_fn_attrs
where
 fn_id = :fn_id
and
 attr = :attr"

db_dml "delete_fn_attr_dml" $dml

#ad_returnredirect "add?fn_id=$fn_id"
ns_returnredirect "add?fn_id=$fn_id"
