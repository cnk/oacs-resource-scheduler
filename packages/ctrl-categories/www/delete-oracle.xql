<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="category">
	 <querytext>
		select	c.category_id,
				c.parent_category_id,
				c.name,
				c.plural,
				c.description,
				decode(c.enabled_p, 'f', 'No', 'Yes') as enabled_p,
				c.profiling_weight,
				pc.name as parent_category_name,
				decode(acs_permission.permission_p(c.category_id, :user_id, 'read'),
						't', 1, 'f', 0) read_p,
				decode(acs_permission.permission_p(c.category_id, :user_id, 'write'),
						't', 1, 'f', 0) write_p,
				decode(acs_permission.permission_p(c.category_id, :user_id, 'create'),
						't', 1, 'f', 0) create_p,
				decode(acs_permission.permission_p(c.category_id, :user_id, 'delete'),
						't', 1, 'f', 0) delete_p,
				decode(acs_permission.permission_p(c.category_id, :user_id, 'admin'),
						't', 1, 'f', 0) admin_p,
				(select count(*)
				   from ctrl_categories c1
				  where parent_category_id = c.category_id) as n_children
		  from	ctrl_categories	c,
				ctrl_categories	pc
		 where	c.category_id			= :category_id
		   and	c.parent_category_id	= pc.category_id(+)
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="direct_subcategories_of">
	 <querytext>
		select	category_id
		  from	ctrl_categories
		 where	parent_category_id = :category_id
		   and	acs_permission.permission_p(category_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>

	<fullquery name="category_delete">
	 <querytext>
		begin
			ctrl_category.del(:category_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->