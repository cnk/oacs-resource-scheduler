<?xml version=1.0?>
  <queryset>
    <fullquery name="ctrl_calendar::vcalendar::format_item.event">
      <querytext>
         select to_char(start_date,'YYYYMMDD') || 'T' || to_char(start_date,'HH24MISS') dtstart,
                to_char(end_date,'YYYYMMDD')   || 'T' || to_char(end_date,'HH24MISS')   dtend,
                title as summary,
                location,
                notes as description,
                all_day_p,
                to_char(start_date,'YYYYMMDD') || 'T000000' dtstart_all_day,
                to_char(start_date,'YYYYMMDD') || 'T235959' dtend_all_day
         from   ctrl_events
         where  event_id = :cal_event_id
      </querytext>
    </fullquery>

    <fullquery name="ctrl_calendar::vcalendar::notify_cancelled_event.get_email_list">
      <querytext>
	select email from parties where party_id = :user_id
      </querytext>
    </fullquery>	

    <fullquery name="ctrl_calendar::vcalendar::notify_cancelled_event.get_user_email">
      <querytext>
	select email from ctrl_calendar_event_downloads where event_id = :cal_event_id
      </querytext>
    </fullquery>	
  </queryset>
