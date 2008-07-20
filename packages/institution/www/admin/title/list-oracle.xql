<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="titles">
	 <querytext>
		select	gpm.gpm_title_id,
				gpm.acs_rel_id,
				r.object_id_two						as personnel_id,
				g.group_id,
				g.short_name						as group_name,
				gpm.title_id,
				ct.name								as title,
				gpm.pretty_title,
				gpm.status_id,
				cs.name								as status,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read'),
						't', 1, 0)					as read_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'write'),
						't', 1, 0)					as write_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'create'),
						't', 1, 0)					as create_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'delete'),
						't', 1, 0)					as delete_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'admin'),
						't', 1, 0)					as admin_p
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				inst_groups					g,
				categories					ct,
				categories					cs
		 where	gpm.gpm_title_id			in ($items)
		   and	gpm.acs_rel_id				= r.rel_id
		   and	r.object_id_one				= g.group_id
		   and	gpm.title_id				= ct.category_id
		   and	gpm.status_id				= cs.category_id (+)
		   and	r.object_id_two				= :personnel_id
		   and	acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read') = 't'
		 order	by group_name, pretty_title, title
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
