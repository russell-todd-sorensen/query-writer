proc qw_trigger_data { relfilenode argList } {

    upvar $argList ARGS
    if {![db_0or1row first_trigger_query "
select 
 trig.tgargs
from
 pg_trigger trig
where
 trig.tgtype = 21 and 
 trig.tgrelid = :relfilenode
limit 1 "]} {
        set ARGS [list]
        return "0"
    }
    set index 0
    set count 1
    set ARGS [list]
    set nextbreak [string first {\000} $tgargs $index]
    while {$nextbreak > -1} {
        
        lappend ARGS [string range $tgargs $index [expr $nextbreak -1]]
        set index [expr $nextbreak + 4]
        set nextbreak [string first {\000} $tgargs $index]
        incr count
    }
    return "1"
}
