<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!--
		Returns details about the title, personnnel, group, and user who is
		requesting the change be made.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2004-12-09 13:36 PST
	-->
	<fullquery name="title_details">
	 <querytext>
		select	gpm.gpm_title_id,
				ar.object_id_two					as personnel_id,
				acs_object.name(ar.object_id_two)	as personnel_name,
				psn.email							as personnel_email,
				gpm.acs_rel_id,
				gpm.title_id,
				grp.group_id,
				grp.group_type_id,
				grp.short_name						as group_name,
				gt.name								as group_type,
				t.name								as title,
				acs_object.name(:user_id)			as user_name,
				usr.email							as user_email,
				decode(acs_permission.permission_p(psn.party_id, :user_id, 'admin'),
						't', 1, 0)				as admin_p
		  from	inst_group_personnel_map	gpm,
				inst_groups					grp,
				acs_rels					ar,
				categories					t,
				categories					gt,
				parties						psn,
				parties						usr
		 where	ar.object_id_one	= grp.group_id
		   and	ar.object_id_two	= psn.party_id
		   and	ar.rel_id			= gpm.acs_rel_id
		   and	t.category_id		= gpm.title_id
		   and	gt.category_id		= grp.group_type_id
		   and	usr.party_id		= :user_id
		   and	((gpm.gpm_title_id	= :gpm_title_id)
				or
				 (gpm.title_id			= :title_id
				  and	gpm.acs_rel_id	= :acs_rel_id))
	 </querytext>
	</fullquery>

	<!--
		Returns details on the user and personnel for when the user wants a title
		created.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2004-12-11 21:09 PST
	-->
	<fullquery name="observer_details">
	 <querytext>
		select	psn.party_id					as personnel_id,
				acs_object.name(:personnel_id)	as personnel_name,
				psn.email						as personnel_email,
				acs_object.name(:user_id)		as user_name,
				usr.email						as user_email,
				decode(acs_permission.permission_p(psn.party_id, :user_id, 'admin'),
						't', 1, 0)			as admin_p
		  from	parties				psn,
				parties				usr
		 where	usr.party_id		= :user_id
		   and	psn.party_id		= :personnel_id
	 </querytext>
	</fullquery>

	<!--
		Returns a tree of titles which the user can request be added for the
		personnel.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2004-12-10 23:10 PST
	-->
	<fullquery name="possible_titles">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id,
				parent_category_id,
				name
		  from	categories
		start	with parent_category_id	= category.lookup('//Personnel Title')
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>


	<!--
		Returns a tree of subsite-groups from which the user can request a title
		for the personnel be added.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2004-12-10 23:54 PST
	-->
	<fullquery name="subsite_groups">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || short_name as name,
				group_id,
				parent_group_id,
				short_name
		  from	inst_groups g
		 where	[subsite::parties_sql -groups -party_id {g.group_id}]
		   and	acs_permission.permission_p(g.group_id, :user_id, 'read') = 't'
		connect	by prior group_id = parent_group_id
		 start	with [subsite::parties_sql -only -trunk -groups -party_id {g.group_id}]
	 </querytext>
	</fullquery>

	<!--
		Returns a set of rows with 'Name' and 'ID' of group administrators to
		contact.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2004-12-09 14:36 PST
	-->
	<fullquery name="group_administrative_contacts">
	 <querytext>
		select	'Andrew Helsley, CTRL'	as name,
				392						as user_id
		  from	dual
	--	union
	--	select	'Andy Helsley, CTRL'	as name,
	--			'ahelsleya@acm.org'		as email
	--	  from	dual
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
