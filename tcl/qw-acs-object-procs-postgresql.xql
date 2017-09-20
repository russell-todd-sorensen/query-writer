<?xml version="1.0"?>
<queryset>
<fullquery name="acs_object::new.new_object">      
      <querytext>
      select acs_object__new(
        :object_id,
        :object_type,
        :creation_date,
        :creation_user,
        :creation_ip,
        :context_id,
        :security_inherit_p
	) as new_object_id;
      </querytext>
</fullquery>

<fullquery name="acs_object::delete.delete_object">      
      <querytext>
      select acs_object__delete(
        :object_id
       );
      </querytext>
</fullquery>

<fullquery name="acs_object::update.update_object">      
      <querytext>
     update 
      acs_objects 
     set 
      [join $attrs ",\n "] 
     where 
      object_id = :object_id
      </querytext>
</fullquery>

</queryset>
