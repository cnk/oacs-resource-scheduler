<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="title">
	 <querytext>
		select	gpm.gpm_title_id,
				gpm.acs_rel_id,
				g.group_id,
				g.short_name							as group_name,
				gt.name									as group_type,
				gpm.title_id,
				ct.name									as title,
				gpm.pretty_title,
				gpm.status_id,
				cs.name									as status,
				nvl(pretty_title, ct.name)				as description,
				r.object_id_two							as personnel_id,
				person.name(r.object_id_two)			as owner_name,
				decode(leader_p, 't', 'Yes', 'No')		as leader_p,
				start_date,
				end_date,
				title_priority_number,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read'),
						't', 1, 0)						as read_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'write'),
						't', 1, 0)						as write_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'create'),
						't', 1, 0)						as create_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'delete'),
						't', 1, 0)						as delete_p,
				decode(acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'admin'),
						't', 1, 0)						as admin_p,
				to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(o.creation_date, 'hh:miam')		as created_at,
				person.name(o.creation_user)			as created_by,
				o.creation_ip							as created_from,
				to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(o.last_modified, 'hh:miam')		as modified_at,
				person.name(o.modifying_user)			as modified_by,
				o.modifying_ip							as modified_from
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				acs_objects					o,
				inst_groups					g,
				categories					ct,
				categories					cs,
				categories					gt
		 where	gpm.gpm_title_id			= :gpm_title_id
		   and	gpm.acs_rel_id				= r.rel_id
		   and	r.rel_id					= o.object_id
		   and	r.object_id_one				= g.group_id
		   and	g.group_type_id				= gt.category_id
		   and	gpm.title_id				= ct.category_id
		   and	gpm.status_id				= cs.category_id (+)
	 </querytext>
	</fullquery>

	<fullquery name="title_delete">
	 <querytext>
		declare
			acs_rel_id			integer;
			n_titles_using_rel	integer;
		begin
			select	acs_rel_id,
					count(*)
			  into	acs_rel_id,
					n_titles_using_rel
			  from	inst_group_personnel_map	gpm
			 where	gpm.acs_rel_id =
					(select	igpm.acs_rel_id
					   from	inst_group_personnel_map	igpm
					  where	igpm.gpm_title_id	= :gpm_title_id)
			 group	by acs_rel_id;

			if n_titles_using_rel > 0 then
				inst_title.delete(:gpm_title_id);
			end if;

			if n_titles_using_rel <= 1 then
				membership_rel.delete(acs_rel_id);
			end if;
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
