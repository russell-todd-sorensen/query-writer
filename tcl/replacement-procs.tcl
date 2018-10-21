ad_library {

    Replacement procs for Query Writer
    @author Tom Jackson (tom@rmadilo.com)
    @creation-date 2003 October 12
    @cvs-id $Id: replacement-procs.tcl,v 1.1 2003/11/07 06:59:26 tom Exp $

}



ad_proc qw_get_group_id { 

    {-group ""}

} {

    Pick a unique group id for query writer

    A group id is a grouping of object attributes
    and associated operations. When using the query
    writer url api a single group is used to validate
    the request. This procedure will validate the user
    for a passed in group_id if present. Otherwise validate
    the user as an admin. If this fails, use the default
    group.
} {

    set user_id [ad_conn user_id]
    if {[string equal "" $group]} {

        if {[::permission::permission_p \
            -object_id [acs_magic_object "security_context_root"] \
            -party_id $user_id \
            -privilege "admin"]
        } {
            # use admin group
            return 1
        } else {
            # use default group if valid
            set sql "
select
 count(*) as segment_count
from
 rel_segments rs,
 party_approved_member_map m
where
 rs.segment_id = m.party_id
and
 rs.segment_name = 'Main Site Members'
and
 rs.rel_type = 'membership_rel'
and
 m.member_id = :user_id"

	        if {[db_string count_segments $sql]} {
	            return 2
	        } else {
	            return 0
	        }
	    } 

    }
    
    set sql "
select
 rel_type
from
 rel_segments rs,
 party_approved_member_map m
where
 rs.segment_id = m.party_id
and
 rs.segment_name = :group
and
 m.member_id = :user_id"

    if {[db_0or1row rel_type $sql]} {
	
        if {[nsv_exists "qw_($group)" $rel_type]} {
            return [nsv_get "qw_($group)" $rel_type]
        } else {
            return 0
        }
	
    } else {
        return 0
    }
} 


