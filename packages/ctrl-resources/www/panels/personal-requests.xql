<?xml version="1.0"?>
<queryset> 

	<fullquery name="personal_events">
		<querytext>
			select v.event_id,
			       v.request_id,
			       v.status,
			       to_char(v.date_reserved,'Mon DD, YYYY') as date_reserved,
			       v.event_code,
			       v.event_object_id,
			       v.title,
			       to_char(v.start_date,'Mon DD, YYYY HH12:MI AM') as start_date,
			       to_char(v.end_date,'Mon DD, YYYY HH12:MI AM') as end_date,
			       v.all_day_p,
			       v.location,
			       v.notes,
			       v.capacity,
			       r.name as request_name,
			       r.description as request_description,
			       (select name from crs_resv_resources_vw where resource_id=v.event_object_id) as object_name,
                               obj.object_type ,
                               acs_permission.permission_p(r.request_id, :user_id, 'write') as write_p ,
                               acs_permission.permission_p(r.request_id, :user_id, 'delete') as delete_p 
			from crs_events_vw v,
			     crs_requests r ,
                             acs_objects obj, 
                             crs_resources res
			where v.request_id=r.request_id and obj.object_id = v.event_object_id  
                        and   r.package_id = :package_id and obj.object_type in ('crs_room','crs_reservable_resource') and res.resource_id = v.event_object_id and
                              res.parent_resource_id is null and 
			      r.reserved_by=:user_id $filter
			order by v.status, v.start_date
		</querytext>
	</fullquery>

</queryset>
