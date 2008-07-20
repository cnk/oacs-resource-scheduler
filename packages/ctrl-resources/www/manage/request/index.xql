<?xml version="1.0"?>
<queryset>
	<fullquery name="request_list">
		<querytext>
		select 	cr.request_id,
			initcap(cr.name) as name,
			initcap(cr.description) as description,
			initcap(cr.status) as status,
			cr.reserved_by,
			initcap(cr.requested_by) as requested_by,
			initcap(p.first_names ||' '|| p.last_name) as full_name
		from    crs_requests cr, persons p
		where	cr.reserved_by = p.person_id
		</querytext>
	</fullquery>
</queryset>
