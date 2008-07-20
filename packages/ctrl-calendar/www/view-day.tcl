# /packages/ctrl-calendar/www/view-day.tcl

ad_page_contract {

    Daily View of Calendar

    @author jmhek@cs.ucla.edu
    @creation-date 1/31/2006
    @cvs-id $Id$
} {
    {cal_id:naturalnum "0"}
    {julian_date ""}
}

if {$cal_id} {
    set selection [ctrl::cal::get -cal_id $cal_id -column_array cal_info]
    if {!$selection} {
	ad_return_error "Error" "The calendar you selected does not exist in the database. Please go back and select another calendar. Thank you."
	return
    }
    set object_id $cal_info(object_id)
    set page_title "$cal_info(cal_name) - Daily View  "

} else {
    set instance_id [ad_conn package_id]
    set subsite_id [ad_conn subsite_id]
    set subsite_name ""
    
    set filter_by [parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance]
    set calendar_list [ctrl::cal::get_calendar_list -filter_by $filter_by -filter_id [set ${filter_by}_id]]
    set object_id [list]
    foreach calendar $calendar_list {
	set calendar_id [lindex $calendar 1]
	lappend object_id $calendar_id
    }
    set object_id [join $object_id ","]
    set page_title "$subsite_name Daily View"

}

if [empty_string_p $julian_date] {
    set current_date [dt_sysdate]
    set julian_date [dt_ansi_to_julian_single_arg $current_date]
}


if {![empty_string_p $julian_date]} {
    set current_date [dt_julian_to_ansi $julian_date]
} else {
    set current_date [dt_sysdate]
    set julian_date [dt_ansi_to_julian_single_arg $current_date]
}

#AMK TEMP HACK
#set admin_p [permission::permission_p -object_id $cal_id -privilege "admin"]
set admin_p 1
set context "Calendar"

# create day view widget
set next_julian_date [expr $julian_date + 1]
set previous_julian_date [expr $julian_date - 1]
set tomorrow_template "<a href=\"view-day?[export_url_vars cal_id julian_date=$next_julian_date]\">Tomorrow</a>"
set yesterday_template "<a href=\"view-day?[export_url_vars cal_id julian_date=$previous_julian_date]\">Yesterday</a>"

set day_view [ctrl::cal::day_view -object_id $object_id -admin_p $admin_p -current_julian_date $julian_date -cal_id $cal_id \
		  -start_time 8 -end_time 20 -interval 30 -tomorrow_template $tomorrow_template \
		  -yesterday_template $yesterday_template -display_24 0]

set context [list "$page_title"]
