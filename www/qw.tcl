ad_page_contract {

    Query Writer
    @author Tom Jackson <tom@junom.com>
    @creation-date 29 January 2002
    @revision-author Russell Sorensen <russ@semitasker.com>
} {
    new:array,trim,optional,allhtml
    set:array,trim,optional,allhtml
    del:array,optional
    {return_url:trim "/"}
} -properties {
    output:onevalue
}

ns_log Notice "Running QW!!!"

global output
global qw_last_new_object_id

set output ""
set qw_last_new_object_id ""

# get the user_id
set user_id [ad_conn user_id]

# get qw group_id
if {![set qw_group_id [qw_get_group_id]]} {
    ad_return_complaint "1" "QW Security Group Violation for '$user_id'"
    ad_script_abort
}

ns_log Notice "*** QW Past qw_group_id = '$qw_group_id'"

# list of work to do:
set work_list [list]

# Begin with del
set del_names [array names del]

foreach name $del_names {
    # split the array name at dot
    # to divide into object and id.
    set dl [split $name "."]
    set o [lindex $dl 0]
    set id [lindex $dl 1]

    # check ability of user to admin object
    # this should change to del_perm?
    if {[nsv_get qw_obj_perm $o]} {
      if {![ad_permission_p -user_id $user_id $id "admin"]} {
        ad_complain "You do not have permission to delete object $o with id $id"
        continue
      }
    }
    # check qw right to del object type
    # ops.x.del(object) must exist, where x is qw_group_id
    if {![qw_if_exists qw_ops.${qw_group_id}.del $o]} {
      ad_complain "You cannot delete objects of type $o"
      continue
    }
    # add valid deletes to list
    lappend work_list "qw_del $id $o"

}

# Now do new
set new_names [array names new]


# divide new array into object arrays
::qw::array::divide $qw_group_id new new_obj_array new.

set uploaded_files [ns_conn files]
set files_p [llength $uploaded_files]


foreach new_obj [array names new_obj_array] {

    # new_obj is: object.id value is object.
    # check if the obj can be created.
    set o $new_obj_array($new_obj)

    # Check that the qw_group can create new objects

    if {![qw_if_exists qw_ops.${qw_group_id}.new $o]} {
      ad_complain "You cannot create new objects of type $o"
      continue
    }

    # do some callbacks
    #::qw::filter::combine_date_parts $new_obj "test_date" "%Y-%m-%d %H:%M:%S GMT"
    ::qw::callbacks::run $o new "after_object_validate"
    # check for file uploads
    if {$files_p} {
        set id [lindex [split $new_obj "."] end]
        ::qw::file::get_queryvars "new.${o}.*.${id}" file_var_list
    } else {
        set file_var_list ""
    }

    lappend work_list "qw_new -FILES \{$file_var_list\} $o $new_obj "

}

# Now do set
set set_names [array names set]

# divide set array into object arrays
::qw::array::divide $qw_group_id set set_obj_array set.


foreach set_obj [array names set_obj_array] {

    # set_obj is: object.id value is object.
    # check if the obj can be created.
    set o $set_obj_array($set_obj)

    # Check that qw_group can update object

    if {![qw_if_exists qw_ops.${qw_group_id}.set $o]} {
      ad_complain "You cannot update objects of type $o"
      continue
    }
    # do some callbacks
    ::qw::callbacks::run $o set "after_object_validate"

    # check for file uploads

    set set_obj_list [split $set_obj "."]
    set id [lindex $set_obj_list end]

    if {[nsv_get qw_obj_perm $o]} {
     # check ability of user to write this specific object
      if {![ad_permission_p -user_id $user_id $id "write"]} {
        ad_complain "You do not have permission to update object $o with id $id"
        continue
      }
    }
    lappend work_list "qw_set $id $o $set_obj"
}

# time to complain
if {[ad_complaints_count]} {
    ad_return_complaint [ad_complaints_count] "<li>[join [ad_complaints_get_list] "\n<li>"]"
    return -code return
}


# Process work_list
foreach job $work_list {

    eval $job

}

if {[string first "\[" $return_url] > -1} {
    # potential command in return_url just return
    ad_returnredirect $return_url
} else {
    #ad_returnredirect  [subst $return_url]
    ns_returnredirect [subst $return_url]
}
