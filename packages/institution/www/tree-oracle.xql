<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="max_visible_depth">
	 <querytext>
		select	nvl(max(level), 0)
		  from	inst_groups g
		 where	$depth_filter
			or	parent_group_id		in ([join $visible_expanded ","])
			or	group_id			in ($roots)
		 start	with group_id		in ($roots)
		connect	by prior group_id	= parent_group_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="group_tree">
	 <querytext>
		select	group_id,
				parent_group_id,
				short_name,
				level,
				lpad(' ', level-1) as level_pad,
				(select count(*)
				   from inst_groups
				  where parent_group_id = g.group_id) as n_children
		  from	inst_groups	g
		 where	($depth_filter
				or	parent_group_id		in ([join $visible_expanded ","])
				or	group_id			in ($roots))
		   and	acs_permission.permission_p(group_id,
											:user_id,
											'read') = 't'
		start	with group_id		in ($roots)
		connect	by prior group_id	= parent_group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_descendants">
	 <querytext>
		select	distinct group_id as child_id
		  from	inst_groups g
		 start	with group_id		= :r_group_id
		connect	by prior group_id	= parent_group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_descendants_by_level">
	 <querytext>
		select	group_id, parent_group_id
		  from	inst_groups g
		 start	with group_id		= :r_group_id
		connect	by prior group_id	= parent_group_id
		order	by level
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
