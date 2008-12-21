<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_event_object">
		<querytext>
			select	o.event_object_id, o.name || ' ' || o.last_name name, c.name as object_type, o.description, o.url
			from 	ctrl_events_objects o, categories c
			where event_object_id = :event_object_id and o.object_type_id = c.category_id
		</querytext>
	</fullquery>

        <fullquery name="get_mapped_events">
                <querytext>
                        select e.title, e.location, c.name, m.tag, m.event_object_group_id,
                               to_char(e.start_date, 'Mon DD, YYYY HH12:MI am') as start_date,
                               to_char(e.end_date, 'Mon DD, YYYY HH12:MI am') as end_date
                        from ctrl_events e,
                             categories c,
                             ctrl_events_event_object_map m,
                             acs_objects a
                        where a.object_id = e.event_id
                        and   a.context_id = :package_id
                        and   e.category_id = c.category_id(+)
                        and   e.event_id = m.event_id
                        and   m.event_object_id = :event_object_id
                </querytext>
        </fullquery>

</queryset>
