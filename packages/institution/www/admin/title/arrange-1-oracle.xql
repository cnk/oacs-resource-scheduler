<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-02-15 11:49 PST								 -->
	<!-- @cvs-id		$Id: arrange-1-oracle.xql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $												 -->
	<!--=====================================================================-->

	<!--
		Retrieve the names of several important objects.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-02-15 11:49 PST
	-->
	<fullquery name="object_names">
	 <querytext>
		select	acs_object.name(:personnel_id)		as personnel_name,
				acs_object.name(:chosen_subsite_id)	as subsite_name
		  from	dual
	 </querytext>
	</fullquery>

	<!--
		Produce a list of a personnels active titles as they are ordered on a
		given subsite.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-09 12:11 PST
	-->
	<fullquery name="arranged_titles">
	 <querytext>
		select	titles_list.*, rownum-1		as rnmo from (
		select	gpm.gpm_title_id,
				gpm.acs_rel_id,
				r.object_id_two				as personnel_id,
				g.group_id,
				g.short_name				as group_name,
				gpm.title_id,
				nvl(pretty_title, ct.name)	as title,
				gpm.pretty_title,
				gpm.status_id,
				cs.name						as status,
				list.relative_order,
				decode(list.in_context_p, 't', 'true', 'false')	as show_p
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				inst_groups					g,
				categories					ct,
				categories					cs,
				(select	*
				   from	inst_subsite_psnl_obj_lists
				  where	personnel_id		= :personnel_id) list
		 where	gpm.gpm_title_id			= list.object_id (+)
		   and	list.subsite_id (+)			= inst_subsite_psnl_obj_list.best_subsite_id(
					:chosen_subsite_id,
					:personnel_id,
					'inst_title'
				)
		   and	r.object_id_two				= :personnel_id
		   and	r.object_id_one				= g.group_id
		   and	gpm.acs_rel_id				= r.rel_id
		   and	gpm.title_id				= ct.category_id
		   and	gpm.status_id				= cs.category_id (+)
		   and	(gpm.end_date				is null
				or gpm.end_date				> sysdate)
		   and	acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read') = 't'
		 order	by list.relative_order, group_name, gpm.pretty_title, title
		) titles_list
	 </querytext>
	</fullquery>

	<!--
		Retrieve the arranged list of active titles for the main site (the
		default list).

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-09 18:03 PST
	-->
	<fullquery name="sitewide_default_arranged_titles">
	 <querytext>
		select	titles_list.*, rownum-1		as rnmo from (
		select	gpm.gpm_title_id,
				gpm.acs_rel_id,
				r.object_id_two				as personnel_id,
				g.group_id,
				g.short_name				as group_name,
				gpm.title_id,
				nvl(pretty_title, ct.name)	as title,
				gpm.pretty_title,
				gpm.status_id,
				cs.name						as status,
				'true'						as show_p
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				inst_groups					g,
				categories					ct,
				categories					cs,
				categories					cg
		 where	r.rel_id					= gpm.acs_rel_id
		   and	r.object_id_one				= g.group_id
		   and	r.object_id_two				= :personnel_id
		   and	gpm.title_id				= ct.category_id
		   and	gpm.status_id				= cs.category_id (+)
		   and	(gpm.end_date				is null
				or gpm.end_date				> sysdate)
		   and	g.group_type_id				= cg.category_id
		   and	acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read') = 't'
		 order	by
				ct.profiling_weight,
				cg.profiling_weight,
				gpm.title_priority_number,
				gpm.pretty_title,
				ct.name,
				g.short_name
		) titles_list
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->