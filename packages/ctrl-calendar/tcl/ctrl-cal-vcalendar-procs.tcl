# /packages/ctrl-calendar/tcl/ctrl-calendar-vcalendar-procs.tcl

ad_library {

    Utility functions for syncing Calendar using vCalendar version 1.0 (ICS file extension)

    @author shhong@mednet.ucla.edu
    @author avni@ctrl.ucla.edu (AK)
    @creation-date ?
    @cvs-id $Id$
}

# 1. make sure the server config file
# (in this case an .ini file) has the .vcs extension mapped to msoutlook
# i.e. .vcs=text/x-vCalendar

namespace eval ctrl_calendar::vcalendar {}

ad_proc -public ctrl_calendar::vcalendar::format_item {
  {-cal_event_id:required}
} {
   Procedure to create an event using vcalendar format 
} {
   set format ""
   if {[db_0or1row event {}]} {
       if {$all_day_p == "t"} {
	   set dtstart $dtstart_all_day
	   set dtend   $dtend_all_day
       }

       set summary [ad_html_to_text $summary]
       set location [ad_html_to_text $location]
       set description [ad_html_to_text $description]

       regsub -all {\r\n} $summary "\r" summary
       regsub -all {\r\n} $location "\r" location
       regsub -all {\r\n} $description "\r" description


       set format "BEGIN:VCALENDAR\r\nPRODID:DRC9\r\nVERSION:2.0\r\nBEGIN:VEVENT\r\nDTSTART:$dtstart\r\nDTEND:$dtend\r\nSUMMARY:$summary\r\nLOCATION:$location\r\nDESCRIPTION:$description\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n"

   }
   return $format
}

# notify event cancellation to users signed up for the event
ad_proc -public ctrl_calendar::vcalendar::notify_cancelled_event {
  {-cal_event_id:required}
} {
    Procedure to email users if an event is cancelled
} {
if {[ns_config -exact "ns/server/drc/module/nssock" hostname] == "drc.ctrl.ucla.edu"} {
    set user_id [ad_conn user_id]
    set dist_email [db_string get_user_email {}]
    set email_subject "This event is cancelled"
    set email_body "Event Cancelled"
    set content_type "html"

    db_foreach get_email_list "" {

        set headers [ns_set new]
        ns_set put $headers "Content-Type" "$content_type"
        ns_set put $headers "MIME-Version" "1.0"
        ns_sendmail $dist_email $email "$email_subject" "$email_body" $headers

    }
}
}
