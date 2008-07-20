#/packages/ctrl-calendar/www/events/gen-cal-rss.tcl
ad_page_contract {

   This page refresh the rss feed and redirects to the rss file.
   @param user_id
   @param filter_by

   @author veronica@viaro.net (VLC)
   @creation-date JUL-25-2007
   @cvs-id $Id$
   
} {
    {user_id ""}    
    {filter_by ""}    
}

set subsite_id [ad_conn subsite_id]

if {![empty_string_p $user_id] } {
   rss_gen_report_cal_filter $user_id
   set rss_name "/rss/cal_filter_${subsite_id}_$user_id\.xml"   
   ad_returnredirect "$rss_name"
} else {
   rss_gen_report_cal_all $filter_by
   ad_returnredirect "/rss/cal_$subsite_id.xml"
}
