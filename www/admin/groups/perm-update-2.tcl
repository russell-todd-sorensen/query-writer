ad_page_contract {

    Query Writer Admin Update Group Permissions Page 2
    @author Tom Jackson <tom@junom.com>
    @creation-date 25 March 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
} {
    object_id:notnull,trim
    group_id:notnull,integer
    attr_id:notnull,trim
    {ops:trim "new;set;del"}
    {return_url:trim ""}
    {values:trim ""}
} -properties {
    title:onevalue
    context_bar:onevalue
}

set dml "
update
 qw_group_attr_map
set
 ops = :ops,
 values = :values
where
 group_id = :group_id
and
 object_id = :object_id
and
 attr_id = :attr_id"


if {[string match "" $return_url]} {

    set return_url "perm-update?object_id=$object_id&group_id=$group_id"
}


db_dml "update_group_attr_map" $dml


ad_returnredirect $return_url
