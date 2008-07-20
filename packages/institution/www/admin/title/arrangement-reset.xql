<?xml version="1.0"?>
<queryset>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2005-07-25 10:38 PDT								 -->
	<!-- @cvs-id		$Id: arrangement-reset.xql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $												 -->
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
				   from	inst_subsite_psnl_obj_lists
				  where	personnel_id	= :personnel_id
					and	subsite_id		= :chosen_subsite_id)
	 </querytext>
	</fullquery>

	<!--
		Deletes the title-arrangments made for a particular personnel on a
		particular subsite.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2005-07-25 13:19 PDT
	-->
	<fullquery name="delete_arrangements_for_chosen_subsite">
	 <querytext>
		delete	from inst_subsite_psnl_obj_lists ol
		 where	personnel_id	= :personnel_id
		   and	subsite_id		= :chosen_subsite_id
		   and	(select	o.object_type
				   from	acs_objects	o
				  where	o.object_id	= ol.object_id)
				= 'inst_title'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->