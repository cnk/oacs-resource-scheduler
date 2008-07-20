<?xml version=1.0?>
<queryset>
	<!-- START ctrl::cal::update.update -->
	<fullquery name="ctrl::cal::update.update">
	 <querytext>
		update	ctrl_calendars
		   set	$update_string
		 where	cal_id = :cal_id
	 </querytext>
	</fullquery>
	<!-- END ctrl::cal::update.update -->



	<!-- START ctrl::cal::remove.remove -->
	<fullquery name="ctrl::cal::remove.remove">
	 <querytext>
		begin
			ctrl_calendar.del (
				cal_id => :cal_id
			);
		end;
	 </querytext>
	</fullquery>
	<!-- END ctrl::cal::remove.remove -->
</queryset>
<!--	vim:set ts=4 sw=4 syntax=sql:	-->
<!--	Local Variables:				-->
<!--	mode:		sql					-->
<!--	tab-width:	4					-->
<!--	End:							-->
