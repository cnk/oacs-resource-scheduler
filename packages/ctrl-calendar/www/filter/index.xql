<?xml version="1.0"?>
<queryset>
	<!--
		(Documentation not provided)

		@author			Andrew Helsley (helsleya@cs.ucr.edu)
		@creation-date	2007-10-28 22:08 PDT
	-->
	<fullquery name="get_cal_filters">
	 <querytext>
		select	f.filter_name,
				f.description,
				f.cal_filter_id
		  from	ctrl_calendar_filters	f,
				acs_objects				o
		 where	f.cal_filter_id	= o.object_id
				$filter_sql
		 order	by f.filter_name
	 </querytext>
	</fullquery>
</queryset>
