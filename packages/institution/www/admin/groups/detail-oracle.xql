<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="group">
	 <querytext>
		select	ig.*,
				g.*,
				p.*,
				pg.short_name							as parent_group_name,
				ag.short_name							as alias_group_name,
				c.name									as group_type_name,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'read'),
						't', 1, 0)					as read_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'write'),
						't', 1, 0)					as write_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'create'),
						't', 1, 0)					as create_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'delete'),
						't', 1, 0)					as delete_p,
				decode(acs_permission.permission_p(ig.group_id, :user_id, 'admin'),
						't', 1, 0)					as admin_p,
				(select count(*)
				   from inst_groups g1
				  where parent_group_id = g.group_id)	as n_children,
				to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(o.creation_date, 'hh:miam')		as created_at,
				person.name(o.creation_user)			as created_by,
				o.creation_ip							as created_from,
				to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(o.last_modified, 'hh:miam')		as modified_at,
				person.name(o.modifying_user)			as modified_by,
				o.modifying_ip							as modified_from
		  from	inst_groups	ig,
				inst_groups	pg,
				inst_groups	ag,
				groups		g,
				parties		p,
				categories	c,
				acs_objects	o
		 where	ig.group_id				= g.group_id
		   and	ig.group_id				= p.party_id
		   and	ig.group_id				= :group_id
		   and	ig.parent_group_id		= pg.group_id(+)
		   and	ig.alias_for_group_id	= ag.group_id(+)
		   and	ig.group_type_id		= c.category_id
		   and	ig.group_id				= o.object_id
	 </querytext>
	</fullquery>

	<fullquery name="direct_subgroups_of">
	 <querytext>
		select	group_id
		  from	inst_groups g
		 where	parent_group_id = :group_id
		   and	acs_permission.permission_p(group_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>

	<fullquery name="group_addresses">
	 <querytext>
		select	ga.address_id
		  from	inst_party_addresses ga
		 where	ga.party_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_emails">
	 <querytext>
		select	ge.email_id
		  from	inst_party_emails ge
		 where	ge.party_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_urls">
	 <querytext>
		select	gu.url_id
		  from	inst_party_urls gu
		 where	gu.party_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_phones">
	 <querytext>
		select	gp.phone_id
		  from	inst_party_phones gp
		 where	gp.party_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_certifications">
	 <querytext>
		select	gc.certification_id
		  from	inst_certifications gc
		 where	gc.party_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_personnel">
	 <querytext>
		select	distinct ip0.personnel_id
		  from	inst_personnel				ip0,
				group_distinct_member_map	gdmm
		 where	ip0.personnel_id	= gdmm.member_id
		   and	gdmm.group_id		= :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_images">
	 <querytext>
		select	gi.image_id
		  from	inst_party_images gi
		 where	gi.party_id = :group_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
