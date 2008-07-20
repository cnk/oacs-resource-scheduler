<?xml version="1.0"?>
<queryset>
        <fullquery name="crs::resource::reservation::previous_reservation.get_prev_reservations">
             <querytext>
              select reserved_by,request_id
              from crs_events_vw
              where event_object_id=:room_id and
                    ((start_date <= $end_date and end_date >= $end_date) or
                     (start_date <= $start_date and end_date >= $start_date) or
                     (start_date >= $start_date and start_date <= $end_date or end_date <=$start_date and end_date >=$end_date)) and
                    status != 'cancelled' and
                    status != 'denied'
              order by start_date desc
             </querytext>
        </fullquery>
</queryset>
