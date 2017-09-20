# @file: query-writer-procs.tcl
# @author: Russell Sorensen (russell.todd.sorensen@gmail.com)
# @creation-date: 8 February 2002

#source "C:/naviserver/servers/openacs/tcl/twist/twist-0.9.10/init.tcl"

namespace eval ::qw {}

namespace eval ::qw::array {}

namespace eval ::qw::file {}

namespace eval ::qw::filter {}

namespace eval ::qw::init {}

namespace eval ::qw::callbacks {}

namespace eval ::qw::object {}

ad_proc -public qw_write_fn {object attrs}  {

    <p>Calculates the signature for the passed in object and attributes,
       and then picks a matching function prototype. If a match is found,
       the information is used to construct a string representing the
       function call using bind variables.
    <p>Although this is a public procedure, usually it will be used by
       other query-writer procedures.


} {
    log InfoDebug "Running qw_write_fn with $object $attrs"

    set query [list]
    set in_args [list]
    set args [concat $attrs]

    foreach {attr sign value} $args {
      lappend in_args $attr
      set attr_array($attr) $value
    }

    set attrs_and_defaults [eval qw_choose_function $object $in_args]

    foreach {attr default_value} $attrs_and_defaults {

      # see if attr was passed in with value
      log InfoDebug "ATTRS: '$attr' default '$default_value'"

      if {![info exists attr_array($attr)]} {

        if {[string match "" "$default_value"]} {
            ns_log Error "Attempt to call $object with no value for $attr"
            ns_return 200 text/plain "Attempt to call object $object with no value for $attr, which cannot be null."
            return -code error
        }

        lappend query "$default_value"
      } else {
        lappend query "$attr_array($attr)"
      }
    }

    log InfoDebug "${object}([join $query ",\n"]);"
    return "${object}([join $query ",\n"])"
}


ad_proc -public qw_add_object {object args} {

  <p>Takes an object name and any number of attributes. Each attribute is
  given a value starting with 1 and continuing: 2, 4, 8, 16 ...
  Two nsv arrays elemnts are set as a result of these calls.
  <ul>
   <li>qw_pg_objects $object $args  -- holds the list of attributes
       to the object
   <li>qw_attr_val_$object $attr $n -- holds the attribute value.
  </ul>
  <p>These arrays are used by future calls to qw_add_function.


} {
    nsv_set qw_pg_objects $object $args
    set n 1

    foreach attr $args {
      if {[empty_string_p $attr]} {
        continue
      }
      nsv_set qw_attr_val_$object $attr $n
      set n [expr $n * 2]
    }
}

ad_proc -private qw_total_attributes {object attributes} {

  <p>Procedure to total the attribute values assigned in
     <code>qw_add_object</code>.

} {
    upvar $object object_array
    upvar $attributes attrs
    set total 0

    foreach attribute $attrs {
      log InfoDebug "Adding $attribute"
      incr total $object_array($attribute)

    }

    return $total
}

ad_proc qw_add_function {object args} {

    <p>Adds a function prototype to an object. The attributes values assigned
       in <code>qw_add_object</code> are used to assign a signature value to
       the function prototype. The result is stored in an nsv array:
       <ul>
        <li>qw_$object_functions $sig $args
       </ul>
    <p>In addition to defining a function prototype, default values can be assigned
    to any or all attributes. The empty string is a signal that no default is
    provided, meaning that the attribute must be supplied in the function call.

} {
    # total up the function value.
    array set temp_object [nsv_array get qw_attr_val_$object]
    set i 1

    foreach {attr default} $args {
      lappend attr_list $attr
    }

    set total [qw_total_attributes temp_object attr_list]
    nsv_set qw_${object}_functions $total $args

}

ad_proc -private qw_choose_function {object args} {

    <p>Chooses a matching function prototype given a passed in signature.
    The design of the function signature system is to allow function
    overloading. Several same named function can be used with different
    attributes passed in.

} {
    array set temp_object [nsv_array get qw_attr_val_$object]
    log InfoDebug "Getting Array: qw_attr_val_$object"

    if {[catch {
        set total [qw_total_attributes temp_object args]
    } err ]} {
        ns_return 200 text/plain "Attribute or Array Not found: qw_attr_val_$object
Probably the attribute has not been added yet, or the function is misnamed."
        return -code return
    }

    if {[nsv_exists qw_${object}_functions $total]} {
       log InfoDebug "Found matching sig: '$total'"
       return [nsv_get qw_${object}_functions $total]
    }

    set functions [nsv_array names qw_${object}_functions]

    foreach sig $functions {
      log InfoDebug "checking sig '$total' against '$sig'"

      if {$total == [expr $sig & $total]} {
        log InfoDebug "Found match '$total' in '$sig'"
        return [nsv_get qw_${object}_functions $sig]
      }
    }

    ns_log Error "!NO MATCH: $total not in $functions"
    return -code error
}


proc qw_if_array_elements_exist {array pattern} {

    if {[string match "" [array get $array $pattern]]} {
      return "0"
    } else {
      return "1"
    }
}

proc qw_if_exists {array element} {


    if {[nsv_exists $array $element ]} {
      return "1"
    } else {
      return "0"
    }
}

ad_proc -public qw_get_group_id { } {

    <p>User implemented procedure to place each user into a specific qw security group.
    QW security groups are used to allow different classes of users access to distinct
    sets of attributes and actions on these attributes. The query-writer package starts
    with two security groups: <code>admin</code> and <code>default</code>. The
    <code>admin</code> group is generally given free reign to alter any attribute.
    The <code>default</code> group is
    usually assigned only the bare minimum attributes and methods needed for using the
    application.
    <p>One idea for implimenting this function is to wrap <code>ad_permission_p</code>
     and test the root object <code>0</code>.
    <p>This procedure should be replace by the developer with something more useful.

} {
    return 1

}

ad_proc -private qw_del_pl_postgresql { } {

    <p>User defined procedure to write and execute the procedural language
       code call to delete the object.

} {
    uplevel 1 {
      set key [nsv_get qw_obj_key $object]
      set pl "select [qw_write_fn [nsv_get qw_del_fn $object] [subst { $key => :id }]]"

      db_exec_plsql qw_del_pl_postgresql $pl
    }
}

ad_proc -private qw_del_dml_postgresql { } {

    <p>User defined procedure to write and execute the dml to delete an object.

} {
    uplevel 1 {

      set table [nsv_get qw_obj_table $object]
      set key [nsv_get qw_obj_key $object]
      set dml "delete from $table where $key = :id"

      db_dml qw_del_dml_postgresql $dml
    }
}

ad_proc -private qw_new_pl_postgresql { } {

    <p>User defined procedure to write and execute procedural language to create
    a new object.

} {
    uplevel 1 {
      set PL ""

      foreach ATTR [array names ARR] {

        # set each ATTR to local var.
        set ATTRTYPE [nsv_get qw_datatype ${OBJECT}.$ATTR]
        switch -glob -nocase -- $ATTRTYPE {
            "timestamp*" {
                set ATTRTYPE "timestamptz"
            }
            "char*" {
                set ATTRTYPE "varchar"
            }
        }
        set $ATTR $ARR($ATTR)
        lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] => :${ATTR}::$ATTRTYPE "

      }

      # work through extra vars in to_eval
      if {[nsv_exists qw_to_eval $OBJECT]} {
        foreach {VAR EVAL_STMT} [split [nsv_get qw_to_eval $OBJECT] ";"] {
          eval $EVAL_STMT
          lappend ATTR_LIST "$VAR => :$VAR "
        }
      }

      append PL "select [qw_write_fn [nsv_get qw_new_fn $OBJECT] [subst { [join $ATTR_LIST "\n"]}]] "

      set qw_last_new_object_id [db_string qw_new_pl_postgresql $PL]

    }
}


ad_proc -private qw_new_pl2_postgresql { } {

    <p>User defined procedure to write and execute procedural language to create
    a new object.

} {
    uplevel 1 {
      set PL ""

      foreach ATTR [array names ARR] {

        # set each ATTR to local var.
        set ATTRTYPE [nsv_get qw_datatype ${OBJECT}.$ATTR]
        #if {[string match int* $ATTRTYPE]} {
         #   lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] => ${ATTR}::$ATTRTYPE "
        #}
        set $ATTR $ARR($ATTR)
        lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] => :${ATTR}::$ATTRTYPE "

      }

      # work through extra vars in to_eval
      if {[nsv_exists qw_to_eval $OBJECT]} {
        foreach {VAR EVAL_STMT} [split [nsv_get qw_to_eval $OBJECT] ";"] {
          eval $EVAL_STMT
          lappend ATTR_LIST "$VAR => :$VAR "
        }
      }

      append PL "select [qw_write_fn [nsv_get qw_new_fn $OBJECT] [subst { [join $ATTR_LIST "\n"]}]] "

      set qw_last_new_object_id [db_string qw_new_pl2_postgresql $PL]

    }
}


ad_proc -private qw_new_dml_postgresql { } {

    <p>User defined procedure to write and execute the dml to create a new object.

} {
    uplevel 1 {

      set DML ""
      set BIND_VAR_LIST [list]

      foreach ATTR [array names ARR] {
        # set each ATTR to local var.
        set $ATTR $ARR($ATTR)
        lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}]"
        lappend BIND_VAR_LIST ":$ATTR"

      }

      # work through extra vars in to_eval
      if {[nsv_exists qw_to_eval $OBJECT]} {
        log InfoDebug "FOUND EVAL for '$OBJECT'"
        foreach {VAR EVAL_STMT} [split [nsv_get qw_to_eval $OBJECT] ";" ] {

            log InfoDebug "EVAL: '$EVAL_STMT'"

            eval $EVAL_STMT
            lappend ATTR_LIST "$VAR"
            lappend BIND_VAR_LIST ":$VAR"

        }
      }

      append DML "insert into [nsv_get qw_obj_table $OBJECT] ([join $ATTR_LIST ", "]) values ([join $BIND_VAR_LIST ", "]) "

      db_dml qw_new_dml_postgresql $DML
    }
}


ad_proc -private qw_set_pl_postgresql { } {

    <p>User defined procedure to write and execute the procedural language code
    to update an object.

} {
    uplevel 1 {

      set PL ""

      foreach ATTR [array names ARR] {

        # set each ATTR to local var.
        set $ATTR $ARR($ATTR)

        if {![empty_string_p $ARR($ATTR)]} {
          lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] => :$ATTR"
        } else {
          lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] => ''"
        }

            }

      # set the primary key attr
      set PKEY [nsv_get qw_obj_key $OBJECT]
      set $PKEY $ID
      lappend ATTR_LIST "$PKEY => :$PKEY"

      append PL "select [qw_write_fn [nsv_get qw_set_fn $OBJECT] [subst { [join $ATTR_LIST "\n"]}]] "

      db_exec_plsql qw_set_pl_postgresql $PL

    }
}

ad_proc -private qw_set_dml_postgresql { } {

    <p>User defined procedure to write the dml to update an object.

} {
    uplevel 1 {
      set DML ""

      foreach ATTR [array names ARR] {

        # set each ATTR to local var.
        set $ATTR $ARR($ATTR)

        if {![empty_string_p $ARR($ATTR)]} {
            lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}]  = :$ATTR"
        } elseif {[string match "integer" [nsv_get qw_datatype ${OBJECT}.${ATTR}]]} {
            # Lars suggestion that empty string should mean null in case of integer.
            lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}]  = NULL"
        } else {
            lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] = ''"
        }

      }

      # set the primary key attr
      set PKEY [nsv_get qw_obj_key $OBJECT]
      set $PKEY $ID

      append DML "update [nsv_get qw_obj_table $OBJECT] set [join $ATTR_LIST ", "] where $PKEY = :$PKEY"
      db_dml qw_set_dml_postgresql $DML
    }
}

ad_proc -public qw_del { id object } {

    <p>Deletes a named object with the given id. This procedure is part of the
    tcl api.

} {
    if {[nsv_exists qw_del $object]} {

        # determine method to create new obj
        set METHOD [nsv_get qw_del $object]

        switch -exact -- "$METHOD" {
            "pl" - "pseudo" - "dml" {
                [nsv_get qw_obj_del "$METHOD"]
            }
            default {
                [nsv_get qw_obj_del "pl"]
            }
        }
    } elseif {[nsv_exists qw_del_fn $object]} {
        # Delete using pl
        [nsv_get qw_obj_del pl] ;# qw_del_pl_postgresql
    } elseif {[nsv_exists qw_obj_table $object]} {
        # use the standard sql delete
        [nsv_get qw_obj_del dml] ;# qw_del_dml_postgresql
    } else {
        # no way to delete object, ignore and log
        ns_log Error "qw_del: No Method to delete object '$object' with id '$id'"
    }

}


ad_proc -public qw_new {
    {-FILES {}}
    OBJECT
    ARRAY
} {

    <p>Creates a new object given the object name and an array of attributes.
    This procedure is part of the tcl api. When using this procedure directly,
    you can build up the array like this:
    <pre>
    set in_array(attr1) value1
    set in_array(attr2) value2
    # then call qw_new
    qw_new my_object in_array
    </pre>
    <p>If files are uploaded as part of the new object, the objec
    needs to have a procedure setup to handle the files.
    Note: experimental at the moment.

} {
    # Note internal variable names are all caps
    # to avoid clashing with attr names passed in.

    log InfoDebug "qw_new: object '$OBJECT' array '$ARRAY' Files: '$FILES'"

    upvar $ARRAY ARR
    global qw_last_new_object_id
    set ATTR_LIST [list]

    # Handle files, if any
    if {[llength $FILES]} {

        log InfoDebug "Got files: '$FILES'"
        if {[nsv_exists qw_object_files_new $OBJECT]} {
            [nsv_get qw_object_files_new $OBJECT] $FILES ARR
        } else {
            ns_log Error "File upload for object $OBJECT without handler."
        }
    }

    if {[nsv_exists qw_new $OBJECT]} {
        # determine method to create new obj
        set METHOD [nsv_get qw_new $OBJECT]
        switch -exact -- "$METHOD" {
            "pl" - "pseudo" - "dml" {
                [nsv_get qw_obj_new "$METHOD"]
            }
            default {
                [nsv_get qw_obj_new "pl"]
            }
        }
    } elseif {[nsv_exists qw_new_fn $OBJECT]} {
        [nsv_get qw_obj_new pl]
    } elseif {[nsv_exists qw_obj_table $OBJECT]} {
        # use standard dml for insert
        [nsv_get qw_obj_new dml] ;# qw_new_dml_postgresql
    } else {
        # no way to create new object, ignore and log
        ns_log Error "qw_new: No Method to insert new object '$OBJECT'"
    }


}

ad_proc -public qw_set { ID OBJECT ARRAY } {

    <p>Updates an object given the object id, the object name and an array
    holding the attributes to be updated. This procedure is part of the
    query-writer tcl api. You can use this procedure directly as follows:
   <pre>
    set in_array(attr1) value1
    set in_array(attr2) value2
    # then call qw_new
    qw_set $id my_object in_array
    </pre>



} {
    # Note internal variable names are all caps
    # to avoid clashing with attr names passed in.
    log InfoDebug "qw_set: object '$OBJECT' array '$ARRAY'"
    upvar $ARRAY ARR
    set ATTR_LIST [list]

    if {[nsv_exists qw_set $OBJECT]} {

        # determine method to create new obj
        set METHOD [nsv_get qw_set $OBJECT]

        switch -exact -- "$METHOD" {
            "pl" - "pseudo" - "dml" {
                [nsv_get qw_obj_set "$METHOD"]
            }
            default {
                [nsv_get qw_obj_set "pl"]
            }
        }
    } elseif {[nsv_exists qw_set_fn $OBJECT]} {
      # use pl to update attrs
      [nsv_get qw_obj_set pl] ;# qw_set_pl_postgresql
    } elseif {[nsv_exists qw_obj_table $OBJECT]} {
      # use standard dml for update
      [nsv_get qw_obj_set dml] ;# qw_set_dml_postgresql
    } else {
      # no way to update object, ignore and log
      ns_log Error "qw_set: No Method to update object '$OBJECT'"
 }


}

ad_proc -public qw_run_filters {object attr value } {

    <p>Runs filters registered for the object attribute. Additionally,
    this procedure runs a length filter for attributes that have a
    maximum length.


} {

  set return_value 1
  log InfoDebug "qw_run_filters: object '$object' '$attr' '$value'"

  if {[nsv_exists qw_filters ${object}.${attr}]} {

    foreach filter [split [nsv_get qw_filters ${object}.${attr} ] ","] {
        # Run filter
        log InfoDebug "qw_run_filters: filter '$filter'"
        if {![ad_page_contract_filter_proc_$filter $attr value]} {
            set return_value 0
        }
    }
  }

  if {[nsv_exists qw_length ${object}.${attr}]} {
    if {[string length $value] > [nsv_get qw_length ${object}.${attr}]} {
      if {[nsv_exists qw_attr_desc ${object}.${attr} ]} {
        set desc [nsv_get qw_attr_desc ${object}.${attr}]
      } else {
        set desc $attr
      }
      ad_complain "$desc has a maximum length of [nsv_get qw_length ${object}.${attr}]. The value you entered is [string length $value] characters long.</li>"
      set return_value 0
    }
  }
  return $return_value
}


proc qw_attr_perm_map { group_id object_id attr_id values ops } {

    set ops_list [split $ops ";"]
    log InfoDebug "qw_attr_perm_map ops_list $ops_list"

    # do del ops.

    if {[lsearch $ops_list "del"] > -1} {
      log InfoDebug "qapm: mapping del 'qw_ops.${group_id}.del $object_id 1'"
      nsv_set qw_ops.${group_id}.del $object_id 1
    }
    if {[lsearch $ops_list "new"] > -1} {
      log InfoDebug "qapm: mapping new 'qw_ops.${group_id}.new $object_id 1'"
      nsv_set qw_ops.${group_id}.new $object_id 1
    }
    if {[lsearch $ops_list "set"] > -1} {
      log InfoDebug "qapm: mapping set 'qw_ops.${group_id}.set $object_id 1'"
      nsv_set qw_ops.${group_id}.set $object_id 1
    }
    if {[empty_string_p $values]} {
      log InfoDebug "qapm: mapping attr 'qw_attrs.${group_id} ${object_id}.${attr_id} 1'"
      nsv_set qw_attrs.${group_id} ${object_id}.${attr_id} 1
    } else {
      foreach value [split $values ";"] {
        log InfoDebug "qapm: mapping attr-val 'qw_attrs.${group_id} ${object_id}.${attr_id}.${value} 1'"
        nsv_set qw_attrs.${group_id} ${object_id}.${attr_id}.${value} 1
      }
    }

}




proc qw_attr_perm_unmap { group_id object_id attr_id values ops } {

    set ops_list [split $ops ";"]
    log InfoDebug "qw_attr_perm_unmap ops_list $ops_list"

    # do del ops.

    if {[lsearch $ops_list "del"] > -1} {
      if {[nsv_exists qw_ops.${group_id}.del $object_id ]} {
        log InfoDebug "qapm: unmapping del 'qw_ops.${group_id}.del $object_id'"
        nsv_unset qw_ops.${group_id}.del $object_id
      }
    }
    if {[lsearch $ops_list "new"] > -1} {
      if {[nsv_exists qw_ops.${group_id}.new $object_id]} {
        log InfoDebug "qapm: unmapping new 'qw_ops.${group_id}.new $object_id'"
        nsv_unset qw_ops.${group_id}.new $object_id
      }
    }

    if {[lsearch $ops_list "set"] > -1} {
      if {[nsv_exists qw_ops.${group_id}.set $object_id ]} {
        log InfoDebug "qapm: unmapping set 'qw_ops.${group_id}.set $object_id'"
        nsv_unset qw_ops.${group_id}.set $object_id
      }
      if {[empty_string_p $values]} {
        if {[nsv_exists qw_attrs.${group_id} ${object_id}.${attr_id}]} {
          log InfoDebug "qapm: unmapping attr 'qw_attrs.${group_id} ${object_id}.${attr_id}'"
          nsv_unset qw_attrs.${group_id} ${object_id}.${attr_id}
        }
      } else {
        foreach value [split $values ";"] {
            if {[nsv_exists qw_attrs.${group_id} ${object_id}.${attr_id}.${value}]} {
                log InfoDebug "qapm: unmapping attr-val 'qw_attrs.${group_id} ${object_id}.${attr_id}.${value}'"
                nsv_unset qw_attrs.${group_id} ${object_id}.${attr_id}.${value}
            }
        }
      }
    }
}


proc qw_map_id_to_object {object_id object} {

    log InfoDebug "qmito: map 'qw_id_to_object ${object_id} $object'"
    nsv_set qw_id_to_object ${object_id} $object

}

proc qw_unmap_id_to_object { object_id } {

    log InfoDebug "qumito: unmap 'qw_id_to_object ${object_id}'"
    nsv_unset qw_id_to_object ${object_id}

}

proc qw_map_id_to_attr { object_id attr_id attr } {

    log InfoDebug "qmita: map 'qw_id_to_attr ${object_id}.${attr_id} $attr'"
    nsv_set qw_id_to_attr ${object_id}.${attr_id} $attr

}

proc qw_unmap_id_to_attr { object_id attr_id } {

    if {[nsv_exists qw_id_to_attr ${object_id}.${attr_id}]} {
      log InfoDebug "quita: unmap 'qw_id_to_attr ${object_id}.${attr_id}'"
      nsv_unset qw_id_to_attr ${object_id}.${attr_id}
    }

}



proc qw_map_filter { object_id attr_id filters } {

    if {![empty_string_p $filters]} {
      log InfoDebug "qmf: map 'qw_filters ${object_id}.${attr_id} [split $filters ";"]'"
      nsv_set qw_filters ${object_id}.${attr_id} [split $filters ";"]
    }

}

proc qw_unmap_filter { object_id attr_id } {

    if {[nsv_exists qw_filters ${object_id}.${attr_id}]} {
      log InfoDebug "quf: unmap 'qw_filters ${object_id}.${attr_id}'"
      nsv_unset qw_filters ${object_id}.${attr_id}
    }

}

# MAP DATATYPE #
proc qw_map_datatype { object_id attr_id datatype } {

    if {![empty_string_p $datatype]} {
      log InfoDebug "qmd: map 'qw_datatype ${object_id}.${attr_id} [split $datatype ";"]'"
      nsv_set qw_datatype ${object_id}.${attr_id} $datatype
    }

}

proc qw_unmap_datatype { object_id attr_id } {

    if {[nsv_exists qw_datatype ${object_id}.${attr_id}]} {
      log InfoDebug "qud: unmap 'qw_datatype ${object_id}.${attr_id}'"
      nsv_unset qw_datatype ${object_id}.${attr_id}
    }

}

proc qw_unmap_obj_properties {object_id} {

    if {[db_0or1row obj_unmap_properties_query "
select
 obj_table,
 key as obj_key,
 to_eval,
 new_fn,
 set_fn,
 del_fn,
 rst_fn,
 perm_p as obj_perm
from
 qw_objects
where
 object_id = :object_id " ]} {
      # do the mapping
      foreach attr [list obj_table obj_key new_fn set_fn del_fn rst_fn to_eval obj_perm] {

        if {![empty_string_p [set $attr]] && [nsv_exists qw_$attr $object_id]} {
          log InfoDebug "quop: unmap 'qw_$attr $object_id'"
          nsv_unset qw_$attr $object_id
        }
      }
     }
}

proc qw_map_obj_properties {object_id} {

    if {[db_0or1row obj_map_properties_query "
select
 obj_table,
 key as obj_key,
 to_eval,
 new_fn,
 set_fn,
 del_fn,
 rst_fn,
 perm_p as obj_perm
from
 qw_objects
where
 object_id = :object_id " ]} {
      # do the mapping
      foreach attr [list obj_table obj_key new_fn set_fn del_fn rst_fn to_eval obj_perm] {

        if {![empty_string_p [set $attr]]} {
            #log InfoDebug "qmop: map 'qw_$attr $object_id [set $attr]'"
            nsv_set qw_$attr $object_id [set $attr]
        }
      }
   }

}


### GENERIC NSV MAPPER ########


proc qw_map_nsv {nsv_name nsv_element nsv_value} {

    log InfoDebug "qmn: map '$nsv_name $nsv_element $nsv_value'"
    nsv_set $nsv_name $nsv_element $nsv_value

}
proc qw_unmap_nsv {nsv_name nsv_element} {

    if {[nsv_exists $nsv_name $nsv_element]} {
      log InfoDebug "qun: map '$nsv_name $nsv_element'"
      nsv_unset $nsv_name $nsv_element
    }
}

#### ATTR LENGTH #######


proc qw_map_attr_length {object_id attr_id length} {

    if {$length > 0} {
        log InfoDebug "qwal: map 'qw_length ${object_id}.${attr_id} $length'"
        nsv_set qw_length ${object_id}.${attr_id} $length
    }

}
proc qw_unmap_attr_length {object_id attr_id} {

    if {[nsv_exists qw_length ${object_id}.${attr_id}]} {
        log InfoDebug "qual: unmap 'qw_length ${object_id}.${attr_id}'"
        nsv_unset qw_length ${object_id}.${attr_id}
    }

}


##### ATTR DESCRIPTION AND HELP TEXT ######


proc qw_map_attr_txt {object_id attr_id description help_text} {

    log InfoDebug "qmat: map 'qw_attr_desc ${object_id}.${attr_id} $description'"
    nsv_set qw_attr_desc ${object_id}.${attr_id} $description
    if {![empty_string_p $help_text]} {
      log InfoDebug "qmat: map 'qw_attr_help ${object_id}.${attr_id} $help_text'"
      nsv_set qw_attr_help ${object_id}.${attr_id} $help_text
    }

}

proc qw_unmap_attr_txt {object_id attr_id} {

    if {[nsv_exists qw_attr_desc ${object_id}.${attr_id}]} {
      log InfoDebug "quat: unmap 'qw_attr_desc ${object_id}.${attr_id}'"
      nsv_unset qw_attr_desc ${object_id}.${attr_id}
    }
    if {[nsv_exists qw_attr_help ${object_id}.${attr_id}]} {
      log InfoDebug "quat: unmap  'qw_attr_help ${object_id}.${attr_id}'"
      nsv_unset qw_attr_help ${object_id}.${attr_id}
    }

}


## Write Object Functions ###
ad_proc -public qw_write_obj_functions { } {

    <p>Procedure to write and execute the <code>qw_add_object</code> and
    <code>qw_add_function</code> calls. Calling this procedure after server
    startup will only overwrite matching data. If an old function needs to be
    removed, this procedure may not do what you want.

} {
    set obj_sql "
select
 qo.object,
 qa.*,
 qf.*
from
 qw_objects qo,
 qw_attrs qa,
 qw_fns qf
where
 qo.object_id = qf.object_id
and
 qf.object_id = qa.object_id
order by qa.attr"


    db_foreach obj_attr_qry $obj_sql {

        if {[info exists _$fn_id]} {
            lappend _$fn_id "$attr"
        } else {
            set _$fn_id [list]
            lappend _$fn_id "$attr"
            }

        if {![string match "" $joiner]} {
            set full_function_name($fn_id) $object$joiner$name
        } else {
            set full_function_name($fn_id) $name
        }
    }

    foreach name [array names full_function_name] {

        log InfoDebug "qw_add_object $full_function_name($name) [join [set _$name] " "]\n"
        eval "qw_add_object $full_function_name($name) [join [set _$name] " "]"
     }

    array unset full_function_name
    # add functions

    set fn_sql "
select
 qo.object,
 qf.*,
 qfa.*
from
 qw_objects qo,
 qw_fns qf,
 qw_fn_attrs qfa
where
 qo.object_id = qf.object_id
and
 qf.fn_id = qfa.fn_id
order by qfa.fn_id, qfa.attr_order"

    db_foreach fn_attr_qry $fn_sql {

        if {[info exists a__$fn_id]} {
            lappend a__$fn_id "$attr \"$default_value\""
            log InfoDebug "ADDING($object -- $name)  $attr \"$default_value\" to a__$fn_id"
        } else {
            set a__$fn_id [list]
            lappend a__$fn_id "$attr \"$default_value\""
            log InfoDebug "ADDING($object -- $name)   $attr \"$default_value\" to a__$fn_id"
        }

        if {![string match "" $joiner]} {
            set full_function_name($fn_id) $object$joiner$name
        } else {
            set full_function_name($fn_id) $name
        }

    }

    foreach name  [array names full_function_name] {

        log InfoDebug "qw_add_function $full_function_name($name) [join [set a__$name] " "]\n"
        eval "qw_add_function $full_function_name($name) [join [set a__$name] " "]"
    }

}

# procs to help with getting the current url for calculating the
# return_url

ad_proc -public qw_this_url { } {

    <p>A convenience function for calculating the tcl/template url, without the
    query string. This procedure is usually used in calculating the
    <code>return_url</code> variable used in all forms which use the
    <code>qw.tcl</code> file.

} {
    return [ad_conn url]
}

ad_proc -public qw_this_dir { } {

    <p>A convenience function for calculating the tcl/template directory.
     This procedure is usually used in calculating the
    <code>return_url</code> variable used in all forms which use the
    <code>qw.tcl</code> file.

} {

    set url [qw_this_url]
    # check if last char is /
    if {[string match "/" [string index $url end]]} {
        return $url
    } else {
        return "[file dirname $url]/"
    }
}

## Experimental Functions

ad_proc -private qw_new_pseudo_postgresql { } {

    <p>User defined procedure to write and execute the pseudo pl to create a new object.

} {
    uplevel 1 {
      set DML ""
      set BIND_VAR_LIST [list]
      set ACS_OBJECT_ATTRS [list object_id creation_date creation_user creation_ip context_id security_inherit_p]
      set ACS_SWITCHES [list]
      # check if object_id is already defined
      set KEY [nsv_get qw_obj_key $OBJECT]

      foreach ATTR [array names ARR] {
        # set each ATTR to local var.
        set $ATTR $ARR($ATTR)
        set REAL_ATTR "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}]"
    if {[lsearch $ACS_OBJECT_ATTRS $REAL_ATTR] > -1} {
        lappend ACS_SWITCHES "-$REAL_ATTR [set $ATTR]"
    } else {
        lappend ATTR_LIST $REAL_ATTR
        lappend BIND_VAR_LIST ":$ATTR"
    }
      }

      if {![info exists ARR(object_id)] && [info exists ARR($KEY)] && ![empty_string_p $ARR($KEY)] } {

      lappend ACS_SWITCHES "-object_id $ARR($KEY)"
      set OBJECT_KEY_EXISTS 1

      } else {
      set OBJECT_KEY_EXISTS 0
      }

      # work through extra vars in to_eval
      if {[nsv_exists qw_to_eval $OBJECT]} {
        log InfoDebug "FOUND EVAL for '$OBJECT'"
      foreach {VAR EVAL_STMT} [split [nsv_get qw_to_eval $OBJECT] ";" ] {
          log InfoDebug "EVAL: '$EVAL_STMT' VAR: '$VAR'"
          eval $EVAL_STMT
          if {[lsearch $ACS_OBJECT_ATTRS $VAR] > -1} {
          lappend ACS_SWITCHES "-$VAR [set $VAR]"
          } else {
          lappend ATTR_LIST "$VAR"
          lappend BIND_VAR_LIST ":$VAR"
          }
        }
      }

      # create acs_object code


    set OBJECT_CALL "set ACS_OBJECT_ID \[acs_object::new [join $ACS_SWITCHES " "] $OBJECT\]"


    db_transaction {
        eval $OBJECT_CALL

        if {$OBJECT_KEY_EXISTS} {
            db_dml qw_new_pseudo_postgresql "insert into [nsv_get qw_obj_table $OBJECT] ([join $ATTR_LIST ", "])
             values ([join $BIND_VAR_LIST ", "]) "
        } else {
            db_dml qw_new_pseudo_postgresql "insert into [nsv_get qw_obj_table $OBJECT] ($KEY, [join $ATTR_LIST ", "])
             values ($ACS_OBJECT_ID, [join $BIND_VAR_LIST ", "]) "
        }
            set qw_last_new_object_id $ACS_OBJECT_ID
        } on_error {
            ns_log Error "Transaction error on $OBJECT_CALL $errmsg"
            return ""
        }
     }
}


# experimental set for pl, using dml instead

ad_proc -private qw_set_pseudo_postgresql { } {

    <p>User defined procedure to write the pseudo pl to update an object.

} {
    uplevel 1 {
      set DML ""

      foreach ATTR [array names ARR] {

        # set each ATTR to local var.
        set $ATTR $ARR($ATTR)

        if {![empty_string_p $ARR($ATTR)]} {
            lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}]  = :$ATTR"
        } elseif {[string match "integer" [nsv_get qw_datatype ${OBJECT}.${ATTR}]]} {
            # Lars suggestion that empty string should mean null in case of integer.
            lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}]  = NULL"
        } else {
            lappend ATTR_LIST "[nsv_get qw_id_to_attr ${OBJECT}.${ATTR}] = ''"
        }

      }

      # set the primary key attr
      set PKEY [nsv_get qw_obj_key $OBJECT]
      set $PKEY $ID

      append DML "update [nsv_get qw_obj_table $OBJECT] set [join $ATTR_LIST ", "] where $PKEY = :$PKEY"
      db_dml qw_set_pseudo_postgresql $DML
    }
}


# experimental del for pl, using dml instead
ad_proc -private qw_del_pseudo_postgresql { } {

    <p>User defined procedure to write and execute the pseudo pl to delete an object.

} {
    uplevel 1 {

      set table [nsv_get qw_obj_table $object]
      set key [nsv_get qw_obj_key $object]
      set dml "delete from $table where $key = :id"

      # check that id is object of given type

      if {[db_0or1row object_exists "select 1 from $table where $key = :id"]} {
          db_transaction {
              db_dml qw_del_pseudo_postgresql $dml
              acs_object::delete $id
          } on_error {
              return ""
          }
      }
   }
}

# procs to process new, set del arrays.



## ns_getform made safe

rename ns_getform ns_getform_unsafe


#
# ns_getform --
#
#    Return the connection form, copying multipart form data
#    into temp files if necessary.
#

proc ns_getform {{charset ""}}  {
    global _ns_form _ns_formfiles

    #
    # If a charset has been specified, use ns_urlcharset to
    # alter the current conn's urlcharset.
    # This can cause cached formsets to get flushed.
    if {$charset != ""} {
        ns_urlcharset $charset
    }

    if {![info exists _ns_form]} {

        set _ns_form [ns_conn form]

        foreach {file} [ns_conn files] {

            set off [ns_conn fileoffset $file]
            set len [ns_conn filelength $file]
            set hdr [ns_conn fileheaders $file]
            set type [ns_set get $hdr content-type]
            set fp ""

            while {$fp == ""} {
                set tmpfile [ns_tmpnam]
                set fp [ns_openexcl $tmpfile]
            }

            fconfigure $fp -translation binary
            ns_conn copy $off $len $fp

            close $fp

            ns_atclose "ns_unlink -nocomplain $tmpfile"

            set _ns_formfiles($file) $tmpfile

            #ns_set put $_ns_form $file.content-type $type
            #NB: Insecure, access via ns_getformfile.
            #ns_set put $_ns_form $file.tmpfile $tmpfile
        }
    }
    return $_ns_form
}


# qw upload testing

proc ::upload_files {files array} {
    upvar $array Array

    set object_key [nsv_get qw_obj_key upload]

    if {[info exists Array($object_key)] && ![empty_string_p $Array($object_key)]} {
        set object_id $Array($object_key)
    } else {
        set object_id [db_string acs_object_id "select acs_object_id_seq.nextval"]
        set Array($object_key) $object_id
    }

    foreach {attribute original_file_var} $files {

        log InfoDebug "Got file for '$attribute' original_file_var: '$original_file_var'"

        set tmpfile [ns_getformfile $original_file_var]
        set filesize [ns_conn filelength $original_file_var]
        set headers [ns_conn fileheaders $original_file_var]
        set content_type [ns_set iget $headers "content-type"]
        set content_disposition [ns_set iget $headers "content-disposition"]
        set filename $Array($attribute)
        set backslash "\\"

        log InfoDebug "backslash: '$backslash'"

        if {[set last_backslash [string last $backslash $filename]] > -1 } {
            set filename [string range $filename [expr $last_backslash + 1] end]
            set Array($attribute) $filename
        }

        log InfoDebug "tmpfile is '$tmpfile' filesize: $filesize content-type: $content_type
content-disposition: '$content_disposition'
filename: '$filename'"
        log InfoDebug "Key: $object_key value: $Array($object_key)"

        # Okay where to upload the file to based on input
        set path /tmp/$object_id/$attribute/
        file mkdir $path
        file copy $tmpfile $path$filename
    }

}



ad_proc ::qw::array::divide {
    qw_group_id
    inArray
    newArray
    {outArray new.}

} {

    Divide The new array into individual arrays.
} {

    upvar $inArray IN
    upvar $newArray NEW
    set NAMES [array names IN]

    foreach NAME $NAMES {

        set LIST [split $NAME "."]
        set OBJECT [lindex $LIST 0]
        set ATTRIBUTE [join [lrange $LIST 1 end-1] "."]
        set OUT_ARRAY ${outArray}${OBJECT}.[lindex $LIST end]

        if {![array exists $OUT_ARRAY]} {
            upvar $OUT_ARRAY $OUT_ARRAY
        }

        # check if qw_group can create attribute or attribute with specific value

        if {![nsv_exists qw_attrs.${qw_group_id} ${OBJECT}.${ATTRIBUTE}] && ![nsv_exists qw_attrs.${qw_group_id} ${OBJECT}.${ATTRIBUTE}.$IN($NAME)]} {
            ad_complain "You cannot create $OBJECT objects with attribute $ATTRIBUTE having value '$IN($NAME)'"
            continue
        }

        # run filters

        if {![qw_run_filters $OBJECT $ATTRIBUTE $IN($NAME)]} {
            log InfoDebug "qw.tcl: Filters failed for $OBJECT $ATTRIBUTE and '$IN($NAME)'"
            continue
        }

        # add this to an array named as:
        # new.obj.id

        set ${OUT_ARRAY}(${ATTRIBUTE}) $IN($NAME)

        # add to object array, this will probably
        # be done more than once.

        set NEW($OUT_ARRAY) $OBJECT

    }

    log InfoDebug "ARRAYS: [array names NEW]"
}

proc ::qw::filter::combine_date_parts {
    array
    date_attr
    format
} {

    upvar $array ARRAY

    if {[info exists ARRAY($date_attr)]} {
        set scan_date $ARRAY($date_attr)
    } else {

        array set DATE_PARTS [array get ARRAY ${date_attr}.*]
        set current_time [ns_time]

        foreach {PART FMT} [list year %Y month %m day %d hour %H minute %M second %S timezone %Z] {

            set ELEMENT ARRAY(${date_attr}.${PART})

            if {![info exists $ELEMENT] || [string equal "" [set $ELEMENT]]} {
                set $PART [ns_fmttime $current_time $FMT]
            } else {
                set $PART [set $ELEMENT]
            }

            log InfoDebug "DATE PART: '$PART' = '[set $PART]'"
        }

        set scan_date "${year}-${month}-${day} ${hour}:${minute}:${second} $timezone"
    }

    # catch an invalid date and convert to gmt

    if {[catch {
        set ARRAY($date_attr) [clock format [clock scan $scan_date] -format $format -gmt 1]
    } err ]} {
        ad_complain "Date '$scan_date' is invalid for attribute $date_attr"
    }

    array unset ARRAY ${date_attr}.*
}

proc ::qw::file::get_queryvars { pattern ListVar } {

    upvar $ListVar file_var_list

    set uploaded_files [ns_conn files]

    if {[set file_index [lsearch $uploaded_files $pattern]] > -1} {

        # file part of this object.

        set file_var [lindex $uploaded_files $file_index]
        set object_attribute [lindex [split $file_var "."] 2]
        set file_var_list [list]
        lappend file_var_list $object_attribute $file_var
        set next_index [expr $file_index + 1]

        while {[set next_index [lsearch -start $next_index $uploaded_files $pattern]] > -1} {
            set file_var [lindex $uploaded_files $next_index]
            set object_attribute [lindex [split $file_var "."] 2]
            lappend file_var_list $object_attribute $file_var

            incr next_index
            if {[llength $uploaded_files] <= $next_index} {
                break
            }
        }
    }
}

proc qw::init::callbacks { } {

    db_foreach qw_object_callbacks "
select
 *
from
 qw_callbacks
where
 enabled_p = 't'
order by
 object_id,
 operation,
 callback_point,
 callback_order" {

        if {![nsv_exists qw_callbacks_${operation}_${object_id} $callback_point]} {
            # initialize callback
            nsv_set  qw_callbacks_${operation}_${object_id} $callback_point [list]
        }

        log InfoDebug "qwic: init qw_callbacks_${operation}_${object_id} $callback_point"
        nsv_lappend qw_callbacks_${operation}_${object_id} $callback_point $callback
    }
}


proc qw::callbacks::run { object_id operation callback_point } {
    if {[nsv_exists qw_callbacks_${operation}_${object_id} $callback_point]} {
        foreach callback [nsv_get qw_callbacks_${operation}_${object_id} $callback_point] {
            log InfoDebug "callback ${object_id}_${operation}_${callback_point}: '$callback'"
            uplevel $callback
        }
    }
}
