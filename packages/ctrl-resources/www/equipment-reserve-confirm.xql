<?xml version="1.0"?>
<queryset>
        <fullquery name="check_exists">
                <querytext>
                select 1
                from crs_requests
                where request_id=:request_id
                </querytext>
        </fullquery>
         <fullquery name="check_dates">
             <querytext>
                select 1 from dual where $end_date_sql < $start_date_sql
             </querytext>
        </fullquery>
        <fullquery name="get_prev_reservations">
             <querytext>
              select reserved_by,request_id
              from crs_events_vw
              where event_object_id=:resource_id and
                           ((start_date <= $end_date_sql and end_date >= $end_date_sql) or
                            (start_date <= $start_date_sql and end_date >= $start_date_sql )) and
                             status != 'cancelled' and
                             status != 'denied'
              order by start_date desc
             </querytext>
        </fullquery>
        <fullquery name="get_repeat_end_date">
                <querytext>
                      select to_char(add_months($repeat_end_date_sql, 300), 'YYYY MM DD HH24 MI PM') as new_date from dual
                </querytext>
        </fullquery>
</queryset>
