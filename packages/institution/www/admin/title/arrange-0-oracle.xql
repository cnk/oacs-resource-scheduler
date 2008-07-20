<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.0</version></rdbms>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-02-15 11:36 PST								 -->
	<!-- @cvs-id		$Id: arrange-0-oracle.xql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $												 -->
	<!--=====================================================================-->

	<!--
		Retrieves a list of subsite <name, id> which the personnel "belongs" to,
		either directly or indirectly.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-02-15 11:37 PST
	-->
	<fullquery name="personnel_subsite_list">
	 <querytext>
		select	distinct
				acs_object.name(spr.object_id_one)	as subsite_name,
				spr.object_id_one					as chosen_subsite_id,
				nvl(
					(select	count(*)
					   from	inst_subsite_psnl_obj_lists	spl,
							acs_objects					obj
					  where	spl.subsite_id		= spr.object_id_one
						and	spl.object_id		= obj.object_id
						and	spl.personnel_id	= :personnel_id
						and	obj.object_type		= 'inst_title'),
				0)									as n_arranged_for_subsite
		  from	acs_rels			spr,
				vw_group_member_map	gmm,
				groups				g
		 where	spr.rel_type		= 'subsite_for_party_rel'
		   and	spr.object_id_two	= g.group_id
		   and	g.group_id			= gmm.ancestor_id
		   and	gmm.child_id		= :personnel_id
		union
		select	'<i>Default</i>',
				to_number(:main_subsite_id),
				nvl(
					(select	count(*)
					   from	inst_subsite_psnl_obj_lists	spl,
							acs_objects					obj
					  where	spl.subsite_id		= :main_subsite_id
						and	spl.object_id		= obj.object_id
						and	spl.personnel_id	= :personnel_id
						and	obj.object_type		= 'inst_title'),
				0)									as n_arranged_for_subsite
		  from	dual
		 order	by subsite_name
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
