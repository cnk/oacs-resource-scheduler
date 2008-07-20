<?xml version="1.0"?>
<queryset>
	<!--=====================================================================-->
	<!-- @author		Andrew Helsley (helsleya@cs.ucr.edu)				 -->
	<!-- @creation-date	2007-10-28 19:29 PDT								 -->
	<!-- @cvs-id		$Id$												 -->
	<!--=====================================================================-->

	<!--
		Returns a list of the names of the calendars that exist.  This list may
		be smaller than the input list in the case that not all exist.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2007-10-28 19:13 PDT
	-->
	<fullquery name="names_of_existing_calendars">
	 <querytext>
		select	cal_name
		  from	ctrl_calendars
		 where	cal_id		in ([join $calendars ","])
		   and	package_id	= :package_id
	 </querytext>
	</fullquery>

	<!--
		Returns the ids of all calendars.

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2007-10-28 19:29 PDT
	-->
	<fullquery name="all_calendars">
	 <querytext>
		select	cal_id	from ctrl_calendars	where package_id = :package_id
	 </querytext>
	</fullquery>
</queryset>

<!--	vim:set ts=4 sw=4 syntax=sql:	-->
<!--	Local Variables:				-->
<!--	mode:		sql					-->
<!--	tab-width:	4					-->
<!--	End:							-->
