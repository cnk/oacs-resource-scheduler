<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-03-28 14:46 PST								 -->
	<!-- @cvs-id		$Id: pretty-list-oracle.xql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $												 -->
	<!--=====================================================================-->

	<!--
		Retrieves a list of titles in the order the user arranged them for the
		current site.  NOTE: although this is very similar to
		arrange-1-oracle:arranged_titles, a very important difference is that it
		does _not_ do an outer-join with the inst_subsite_psnl_obj_lists table.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-28 14:47 PST
	-->
	<fullquery name="spol_titles">
	 <querytext>
		select	titles_list.*, rownum-1		as rnmo from (
		select	gpm.gpm_title_id,
				gpm.acs_rel_id,
				r.object_id_two				as personnel_id,
				g.group_id,											--
				g.short_name				as group_name,			--
				gpm.title_id,										--
				nvl(pretty_title, ct.name)	as title,
				gpm.pretty_title,
				gpm.status_id,
				cs.name						as status,
				list.relative_order,
				list.in_context_p			as show_p,
				decode(cg.category_id,
						:hospital_category_id, 'Hospital Affiliations: ',
						:other_aff_lbl)		as group_affiliation_type,
				decode(cg.category_id,
						:hospital_category_id,1,
						0)					as hospital_p
		  from	inst_group_personnel_map	gpm,
				acs_rels					r,
				inst_groups					g,
				categories					ct,
				categories					cs,
				categories					cg,
				inst_subsite_psnl_obj_lists	list
		 where	list.subsite_id				= :subsite_id
		   and	list.personnel_id			= :personnel_id
		   and	list.object_id				= gpm.gpm_title_id
		   and	r.object_id_two				= list.personnel_id
		   and	r.object_id_one				= g.group_id
		   and	gpm.acs_rel_id				= r.rel_id
		   and	gpm.title_id				= ct.category_id
		   and	gpm.status_id				= cs.category_id (+)
		   and	(gpm.end_date				is null
				or gpm.end_date				> sysdate)
		   and	g.group_type_id				= cg.category_id
		   and	($filter)
		   and	acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read') = 't'
		 order	by list.relative_order, group_name, pretty_title, title
		) titles_list
	 </querytext>
	</fullquery>

	<!--
		Retrieves a list of a personnel\'s titles in the site-wide default order.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-28 14:49 PST
	-->
	<fullquery name="sitewide_default_titles">
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
				't'							as show_p,
				decode(cg.category_id,
						:hospital_category_id, 'Hospital Affiliations: ',
						:other_aff_lbl)		as group_affiliation_type,
				decode(cg.category_id,
						:hospital_category_id,1,
						0)					as hospital_p
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
		   and	($filter)
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

	<fullquery name="common_ancestors_p">
	 <querytext>
		-- //TODO// integrate 1/both of these into the above 2 queries so that
		-- "external" groups (those whose only common ancestor is the null
		-- group) will not be shown on their respective sites
		   and	exists						-- common ancestor
				(select	1
				   from	party_approved_member_map pamm1
				  where	pamm1.member_id	= g.group_id
					and	[subsite::parties_sql -only -root -groups -party_id {pamm1.party_id}])
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	party_approved_member_map pamm1
				  where	pamm1.member_id	= :group_id_1
					and	exists
						(select	1
						   from	party_approved_member_map pamm2
						  where	pamm2.party_id	= pamm1.party_id
							and	pamm2.member_id	= :group_id_2))
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->