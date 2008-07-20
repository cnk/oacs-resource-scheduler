<?xml version="1.0"?>
<queryset>
	<!--=====================================================================-->
	<!-- @cvs-id		$Id$												 -->
	<!--=====================================================================-->
	<fullquery name="resource_list">
	 <querytext>
		select	crs.resource_id,
				crs.parent_resource_id,
				crs.name,
				crs.description,
				crs.resource_category_id,
				crs.resource_category_name,
				crs.enabled_p,
				crs.services,
				crs.property_tag,
				crs.package_id,
				crs.quantity,
				crs.owner_id,
				nvl((select	'Yes'
					 from	crs_reservable_resources resv
					 where	resv.resource_id = crs.resource_id),
					'No')
				as reservable_p
		from	crs_resources_vw crs
		where  parent_resource_id = :room_id
	 </querytext>
	</fullquery>

	<fullquery name="request_list">
	 <querytext>
		select	distinct
				cr.request_id,
				cr.name,
				cr.description,
				ce.status,
				cr.requested_by,
				(select	first_names || ' ' || last_name
				 from	persons
				 where	person_id=cr.reserved_by) as reserved_by,
				to_char(cte.start_date, 'MM/DD/YYYY ') || to_char(cte.start_date,'FMHH12') || to_char(cte.start_date,':MI AM') as start_date,
				to_char(cte.end_date, 'MM/DD/YYYY ') || to_char(cte.end_date,'FMHH12') || to_char(cte.end_date,':MI AM') as end_date,
				cte.start_date as sort_start_date,
				cte.event_id
		from	ctrl_events cte,
				crs_events ce,
				crs_requests cr
		where	cte.event_object_id	= :room_id
		and		cte.event_id		= ce.event_id
		and		ce.request_id		= cr.request_id
		order	by sort_start_date  desc
	 </querytext>
	</fullquery>

	<fullquery name="calendar_view">
	 <querytext>
		select	cal_id,
			cal_name,
			description
		from	ctrl_calendars
		where	object_id = :room_id
	 </querytext>
	</fullquery>

</queryset>
<!--	vim:set ts=4 sw=4 syntax=sql:	-->
<!--	Local Variables:				-->
<!--	mode:		sql					-->
<!--	tab-width:	4					-->
<!--	End:							-->
