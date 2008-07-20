<?xml version="1.0"?>
<queryset>
	<!-- subsite::for_any_party_p ########################################## -->
	<fullquery name="subsite::for_any_party_p.root_parties_exist_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	acs_rels
				  where	rel_type		= 'subsite_for_party_rel'
					and	object_id_one	= :subsite_id)
	 </querytext>
	</fullquery>

	<!-- subsite::parties_sql ############################################## -->
	<fullquery name="subsite::parties_sql.only_root_groups">
	 <querytext>
		0

		null
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.has_a_non_expired_title_p">
	 <querytext>
		exists
		(select	1
		   from	inst_group_personnel_map	$gpm
		  where	$gpm.acs_rel_id	= $rels.rel_id
			and	start_date		< sysdate
			and	(end_date		is null
				or end_date		> sysdate))
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.only_trunk_groups">
	 <querytext>
		[select	$grp.group_id	as group_id]
		  from	inst_groups		$grp
		 where	parent_group_id	is null
		   and	$grp.group_id	= [$group_id_or_same_group_id]
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_dne__all_groups">
	 <querytext>
		1 = 1

		select	group_id
		 from	inst_groups
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_dne__only_root_personnel">
	 <querytext>
		select	personnel_id
		  from	inst_personnel
		 where	not exists
				(select	1
				   from	vw_group_member_map	gmm,
						inst_groups			grp
				  where	gmm.ancestor_id		= grp.group_id
					and	gmm.child_id		= personnel_id)
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_exist__all">
	 <querytext>
		$select_object_id_two_or_1_sql
		  from	vw_group_component_map	$gcm,
				acs_rels				$rel
		 where	$gcm.ancestor_id		= $rel.object_id_two
		   and	$rel.object_id_one		= :subsite_id
		   and	$gcm.object_id_two		= $group_id_or_object_id_two
		$union_sql
		$select_child_or_1_sql
		  from	vw_group_component_map	$gcm,
				acs_rels				$rel
		 where	$gcm.ancestor_id		= $rel.object_id_two
		   and	$rel.object_id_one		= :subsite_id
		   and	$gcm.child_id			= $group_id_or_child_id
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_exist__trunks_and_lower">
	 <querytext>
		$select_child_or_1_sql
		  from	vw_group_component_map	$gcm,
				acs_rels				$rel
		 where	$gcm.ancestor_id		= $rel.object_id_two
		   and	$rel.object_id_one		= :subsite_id
		   and	$gcm.child_id			= $group_id_or_child_id
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_exist__trunks">
	 <querytext>
		$select_child_or_1_sql
		  from	vw_group_component_map	$gcm,
				acs_rels				$rel
		 where	$gcm.ancestor_id		= $rel.object_id_two
		   and	$rel.object_id_one		= :subsite_id
		   and	$gcm.ancestor_id		= $gcm.parent_id
		   and	$gcm.child_id			= $group_id_or_child_id
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_exist__roots">
	 <querytext>
		$select_object_id_two_or_1_sql
		  from	acs_rels				$rel,
				groups					$grp
		 where	$rel.object_id_one		= :subsite_id
		   and	$rel.object_id_two		= $grp.group_id
		   and	$gcm.object_id_two		= $group_id_or_object_id_two
	 </querytext>
	</fullquery>

	<fullquery name="subsite::parties_sql.ssp_exist__roots_and_trunks">
	 <querytext>
		$select_child_or_1_sql
		  from	vw_group_component_map	$gcm,
				acs_rels				$rel
		 where	$gcm.ancestor_id		= $rel.object_id_two
		   and	$rel.object_id_one		= :subsite_id
		   and	$gcm.ancestor_id		= $gcm.parent_id
		   and	$gcm.child_id			= $group_id_or_child_id
		$union_sql
		$select_object_id_two_or_1_sql
		  from	acs_rels				$rel,
				groups					$grp
		 where	$rel.object_id_one		= :subsite_id
		   and	$rel.object_id_two		= $grp.group_id
		   and	$gcm.object_id_two		= $group_id_or_object_id_two
	 </querytext>
	</fullquery>

	<!-- ################################################################### -->
	<!-- AMK hack put in 6/8/05 to temp. take care of neuroscience bug		 -->
	<!-- ACH: for now the only implication of the aforementioned hack is that
			groups created from www/admin/index using the 'Add a New Top-Level
			Group' link will always use the first party found below.  As of
			2005/06/08 www/admin/index.tcl is the only place this proc is
			called from.													 -->
	<fullquery name="subsite::party_group_id.subsite_group_id">
	 <querytext>
		select	object_id_two
		  from	acs_rels
		 where	rel_type		= 'subsite_for_party_rel'
		   and	object_id_one	= :subsite_id
		   and  rownum <= 1
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
