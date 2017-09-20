proc qw_table_data { tableName listVar } {

    upvar $listVar LIST
    if {![db_0or1row table_data "
select
 c.oid as table_oid,
 c.relfilenode as relfilenode
from
 pg_class c
where
 c.relname = :tableName"]} {
	set LIST [list]
	return "0"
    } else {
	lappend LIST $table_oid $relfilenode
	return "$table_oid"
    }
}  


