<?xml version="1.0"?>
<queryset>

  <fullquery name="get_private_cals">
         <querytext>
		select 	cal_id, 
			cal_name, 
			acs_permission.permission_p(cal_id,:user_id,'read') as read_p ,
                        acs_permission.permission_p(cal_id,:user_id,'admin') as admin_p ,
			description, 
			owner_id
		from 	ctrl_calendars 
                where   owner_id = :user_id and cal_id = object_id $and_filter_by
	 </querytext>
  </fullquery>

  <fullquery name="get_public_cals">
         <querytext>
		select 	cal_id, 
			cal_name, 
			description, 
			owner_id, 
			acs_permission.permission_p(cal_id,:user_id,'read') as read_p ,
                        acs_permission.permission_p(cal_id,:user_id,'admin') as admin_p 
		from 	ctrl_calendars 
                where   owner_id is null  and cal_id = object_id $and_filter_by
	 </querytext>
  </fullquery>

</queryset>

