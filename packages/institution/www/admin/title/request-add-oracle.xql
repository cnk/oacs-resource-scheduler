<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-03-08 15:47 PST								 -->
	<!-- @cvs-id		$Id: request-add-oracle.xql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $	 -->
	<!--=====================================================================-->

	<!--
		Retrieves basic information about personnel etc.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-03-08 16:09 PST
	-->
	<fullquery name="basic_info">
	 <querytext>
		select	acs_object.name(:personnel_id) as personnel_name
		  from	dual
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

</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->