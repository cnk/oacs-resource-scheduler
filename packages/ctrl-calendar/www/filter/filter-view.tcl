ad_page_contract {
    Display multiple resources or categories on a dingle page

    @author kellie@ctrl.ucla.edu
} {
    cal_filter_id:naturalnum,notnull
    cal_id:naturalnum,notnull
    {julian_date:optional ""}
    {ansi_date:optional ""}
}

set user_id [ad_conn user_id]
set exist_p [ctrl::cal::filter::get -cal_filter_id $cal_filter_id -column_array filter_info]
if {$exist_p} {
    set page_title "filter - $filter_info(filter_name)"
} else {
    ad_return_error 1 "<br><ul><li>Invalid Filter Id</li></ul>"
    ad_script_abort
}

ad_form -name "filter_view" -form {
    
}

if {[empty_string_p $ansi_date]} {
    set ansi_date [dt_sysdate] 
}

# SET UP MONTH WIDGET  ###########################################################################################################
if {[empty_string_p $ansi_date]} { 
    set ansi_date [dt_sysdate]
} 

if {[empty_string_p $julian_date]} {
    set current_date_list [split $ansi_date "-"]
    set year  [lindex $current_date_list 0]
    set month [string trimleft [lindex $current_date_list 1] 0]
    set day   [string trimleft [lindex $current_date_list 2] 0]
    set julian_date [dt_ansi_to_julian $year $month $day]
}

set current_date [dt_julian_to_ansi $julian_date]
set curr_sec [clock scan $current_date]
set date_display_str [clock format $curr_sec -format "%B %d, %Y"]
set weekday_display_str [clock format $curr_sec -format "%A"]

# SET UP MONTH WIDGET  ###########################################################################################################
set next_month_template "( <a href=\"filter-view?[export_url_vars cal_filter_id cal_id]&ansi_date=\$ansi_date\">Next Month</a> )"
set prev_month_template "( <a href=\"filter-view?[export_url_vars cal_filter_id cal_id]&ansi_date=\$ansi_date\">Previous Month</a> )"
set day_number_template "<a href=filter-view?[export_url_vars cal_filter_id cal_id]&julian_date=\$julian_date>\$day_number</a>"
set calendar_details [ns_set create calendar_details]

#set calendar [dt_widget_month -calendar_details $calendar_details -date $current_date -day_number_template $day_number_template -next_month_template $next_month_template -prev_month_template $prev_month_template -calendar_width "500" -master_bgcolor "414C60" -header_bgcolor "#FF9900" -header_text_color "#242942" -header_text_size "4" -day_header_size 2 -day_header_bgcolor "#E5E5BA" -day_bgcolor "#ffffff" -today_bgcolor "#F2F29A" -day_text_color "#333333" -empty_bgcolor "#cccccc" -prev_next_links_in_title 1 ]

#set calendar [crs::calendar::monthly_view -room_id $cal_id \
#                  -julian_date $julian_date -prev_month_template $prev_month_template \
#                 -next_month_template $next_month_template -day_number_template $day_number_template]
set calendar [dt_widget_month_small -date $current_date -day_number_template $day_number_template -next_month_template $next_month_template -prev_month_template $prev_month_template -master_bgcolor "414C60" -header_bgcolor "\#B3BCD6" -header_text_color "\#242942" -day_header_bgcolor "\#E5E5BA" -day_bgcolor "\#ffffff" -day_text_color "\#4D4DB4" -empty_bgcolor "\#cccccc"]

# END SET UP MONTH WIDGET  #######################################################################################################

# SET UP DAY WIDGET  #############################################################################################################
set tomorrow_date [dt_julian_to_ansi [expr $julian_date + 1]]
set yesterday_date [dt_julian_to_ansi [expr $julian_date - 1]]
set tomorrow_template "( <a href=\"filter-view?[export_url_vars cal_filter_id cal_id]&ansi_date=$tomorrow_date + \">Tomorrow</a> )"
set yesterday_template "( <a href=\"filter-view?[export_url_vars cal_filter_id cal_id]&ansi_date=$yesterday_date\">Yesterday</a> )"

set day_view [ctrl::cal::filter::day_view -cal_id $cal_id -cal_filter_id $cal_filter_id -current_julian_date $julian_date \
		                          -start_time 8 -end_time 20 -interval 30 -manage_p 0 \
		                          -tomorrow_template $tomorrow_template -yesterday_template $yesterday_template]
# END SET UP DAY WIDGET  #########################################################################################################


