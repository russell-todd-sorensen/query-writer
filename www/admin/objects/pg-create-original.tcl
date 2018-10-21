ad_page_contract {

    Query Writer PG Create
    @author Tom Jackson <tom@junom.com>
    @creation-date 21 February 2002
    @cvs-id $Id: pg-create.tcl,v 1.4 2003/12/18 17:31:31 tom Exp $
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


create function ${object}__${object}_p (integer)
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

set acs_object_attributes [list object_type creation_date creation_user creation_ip context_id]

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
 active_p = '1'" { 
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
 attr_order" {

   lappend in_attrs $datatype
   lappend in_aliases "  p_${attr} alias for \$$i; -- default [DoubleApos $default_value]"

   if {[lsearch $acs_object_attributes $attr] > -1} {
     incr i
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
           append pl " 
create function $function_name ([join $in_attrs ", "]) 
returns integer as ' 
declare 
[join $in_aliases "\n"] 
  v_${key} ${obj_table}.${key}%TYPE; 
begin 
  v_${key} := acs_object__new (  
    p_${key},  
    p_object_type, 
    p_creation_date, 
    p_creation_user, 
    p_creation_ip, 
    p_context_id 
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
         # Type is set 
         append pl "  
create function $function_name ([join $in_attrs ", "])   
returns integer as ' 
declare 
[join $in_aliases "\n"] 
  v_return integer := 0; 
begin  
[join $set_statements "\n"]
  return v_return;
end;' language 'plpgsql';

"


      } 
      3 {
        # Type is del 
        append pl "   
create function ${object}__delete (integer) 
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
-- @cvs-id \$Id\$
--

select drop_package('$object');
\t
drop table ${obj_table};

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
