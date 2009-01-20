create or replace view crs_room_details as
	select  rm.room_id,
		rm.dimensions_width || ' ' || dimensions_unit as width,
		rm.dimensions_length || ' ' || dimensions_unit as length,
		rm.dimensions_height || ' ' || dimensions_unit as height,
		rm.capacity,
		rm.dimensions_width,
		rm.dimensions_length,
		rm.dimensions_height,
                rm.dimensions_unit,
		r_res.how_to_reserve,
		r_res.approval_required_p,
		r_res.address_id,
		r_res.department_id,
                r_res.room ,
                r_res.floor, 
		r_res.name,
		r_res.color,
		r_res.description,
		r_res.resource_category_id,
                r_res.resource_category_name, 
		r_res.enabled_p,
		r_res.services,
		r_res.new_email_notify_list,
		r_res.update_email_notify_list,
		r_res.property_tag,
                r_res.owner_id,
                r_res.parent_resource_id,
		r_res.package_id,
                r_res.reservable_p,
                r_res.reservable_p_note,
                r_res.special_request_p
	from crs_rooms rm,
	     crs_resv_resources_vw r_res
	where rm.room_id= r_res.resource_id;


create or replace view crs_room_reserve_details as (
	select  e1.event_id,
		e1.request_id,
		e1.status,
		e1.reserved_by,
		e1.date_reserved,
		e1.event_code,
		e2.title,
		e2.start_date,
		e2.end_date,
		e2.all_day_p,
		e2.notes,
		rm.room_id,
		rm.name ,
                rm.package_id
	from crs_events e1,
	     ctrl_events e2,
	     crs_room_details rm
	where e1.event_id=e2.event_id and
	      rm.room_id=e2.event_object_id
);
