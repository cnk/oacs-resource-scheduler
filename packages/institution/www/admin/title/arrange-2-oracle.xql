<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-03-09 15:43 PST								 -->
	<!-- @cvs-id		$Id: arrange-2-oracle.xql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $												 -->
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
		Creates a list of arranged titles for the chosen-subsite if there is no
		such list.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-09 17:53 PST
	-->
	<fullquery name="create_arranged_titles_if_not_exists">
	 <querytext>
		begin
			:1 := inst_subsite_psnl_obj_list.maybe_copy(
				subsite_id		=> :chosen_subsite_id,
				personnel_id	=> :personnel_id,
				object_type		=> 'inst_title'
			);
		end;
	 </querytext>
	</fullquery>

	<!--
		Insert the sitewide default ordering of titles.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-09 22:24 PST
	-->
	<fullquery name="sitewide_default_arranged_titles_insert">
	 <querytext>
		insert	into inst_subsite_psnl_obj_lists (
				subsite_id,
				personnel_id,
				object_id,
				relative_order,
				in_context_p
			)	select	:chosen_subsite_id,
						:personnel_id,
						gpm_title_id,
						rownum-1,
						't'
				  from	(select	gpm.gpm_title_id,
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
								categories					cs
						  where	r.object_id_two				= :personnel_id
							and	r.object_id_one				= g.group_id
							and	gpm.acs_rel_id				= r.rel_id
							and	gpm.title_id				= ct.category_id
							and	gpm.status_id				= cs.category_id (+)
							and	acs_permission.permission_p(gpm.gpm_title_id, :user_id, 'read') = 't'
						  order	by group_name, pretty_title, title
				) titles_list
	 </querytext>
	</fullquery>

	<!--
		Updates the relative-order and in-context-p attributes of an object in a list to reflect changes made in the UI.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-09 22:36 PST
	-->
	<fullquery name="update_or_insert_relative_order_and_in_context_p">
	 <querytext>
		begin
			update	inst_subsite_psnl_obj_lists
			   set	relative_order	= :relative_order,
					in_context_p	= :in_context_p
			 where	subsite_id		= :chosen_subsite_id
			   and	personnel_id	= :personnel_id
			   and	object_id		= :gpm_title_id;

			:1 := sql%rowcount;
			if sql%rowcount <= 0 then
				insert into inst_subsite_psnl_obj_lists (
						subsite_id,
						personnel_id,
						object_id,
						relative_order,
						in_context_p
					) values (
						:chosen_subsite_id,
						:personnel_id,
						:gpm_title_id,
						:relative_order,
						:in_context_p
				);

				:1 := sql%rowcount;
			end if;
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->