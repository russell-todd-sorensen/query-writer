ad_page_contract {

    Query Writer PG Create
    @author Russell Sorensen <russell.todd.sorensen@gmail.com>
    @creation-date 14 August 2016
    
} {
    object_id:trim,notnull
} -properties {
    title:onevalue
    context:onevalue
    objects:multirow
}


db_1row object_query "
select
 *
from
 qw_objects
where
 object_id = :object_id"

set pl "

create function inline_0 () 
returns integer as '  
begin 
    PERFORM acs_object_type__create_type (  
  ''${object}'', -- object_type  
  '''', -- pretty_name 
  '''', -- pretty_plural 
  ''acs_object'',   -- supertype 
  ''${obj_table}'', -- table_name 
  ''${key}'', -- id_column 
  null, -- package_name 
  ''f'', -- abstract_p 
  null, -- type_extension_table 
  null -- name_method 
  ); 

     return 0;  
end;' language 'plpgsql'; 

select inline_0 (); 
 
drop function inline_0 ();


create or replace function ${object}__${object}_p (integer)
returns boolean
as '
declare
 p_$key alias for \$1;
 v_check_$key integer;
begin
 select count($key) into v_check_$key
  from $obj_table
  where $key = p_$key;
 if v_check_$key = 1 
 then 
   return true;
 else 
   return false;
 end if;
end;' language 'plpgsql';

"

set acs_object_attributes [list object_type creation_date creation_user\
    creation_ip context_id security_inherit_p title package_id modifying_user\
    modifying_ip last_modified]
set skip_attribute [list]

db_foreach fn_query "
select 
 fn_id,
 type,
 name,
 description,
 joiner
from
 qw_fns
where
 object_id = :object_id 
and
 active_p = 1" { 
   # I dont think the following does much for pg. 
   if {[string match "" $joiner]} { 
     set function_name $name
   } else {
     set function_name ${object}${joiner}${name} 
   }
   set in_attrs [list]
   set in_aliases [list]
   set object_table_attrs [list]
   set set_statements [list]
   set i 1
   db_foreach attr_query "
select
 fa.attr,
 fa.default_value,
 fa.attr_order,
  a.datatype
from
 qw_fn_attrs fa,
 qw_attrs a
where
 fa.fn_id = :fn_id
and
 a.object_id = :object_id
and
 fa.attr = a.attr
order by
 fa.attr_order" {

   lappend in_attrs $datatype
   lappend in_aliases "  p_${attr} alias for \$$i; -- default [DoubleApos $default_value]"
   
   if {[set index [lsearch $acs_object_attributes $attr]] > -1} {
     incr i
     lappend skip_attribute $attr
     continue
   } 
   lappend object_table_attrs $attr
   
   if {![string match $attr $key]} {
    lappend set_statements "
  if p_${attr} is not null
  then
   update $obj_table set $attr = p_${attr}
    where $key = p_${key};
  end if;"
     }
     
     incr i
 }
     #lappend in_aliases "  v_${key} ${obj_table}.${key}%TYPE; "
 
     regsub -all "p_${key}" "p_[join $object_table_attrs ", p_"]" "v_${key}" insert_vars

     switch $type {  
        1 {
           # type is new
           # new__object_id integer,
           # new__object_type character varying,
           # new__creation_date timestamp with time zone,
           # new__creation_user integer,
           # new__creation_ip character varying,
           # new__context_id integer,
           # new__security_inherit_p boolean,
           # new__title character varying,
           # new__package_id integer)
           if {[lsearch -exact $skip_attribute context_id] eq -1 
               && [lsearch -exact $object_table_attrs context_id] eq -1 
           } {
               ns_log Debug "context_id needs to be set to null"
               lappend in_aliases "  p_context_id acs_objects.context_id%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute creation_date] eq -1 
               && [lsearch -exact $object_table_attrs creation_date] eq -1 } {
               ns_log Debug "creation_date needs to be set to null"
               lappend in_aliases "  p_creation_date acs_objects.creation_date%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute creation_user] eq -1 
               && [lsearch -exact $object_table_attrs creation_user] eq -1 } {
               ns_log Debug "creation_user needs to be set to null"
               lappend in_aliases "  p_creation_user acs_objects.creation_user%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute creation_ip] eq -1 
               && [lsearch -exact $object_table_attrs creation_ip] eq -1 } {
               ns_log Debug "creation_ip needs to be set to null"
               lappend in_aliases "  p_creation_ip acs_objects.creation_ip%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute security_inherit_p] eq -1 
               && [lsearch -exact $object_table_attrs security_inherit_p] eq -1 } {
               ns_log Debug "security_inherit_p needs to be set to true"
               lappend in_aliases "  p_security_inherit_p acs_objects.security_inherit_p%TYPE = true;"
           }
           if {[lsearch -exact $skip_attribute title] eq -1 
               && [lsearch -exact $object_table_attrs title] eq -1 } {
               ns_log Debug "title needs to be set to null"
               lappend in_aliases "  p_title acs_objects.title%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute package_id] eq -1 
               && [lsearch -exact $object_table_attrs package_id] eq -1 } {
               ns_log Debug "package_id needs to be set to null"
               lappend in_aliases "  p_package_id acs_objects.package_id%TYPE = null;"
           }
          
           append pl " 
create or replace function $function_name ([join $in_attrs ", "]) 
returns integer as ' 
declare 
[join $in_aliases "\n"] 
  v_${key} ${obj_table}.${key}%TYPE;
begin 
  v_${key} := acs_object__new (  
    p_${key},  
    ''${object}'',  --p_object_type, 
    p_creation_date, 
    p_creation_user, 
    p_creation_ip, 
    p_context_id,
    p_security_inherit_p,
    p_title,
    p_package_id
  );   
  
  insert into $obj_table 
    ([join $object_table_attrs ", "]) 
  values
    ($insert_vars);

  return v_${key};

end;' language 'plpgsql';

"
       }
       2 {  
           
           if {[lsearch -exact $skip_attribute last_modified] eq -1 
               && [lsearch -exact $object_table_attrs creation_date] eq -1 } {
               ns_log Debug "last_modified needs to be set to null"
               lappend in_aliases "  p_last_modified acs_objects.last_modified%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute modifying_user] eq -1 
               && [lsearch -exact $object_table_attrs modifying_user] eq -1 } {
               ns_log Debug "modifying_user needs to be set to null"
               lappend in_aliases "  p_modifying_user acs_objects.modifying_user%TYPE = null;"
           }
           if {[lsearch -exact $skip_attribute modifying_ip] eq -1 
               && [lsearch -exact $object_table_attrs modifying_ip] eq -1 } {
               ns_log Debug "modifying_ip needs to be set to null"
               lappend in_aliases "  p_modifying_ip acs_objects.modifying_ip%TYPE = null;"
           }
           
         # Type is set 
         append pl "  
create or replace function $function_name ([join $in_attrs ", "])   
returns integer as ' 
declare 
[join $in_aliases "\n"] 
  v_return integer := 0; 
begin  
  if not ${object}__${object}_p(p_${key})
   then 
    return v_return; 
  end if; 
[join $set_statements "\n"]

  v_return := acs_object__update_last_modified(
   p_${key},
   p_modifying_user,
   p_modifying_ip,
   p_last_modified
  );
  
  return v_return;
end;' language 'plpgsql';

"

      } 
      3 {
        # Type is del 
        append pl "   
create or replace function ${object}__delete (integer) 
returns integer as ' 
declare 
 p_${key}    alias for \$1; 
 v_return integer := 0;  
begin 
  if not ${object}__${object}_p(p_${key})
   then 
    return v_return; 
  end if; 
  delete from acs_permissions 
     where object_id = p_${key}; 

  delete from $obj_table 
     where ${key} = p_${key};
  delete from acs_objects
     where object_id = p_${key};

  raise NOTICE ''Deleting ${object}...'';

  return v_return;

end;' language 'plpgsql';

"
        

      }
    }


 }

append pl "
-- Drop script for package
--
-- /packages/{package_name}/sql/postgresql/${object}-drop.sql
--
-- Drop 
--
-- @author ()
-- @creation-date ()
--

select drop_package('$object');
\t
drop table ${obj_table};

delete from acs_objects where object_type = '$object';

create function inline_0 () returns integer as '
begin
    PERFORM acs_object_type__drop_type (
     ''${object}'', ''f''
    );
    return null;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

"

set title "PG Create Script for $object"

set context [list "$title"]
