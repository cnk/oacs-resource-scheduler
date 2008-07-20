<?xml version="1.0"?>
<queryset>


        <fullquery name="get_events">
                <querytext>
                select  v.event_id,
                        v.request_id,
                        v.status,
                        to_char(v.date_reserved,'Mon DD, YYYY HH12:MI AM') as date_reserved,
                        v.event_code,
                        v.event_object_id,
                        v.title,
                        to_char(v.start_date,'Mon DD, YYYY HH12:MI AM') as start_date,
                        to_char(v.end_date,'Mon DD, YYYY HH12:MI AM') as end_date,
                        v.all_day_p,
                        v.location,
                        v.notes,
                        v.capacity,
                        r.name as request_name,
                        r.description as request_description,
                        (select name from crs_resv_resources_vw where resource_id=v.event_object_id) as object_name,
                        (select first_names || ' ' || last_name from persons where person_id=v.reserved_by) as reserved_by
                from   crs_requests r,
                       crs_events_vw v
                where  r.request_id=:request_id and
                       r.request_id=v.request_id
                order by  r.request_id,event_id

                </querytext>
        </fullquery>

</queryset>
