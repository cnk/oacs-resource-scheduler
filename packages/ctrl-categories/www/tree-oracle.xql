<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="max_visible_depth">
	 <querytext>
		select	nvl(max(level), 0)
		  from	ctrl_categories c
		 where	parent_category_id		in ([join $visible_expanded ","])
			or	category_id				in ($roots)
		 start	with category_id		in ($roots)
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="category_tree">
	 <querytext>
		select	c.category_id,
				c.parent_category_id,
				c.name,
				c.plural,
				c.description,
				c.profiling_weight,
				level,
				lpad(' ', level-1) as level_pad,
				(select count(*)
				   from ctrl_categories
				  where parent_category_id = c.category_id) as n_children,
				decode(acs_permission.permission_p(category_id, :user_id, 'read'),
						't', 1, 'f', 0) read_p,
				decode(acs_permission.permission_p(category_id, :user_id, 'write'),
						't', 1, 'f', 0) write_p,
				decode(acs_permission.permission_p(category_id, :user_id, 'create'),
						't', 1, 'f', 0) create_p,
				decode(acs_permission.permission_p(category_id, :user_id, 'delete'),
						't', 1, 'f', 0) delete_p,
				decode(acs_permission.permission_p(category_id, :user_id, 'admin'),
						't', 1, 'f', 0) admin_p
		  from	ctrl_categories	c
		 where	(parent_category_id		in ([join $visible_expanded ","])
				or	category_id			in ($roots))
		   and	acs_permission.permission_p(category_id,
											:user_id,
											'read') = 't'
		start	with category_id		in ($roots)
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>

	<fullquery name="category_descendants">
	 <querytext>
		select	distinct category_id as child_id
		  from	ctrl_categories
		 start	with category_id		= :r_category_id
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>

	<fullquery name="category_descendants_by_level">
	 <querytext>
		select	category_id, parent_category_id
		  from	ctrl_categories
		 start	with category_id		= :r_category_id
		connect	by prior category_id	= parent_category_id
		order	by level
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
