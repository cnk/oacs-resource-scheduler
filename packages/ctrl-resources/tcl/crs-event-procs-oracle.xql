<?xml version="1.0"?>

<queryset>
    
    <fullquery name="crs::event::new.new_event">      
      <querytext>
       begin
          :1 := crs_event.new (
		event_id => :event_id,
		request_id => :request_id,
		status => :status,
		reserved_by => :reserved_by,
		event_code => :event_code
		);
      end;
      </querytext>
   </fullquery>	

    <fullquery name="crs::event::delete.do_delete">      
      <querytext>
      begin
           crs_event.del (
			event_id		=> :event_id
		);
      end;
      </querytext>
   </fullquery>

   <fullquery name="crs::event::update_status.do_update">      
      <querytext>
	update crs_events set status=:status where event_id=:event_id
      </querytext>
   </fullquery>

   <fullquery name="crs::event::update.do_update">      
      <querytext>
	update crs_events_vw set $update_string where event_id=:event_id
      </querytext>
   </fullquery>

</queryset>
