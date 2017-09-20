ad_page_contract {

    Query Writer Delete Function Attribute
    @author Russell Sorensen (russell.todd.sorensen@gmail.com)
    @creation-date 23 February 2002
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

ad_returnredirect "add?fn_id=$fn_id"
