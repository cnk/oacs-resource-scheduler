<?xml version=1.0?>
<queryset>

<fullquery name="crs::room::update.update_room">
<querytext>
   	update crs_rooms
	set $update_string
	where room_id = :room_id
</querytext>
</fullquery>

<fullquery name="crs::room::get.get">
<querytext>
	select  d.room_id,
		d.capacity,
                d.width,
                d.length,
                d.height,
		d.dimensions_width,
		d.dimensions_length,
		d.dimensions_height,
                d.dimensions_unit, 
		d.how_to_reserve,
		d.approval_required_p,
		d.address_id,
		d.department_id,
                d.room ,
                d.floor, 
		d.name,
		d.description,
		d.resource_category_id,
                d.resource_category_name,
		d.enabled_p,
		d.services,
		d.color,
                d.reservable_p,
                d.reservable_p_note,
                d.special_request_p,
		d.new_email_notify_list,
		d.update_email_notify_list,
		d.property_tag,
		d.package_id
	from crs_room_details d
        where room_id = :room_id 

</querytext>
</fullquery>

<fullquery name="crs::room::delete.get_images">
<querytext>
   	select image_id 
	from   crs_images
	where  resource_id = :room_id
</querytext>
</fullquery>

<fullquery name="crs::room::delete.get_events">
<querytext>
   	select event_id 
	from   ctrl_events
	where  event_object_id = :room_id
</querytext>
</fullquery>


<fullquery name="crs::room::is_room_p.check">
<querytext>
   	select 1
	from   crs_rooms
	where  room_id=:resource_id
</querytext>
</fullquery>

</queryset>


