

if [template::util::is_nil event_id]     {set event_id 0}

set selection [db_0or1row get_event_data {
		select	e.event_id,
			acs_object.name(e.event_object_id) as event_object_id,
			c.name as category_id,
			e.repeat_template_id,
			e.repeat_template_p,
			e.title,
			to_char(e.start_date, 'Month DD, YYYY HH12:MI AM') as event_start_date,
			to_char(e.end_date, 'Month DD, YYYY HH12:MI AM') as event_end_date,
			e.all_day_p,
			e.location,
			e.notes,
			e.capacity
		from 	ctrl_events e, ctrl_categories c
		where e.event_id = :event_id and e.category_id = c.category_id
}]

set event_image_display ""

ad_form -name "event_box" -method {-post} -form {
    {event_id:key}
    {title:text(inform) {label "Event Title:"} optional}
    {event_object_id:text(inform) {label "Event Object:"} optional}
    {category_id:text(inform) {label "Category:"} optional}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {location:text(inform) {label "Location: "} optional}
    {notes:text(inform) {label "Notes: "} optional}
    {capacity:text(inform) {label "Capacity: "} optional}
    {event_image:text(inform) {label "Image: "} {value "$event_image_display"}}
} -select_query {
		select	e.event_id,
			acs_object.name(e.event_object_id) as event_object_id,
			c.name as category_id,
			e.repeat_template_id,
			e.repeat_template_p,
			e.title,
			to_char(e.start_date, 'Month DD, YYYY HH12:MI AM') as event_start_date,
			to_char(e.end_date, 'Month DD, YYYY HH12:MI AM') as event_end_date,
			e.all_day_p,
			e.location,
			e.notes,
			e.capacity
		from 	ctrl_events e, ctrl_categories c
		where e.event_id = :event_id and e.category_id = c.category_id
}


if {!$selection} {
    ad_script_abort
}
