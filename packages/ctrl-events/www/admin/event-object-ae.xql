<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
        <fullquery name="get_object_data">
                <querytext>	
			select event_object_id, name, last_name, object_type_id, description, url 
			from ctrl_events_objects
			where event_object_id = :event_object_id
		</querytext>
	</fullquery>
</queryset>
