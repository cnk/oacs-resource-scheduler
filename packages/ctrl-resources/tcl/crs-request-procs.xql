<?xml version="1.0"?>

<queryset>
   <fullquery name="crs::request::exists_p.exists_p">
      <querytext>
	select count(*) from crs_requests where request_id=:request_id
      </querytext>
   </fullquery>


   <fullquery name="crs::request::update_status.do_update">      
      <querytext>
	update crs_requests set status=:status where request_id=:request_id
      </querytext>
   </fullquery>

   <fullquery name="crs::request::update_status.do_event_update">      
      <querytext>
	update crs_events 
	set    status=:status 
	where  request_id=:request_id
      </querytext>
   </fullquery>

   <fullquery name="crs::request::get.get_info">
      <querytext>
	select	name,
		description,
		status,
		reserved_by as reserved_by_id,
		person.name(reserved_by) as reserved_by,
		requested_by,
	        to_char(requested_date,'yyyy-mm-dd hh24:mi') as requested_date
	from	crs_requests
	where	request_id =:request_id
      </querytext>
   </fullquery>

   <fullquery name="crs::request::update.update_request">
      <querytext>
	update	crs_requests
	set	name =:name,
		description =:description,
		status =:status,
		reserved_by =:reserved_by,
		requested_by =:requested_by
	where	request_id =:request_id
      </querytext>
   </fullquery>

   <fullquery name="crs::request::check_conflict.resv_exist_all_day_p">
      <querytext>
	select 1 from dual where exists (
             select 1 
             from   crs_events cre, ctrl_events ce
	     where cre.event_id = ce.event_id 
             and   cre.status = 'approved' 
             and   ce.event_object_id = :resv_resource_id 
             and   ce.start_date < to_date(:all_day_date,'yyyy-mm-dd')
             and   ce.end_date   >= to_date(:all_day_date,'yyyy-mm-dd') 
        )
         </querytext>
   </fullquery>

   <fullquery name="crs::request::check_conflict.resv_exist_p">
      <querytext>
	select 1 from dual where exists (
             select 1 
             from   crs_events cre, ctrl_events ce
	     where cre.event_id = ce.event_id 
             and   cre.status = 'approved' 
             and   ce.event_object_id = :resv_resource_id 
             and   ce.start_date < to_date(:end_date,'yyyy-mm-dd hh24:mi')
             and   ce.end_date   >= to_date(:start_date,'yyyy-mm-dd hh24:mi') 
        )
         </querytext>
   </fullquery>

   <fullquery name="crs::request::delete.get_events">
      <querytext>
	select  cte.event_id
	from    ctrl_events cte, crs_events cre, crs_requests crr
	where   crr.request_id = cre.request_id
	and     cre.event_id = cte.event_id
	and     crr.request_id = :request_id
      </querytext>
   </fullquery>

   <fullquery name="crs::request::get_room_for_request.get_room">
      <querytext>
	select room_id
	from crs_events_vw v,
		crs_rooms r
	where v.request_id=:request_id and
		v.event_object_id=r.room_id
       </querytext>
   </fullquery>

  <fullquery name="crs::request::get_non_room_resources.get_res">
      <querytext>
	select event_object_id
	from crs_events_vw v
	where v.request_id=:request_id and 
	      NOT EXISTS
	      (select 1
		from crs_rooms
		where room_id=v.event_object_id)

       </querytext>
   </fullquery>

   <fullquery name="crs::request::get_repeat_template_id.get_repeat_template_id">
   	<querytext>
   		select repeat_template_id from crs_requests where request_id = :request_id
        </querytext>
   </fullquery>


</queryset>
