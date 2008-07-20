<?xml version="1.0"?>
<queryset>
    <fullquery name="resource_list">
        <querytext>
        select  crs.resource_id ,
                crs.name,
                crs.description,
                crs.resource_category_id,
                crs.resource_category_name, 
                crs.enabled_p,
                crs.services,
                crs.property_tag,
                crs.package_id , 
                crs.quantity,
                crs.owner_id  ,
                nvl((select 'Yes' from crs_reservable_resources resv where resv.resource_id = crs.resource_id),'No') as reservable_p
        from crs_resources_vw crs 
        where  parent_resource_id = :room_id 
        </querytext>
    </fullquery>

    <fullquery name="request_list">
        <querytext>
        select  distinct cr.*
	from    ctrl_events cte, crs_events ce, crs_requests cr
        where  	cte.event_object_id = :room_id and 
		cte.event_id = ce.event_id and
		ce.request_id = cr.request_id
	order by cr.request_id
        </querytext>
    </fullquery>

    <fullquery name="calendar_view">
	<querytext>
	select	cal_id as calendar_id,
		cal_name,
		description
	from	ctrl_calendars
	where	object_id = :room_id
	</querytext>
    </fullquery>

</queryset>
