ad_library {
    @author Tom Jackson (tom@junom.com)
    @creation-date 2003 July 22 
    @cvs-id $Id: qw-acs-object-procs.tcl,v 1.1 2003/11/07 06:59:26 tom Exp $

}

namespace eval acs_object {

    ad_proc -public new {
        { -object_id "" }
        { -creation_date "" }
        { -creation_user "" }
        { -creation_ip "" }
        { -context_id "" }
        { -security_inherit_p "t"}
        object_type
    } {
        Creates new object of given type. 
        Returns new object_id or empty string on failure.
        @author Tom Jackson <tom@junom.com>
        @creation-date 2003 July 15

    } {
    
        db_transaction {        
            set new_object_id [db_string new_object {} ]
        } on_error {
            set new_object_id ""
        }

        return $new_object_id
    
    }


    ad_proc -public delete {
        object_id
    } {
        Deletes acs_object of given object_id, 
        returns what?
    } {

        db_string delete_object {}
    }

    ad_proc -public update {
        { -creation_date "" }
        { -creation_user "" }
        { -creation_ip "" }
        { -context_id "" }
        { -object_type ""}
        { -security_inherit_p ""}
        { -modifying_user ""}
        { -modifying_ip ""}
        { -update_last_modified "t"}
        object_id
    } {
        Updates acs_object.
    } {
        if {[string equal "t" $update_last_modified]} {
            lappend attrs "last_modified = current_timestamp"

        }
    
        foreach attr [list creation_date creation_user creation_ip\
              context_id object_type security_inherit_p \
              modifying_user modifying_ip] {
        
            if {![string equal "" [set $attr]]} {
                  lappend attrs "$attr = :$attr"
            }
        }
    
        db_dml update_object {}
    }
    
    # end namespace acs_object
}
