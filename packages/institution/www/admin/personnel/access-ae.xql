<?xml version="1.0"?>
<queryset>
	<fullquery name="access_personnel_details">
	 <querytext>
    	select	personnel_id,
				affinity_group_id as affinity_group_id_1,
				affinity_group_id_2,
				selected_pblctn_for_guide_id_1,
				selected_pblctn_for_guide_id_2,
				selected_pblctn_for_guide_id_3
    	  from	access_personnel
    	 where	personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_publications">
	 <querytext>
		select	year || ': ' || substr(pub.title,1,60) ||
				decode(substr(pub.title,61,1),
						null, '', '...') as title,
				pub.publication_id
		  from	inst_publications				pub,
				inst_personnel_publication_map	ppm
		 where	ppm.publication_id	= pub.publication_id
		   and	ppm.personnel_id	= :personnel_id
		 order	by publish_date desc, year desc, title
	 </querytext>
	</fullquery>

	<fullquery name="access_affinity_groups">
	 <querytext>
		select  lpad(' ', (level-1)*4*6 + 1, ' ') || short_name	as group_name,
				group_id
		  from	inst_groups
		connect	by parent_group_id		= group_id
		 start	with parent_group_id	= inst_group.lookup('//ACCESS//ACCESS Research Affinity Groups')
	 </querytext>
	</fullquery>

	<fullquery name="current_access_affinity_group_membership">
	 <querytext>
		select	parent_id
		  from	vw_group_member_map	gmm,
				acs_rels			rel
		 where	gmm.ancestor_id		= inst_group.lookup('//ACCESS//ACCESS Research Affinity Groups')
		   and	gmm.child_id		= :personnel_id
		   and	gmm.rel_id			= rel.rel_id
		   and	rel.object_id_one	= gmm.parent_id
		   and	rel.object_id_two	= :personnel_id
		   and	rel.rel_type		= 'membership_rel'
	 </querytext>
	</fullquery>

	<fullquery name="access_personnel_add">
	 <querytext>
		insert into access_personnel (
				personnel_id,
				selected_pblctn_for_guide_id_1,
				selected_pblctn_for_guide_id_2,
				selected_pblctn_for_guide_id_3
			) values (
				:personnel_id,
				:selected_pblctn_for_guide_id_1,
				:selected_pblctn_for_guide_id_2,
				:selected_pblctn_for_guide_id_3
		)
	 </querytext>
	</fullquery>

	<fullquery name="access_personnel_edit">
	 <querytext>
		update	access_personnel
		   set	selected_pblctn_for_guide_id_1	= :selected_pblctn_for_guide_id_1,
				selected_pblctn_for_guide_id_2	= :selected_pblctn_for_guide_id_2,
				selected_pblctn_for_guide_id_3	= :selected_pblctn_for_guide_id_3
		 where	personnel_id					= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="synchronize_access_affinity_group_membership">
	 <querytext>
		declare
			affinity_group_id_1			integer := null;
			affinity_group_id_2			integer := null;
			rel_id_1					integer := null;
			rel_id_2					integer := null;
		begin
			begin
				select	affinity_group_id,
						r1.rel_id,
						affinity_group_id_2,
						r2.rel_id
				  into	affinity_group_id_1,
						rel_id_1,
						affinity_group_id_2,
						rel_id_2
				  from	access_personnel	ap,
						acs_rels			r1,
						acs_rels			r2
				 where	ap.personnel_id			= :personnel_id
				   and	ap.affinity_group_id	= r1.object_id_one (+)
				   and	ap.affinity_group_id_2	= r2.object_id_one (+)
				   and	:personnel_id			= r1.object_id_two (+)
				   and	:personnel_id			= r2.object_id_two (+);
				exception when no_data_found then null;
			end;

			if nvl(:affinity_group_id_1, 0) <> nvl(affinity_group_id_1, 3) then
				if rel_id_1 is not null then
					-- delete stale membership
					membership_rel.delete(rel_id_1);
				end if;

				if :affinity_group_id_1 is not null then
					-- create new membership
					rel_id_1 := membership_rel.new(
						object_id_one	=> :affinity_group_id_1,
						object_id_two	=> :personnel_id
					);
				end if;
			end if;

			if nvl(:affinity_group_id_2, 0) <> nvl(affinity_group_id_2, 3) then
				if rel_id_1 is not null then
					-- delete stale membership
					membership_rel.delete(rel_id_2);
				end if;

				if :affinity_group_id_2 is not null then
					-- create new membership
					rel_id_2 := membership_rel.new(
						object_id_one	=> :affinity_group_id_2,
						object_id_two	=> :personnel_id
					);
				end if;
			end if;

			update	access_personnel
			   set	affinity_group_id				= :affinity_group_id_1,
					affinity_group_id_2				= :affinity_group_id_2
			 where	personnel_id					= :personnel_id;
		end;
	 </querytext>
	</fullquery>
</queryset>
