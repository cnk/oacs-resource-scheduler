<?xml version=1.0?>
<queryset>

<fullquery name="crs::resource::get.get">
<querytext>
        select 	a.name, 
               	a.description,
               	a.resource_category_id, a.resource_category_name ,
               	a.enabled_p, 
		services, 
		a.property_tag,
               	quantity, owner_id, 
		a.parent_resource_id,
               	decode(b.approval_required_p,'','f',b.approval_required_p) approval_required_p,
		b.color,
                b.reservable_p, b.reservable_p_note, b.special_request_p
        from   crs_resources_vw a, crs_reservable_resources b
	where  a.resource_id = :resource_id
        and    b.resource_id (+) = a.resource_id
</querytext>
</fullquery>


<fullquery name="crs::resource::update.update_resource">
<querytext>
   	update crs_resources
	set $update_string
	where resource_id = :resource_id
</querytext>
</fullquery>


<fullquery name="crs::reservable_resource::update.update_reservable_resource">
<querytext>
   	update crs_reservable_resources
	set $update_string_2
	where resource_id = :resource_id
</querytext>
</fullquery>

<fullquery name="crs::reservable_resource::get.get">
<querytext>
        select 	cv.name, 
               	cv.description,
               	cv.resource_category_id,
               	cv.resource_category_name,
               	cv.enabled_p, 
               	cv.services, 
               	cv.property_tag,
               	cv.how_to_reserve,
	       	decode(cv.approval_required_p ,'t',1,0) as approval_required_p,
               	cv.address_id,
               	ctrl_category.name(department_id) as department,
                cv.department_id, 
               	cv.floor,
               	cv.room,
               	cv.gis ,
		cv.color ,
                cv.reservable_p,
                cv.reservable_p_note,
                cv.special_request_p,
               	acs_object.name(cv.owner_id) as owner,
               	cv.parent_resource_id,
               	cv.quantity,
		ca.address_line_1,
		ca.address_line_2,
		ca.address_line_3,
		ca.city,
		ctrl_category.name(ca.building_id) as building,
		cv.new_email_notify_list,
		cv.update_email_notify_list,
		cv.approval_required_p
        from   	crs_resv_resources_vw cv,
		ctrl_addresses ca	
	where  	cv.resource_id = :resource_id
	and	cv.address_id = ca.address_id(+)
</querytext>
</fullquery>


<fullquery name="crs::resource::delete.delete_reservable">
<querytext>
   	delete from ctrl_resources_reservable
	where resource_id = :resource_id
</querytext>
</fullquery>

<fullquery name="crs::resource::map.add_resource_map">
<querytext>
   	insert into ctrl_resources_resource_map (
		parent_resource_id, child_resource_id)
	values (:parent_resource_id, :child_resource_id)
</querytext>
</fullquery>

<fullquery name="crs::resource::search.search">
<querytext>
   	select resource_id
	from ctrl_resources
	$where_string
</querytext>
</fullquery>

<fullquery name="crs::resource::add_image.image_upload">
<querytext>
	update crs_images 
	set    image = empty_blob()
	where  image_id = :image_id
	returning image into :1
</querytext>
</fullquery>

<fullquery name="crs::reservable_resource::delete.get_images">
<querytext>
   	select image_id 
	from   crs_images
	where  resource_id = :resource_id
</querytext>
</fullquery>

<fullquery name="crs::resource::delete.get_images">
<querytext>
   	select image_id 
	from   crs_images
	where  resource_id = :resource_id
</querytext>
</fullquery>

<fullquery name="crs::resource::get_ctrl_addresses.get_address_lists">
<querytext>
	select address_id, description, address_line_1
	from   ctrl_addresses
</querytext>
</fullquery>

<fullquery name="crs::resource::find_child_resources.get_child_resources">
	<querytext>
	select resource_id
	from   crs_resv_resources_vw
	where parent_resource_id=:resource_id
	</querytext>
</fullquery>

<fullquery name="crs::reservable_resource::check_availability.check">
	<querytext>
	select 0 
	from dual
	where exists (select 1
		      from crs_events_vw
		      where event_object_id=:resource_id and
                           ((start_date < $end_date and $end_date <= end_date) or
                             (start_date <= $start_date and $start_date < end_date ) or
                             ($start_date < start_date and end_date < $end_date )) and
			    status != 'cancelled' and
			    status != 'denied' $event_clause $template_clause) 
	</querytext>
</fullquery>



</queryset>



