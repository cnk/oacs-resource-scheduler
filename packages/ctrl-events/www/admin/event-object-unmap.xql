<?xml version="1.0"?>
<queryset>
        <fullquery name="mapped_events_for_event_object_id">
        <querytext>
		select e.title || ' (' || to_char(e.start_date, 'Mon DD, YYYY HH12:MM am') || ')' title, e.event_id
		from ctrl_events e,
		     ctrl_events_event_object_map m
		where e.event_id = m.event_id
		and m.event_object_id = :event_object_id
		order by title
        </querytext>
        </fullquery>

        <fullquery name="mapped_events_for_event_id">
        <querytext>
		select o.name || ' ' || o.last_name || ' (' || c.name || ')', o.event_object_id, c.name, o.name
		from ctrl_events_objects o,
		     ctrl_events_event_object_map m,
		     categories c
		where o.event_object_id = m.event_object_id
		and c.category_id = o.object_type_id
		and m.event_id = :event_id
		order by c.name, o.name
        </querytext>
        </fullquery>
</queryset>

