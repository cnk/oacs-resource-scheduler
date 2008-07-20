<?xml version="1.0"?>
<queryset>
    <fullquery name="resources_in_room">
        <querytext>
	     select count(*)
	     from   crs_resources_vw crs
             where  parent_resource_id = :room_id
        </querytext>
    </fullquery>

    <fullquery name="requests_in_room">
        <querytext>
        select  count(*)
	from    ctrl_events cte, crs_events ce, crs_requests cr
        where  	cte.event_object_id = :room_id and 
		cte.event_id = ce.event_id and
		ce.request_id = cr.request_id
        </querytext>
    </fullquery>

    <fullquery name="images_in_room">
        <querytext>
	select	count(*)
	from	crs_images
	where	resource_id = :room_id
        </querytext>
    </fullquery>

</queryset>
