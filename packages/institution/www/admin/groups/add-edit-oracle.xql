<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="group">
	 <querytext>
		select	ig.*,
				g.*,
				p.*,
				pg.short_name	as parent_group_name,
				ag.short_name	as alias_group_name,
				c.name			as group_type_name,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_groups	ig,
				inst_groups	pg,
				inst_groups	ag,
				groups		g,
				parties		p,
				categories	c
		 where	ig.group_id				= g.group_id
		   and	ig.group_id				= p.party_id
		   and	ig.group_id				= :group_id
		   and	ig.parent_group_id		= pg.group_id(+)
		   and	ig.alias_for_group_id	= ag.group_id(+)
		   and	ig.group_type_id		= c.category_id
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="direct_subgroups_of">
	 <querytext>
		select	group_id
		  from	inst_groups
		 where	parent_group_id = :group_id
		   and	acs_permission.permission_p(group_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>

	<fullquery name="possible_parents">
	 <querytext>
		-- all groups except current group and descendants of current group
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || short_name as name,
				group_id,
				parent_group_id,
				short_name
		  from	inst_groups outer
		 where	$possible_parents_filter
		   and	([subsite::parties_sql -root -groups -party_id {outer.group_id}]
				or $existing_parent_p)
		   and	acs_permission.permission_p(group_id, :user_id, 'admin') = 't'
		connect by prior outer.group_id = outer.parent_group_id
		 start	with [subsite::parties_sql -only -root -groups -party_id {outer.group_id}]
	 </querytext>
	</fullquery>

	<partialquery name="possible_parents_filter__any">
	 <querytext>
				1 = 1
	 </querytext>
	</partialquery>

	<partialquery name="possible_parents_filter__no_descendants">
	 <querytext>
				not exists
				(select 1
				   from inst_groups inner
				  where inner.group_id = outer.group_id
				 connect by prior inner.group_id = inner.parent_group_id
				  start with inner.group_id = :group_id)
	 </querytext>
	</partialquery>

	<fullquery name="group_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1,  '&nbsp;') || name as name,
				category_id
		  from	categories
		 start	with parent_category_id = category.lookup('//Group Type')
		connect	by prior category_id = parent_category_id
	 </querytext>
	</fullquery>

	<fullquery name="type_info">
	 <querytext>
		select	pgt.name		as parent_group_type_name,
				pg.short_name	as parent_name,
				cgt.name		as sibling_group_type_name,
				ngt.name		as group_type_name
		  from	categories	pgt,
				categories	cgt,
				categories	ngt,
				inst_groups	pg,
				inst_groups	cg
		 where	pg.group_id		= cg.parent_group_id
		   and	pgt.category_id	= pg.group_type_id
		   and	cgt.category_id	= cg.group_type_id
		   and	ngt.category_id	= :group_type_id
		   and	pg.group_id		= :parent_group_id
		   and	cg.short_name	= :short_name
	 </querytext>
	</fullquery>

	<fullquery name="root_type_info">
	 <querytext>
		select	cgt.name		as sibling_group_type_name,
				ngt.name		as group_type_name
		  from	categories	cgt,
				categories	ngt,
				inst_groups	cg
		 where	cg.parent_group_id is null
		   and	cg.group_type_id	= cgt.category_id
		   and	cg.short_name		= :short_name
		   and	ngt.category_id		= :group_type_id
	 </querytext>
	</fullquery>

	<fullquery name="group_new">
	 <querytext>
		begin
			:1 := inst_group.new(
				type_id					=> :group_type_id,
				name					=> :group_name,
				short_name				=> :short_name,
				description				=> empty_clob(),
				keywords				=> :keywords,
				alias_for_group_id		=> :alias_for_group_id,
				creation_user			=> :user_id,
				creation_ip				=> :peer_ip,
				context_id				=> :package_id,
				group_priority_number	=> :group_priority_number
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="subgroup_new">
	 <querytext>
		begin
			:1 := inst_group.new(
				type_id					=> :group_type_id,
				name					=> :group_name,
				short_name				=> :short_name,
				description				=> empty_clob(),
				keywords				=> :keywords,
				parent_group_id			=> :parent_group_id,
				alias_for_group_id		=> :alias_for_group_id,
				creation_user			=> :user_id,
				creation_ip				=> :peer_ip,
				context_id				=> :parent_group_id,
				group_priority_number	=> :group_priority_number
			);
		end;
	 </querytext>
	</fullquery>

	<!-- used only when creating a new group -->
	<fullquery name="update_group_description">
	 <querytext>
		update		inst_groups
		   set		description	= empty_clob()
		 where		group_id	= :group_id
		returning	description into :1
	 </querytext>
	</fullquery>

	<fullquery name="reconcile_compositon_rels">
	 <querytext>
		declare
			cur_group_id		integer := :group_id;
			old_parent_group_id integer;
			new_parent_group_id integer := :parent_group_id;
			new_rel_id			integer;
		begin
			select	parent_group_id into old_parent_group_id
			  from	inst_groups
			 where	group_id = :group_id;

			if new_parent_group_id <> old_parent_group_id then
				if old_parent_group_id is not null then
					for r in (select	rel_id
								from	acs_rels
							   where	object_id_one	= old_parent_group_id
								 and	object_id_two	= cur_group_id
								 and	rel_type		= 'composition_rel') loop
						composition_rel.delete(r.rel_id);
					end loop;
				end if;

				if new_parent_group_id is not null then
					new_rel_id := composition_rel.new(
						object_id_one	=> new_parent_group_id,
						object_id_two	=> cur_group_id,
						creation_user	=> :user_id,
						creation_ip		=> :peer_ip
					);
				end if;
			end if;
		end;
	 </querytext>
	</fullquery>

	<fullquery name="group_edit">
	 <querytext>
		update		inst_groups
		   set		short_name				= :short_name,
					group_type_id			= :group_type_id,
					description				= empty_clob(),
					keywords				= :keywords,
					parent_group_id			= :parent_group_id,
					alias_for_group_id		= :alias_for_group_id,
					group_priority_number	= :group_priority_number
		 where		group_id				= :group_id
		returning	description into :1
	 </querytext>
	</fullquery>

	<fullquery name="acs_group_update">
	 <querytext>
		update	groups
		   set	group_name	= :group_name
		 where	group_id	= :group_id
	 </querytext>
	</fullquery>

	<fullquery name="object_modified">
	 <querytext>
		update	acs_objects
		   set	last_modified	= sysdate,
				modifying_user	= :user_id,
				modifying_ip	= :peer_ip,
				context_id		= :parent_group_id
		 where	object_id		= :group_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
