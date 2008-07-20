<?xml version="1.0"?>
<queryset>

<fullquery name="crs::calendar::get.get">
  <querytext>
   select cc.cal_id, cc.cal_name, cc.description, cc.owner_id, cr.name as room_name
   from   ctrl_calendars cc, crs_resources cr
   where  cc.object_id = :room_id and
	  cr.resource_id = :room_id
  </querytext>
</fullquery>

<fullquery name="crs::calendar::get.calendar_exist_p">
  <querytext>
	select count(*)
        from ctrl_calendars cc, crs_resources cr
        where  cc.object_id = :room_id and
	       cr.resource_id = :room_id
  </querytext>
</fullquery>

</queryset>
