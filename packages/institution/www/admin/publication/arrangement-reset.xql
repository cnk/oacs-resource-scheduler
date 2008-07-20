<?xml version="1.0"?>
<queryset>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-07-25 15:04 PDT								 -->
	<!-- @cvs-id		$Id: arrangement-reset.xql,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $												 -->
	<!--=====================================================================-->

	<!--
		Gets various details that are useful for display.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-07-25 10:39 PDT
	-->
	<fullquery name="details">
	 <querytext>
		select	acs_object.name(:personnel_id)		as personnel_name,
				acs_object.name(:chosen_subsite_id)	as subsite_name
		  from	dual
		 where	exists
				(select	1
				   from	inst_psnl_publ_ordered_subsets
				  where	personnel_id	= :personnel_id
					and	subsite_id		= :chosen_subsite_id)
	 </querytext>
	</fullquery>

	<!--
		Deletes the publication-arrangments made for a particular personnel on a
		particular subsite.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-07-25 13:19 PDT
	-->
	<fullquery name="delete_arrangements_for_chosen_subsite">
	 <querytext>
		delete	from inst_psnl_publ_ordered_subsets
		 where	personnel_id	= :personnel_id
		   and	subsite_id		= :chosen_subsite_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->