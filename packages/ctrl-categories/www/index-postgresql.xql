<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="category">
	 <querytext>
		select	c.category_id,
				c.parent_category_id,
				c.name,
				c.plural,
				c.description,
				case 
                    when c.enabled_p = 'f' then 'No'
                    when c.enabled_p = 'f' then 'Yes'
                end as enabled_p,
				c.profiling_weight,
				pc.name as parent_category_name,
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'read') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'read') = 'f' then 0 
                end as read_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'write') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'write') = 'f' then 0 
                end as write_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'create') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'create') = 'f' then 0 
                end as create_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'delete') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'delete') = 'f' then 0 
                end as delete_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'admin') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'admin') = 'f' then 0 
                end as admin_p,           
                (select count(*)
                   from ctrl_categories c1
                  where parent_category_id = c.category_id) as n_children
           from ctrl_categories c left outer join ctrl_categories pc 
	         on (c.parent_category_id = pc.category_id)
          where c.category_id           = :category_id
            and acs_permission__permission_p(c.category_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="direct_subcategories_of">
	 <querytext>
		select	category_id
		  from	ctrl_categories
		 where	parent_category_id = :category_id
		   and	acs_permission__permission_p(category_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="default_root_categories">
	 <querytext>
		select	distinct c.category_id
		  from	ctrl_categories	c
		 where	c.parent_category_id	is null
		   and	acs_permission__permission_p(c.category_id,
											:user_id,
											'read') = 't'
	 </querytext>
	</fullquery>

</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
