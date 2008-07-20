<?xml version=1.0?>
  <queryset>
	 
 <!-- START ctrl::cal::get.get -->
<fullquery name="crs::cal::setup::personal_initialize.user_calendar">
  <querytext>
   select nvl(max(cal_id),0)
   from ctrl_calendars
   where owner_id = :user_id and object_id  = :user_id
  </querytext>
</fullquery>
<!-- END ctrl::cal::get.get -->
 
 </queryset>
