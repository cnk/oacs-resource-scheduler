# parameters accepted:
# @param view_option:optional				daily
# @param filter_by:optional					subsite
# @param julian_date:naturalnum,optional
# @param cal_id:naturalnum,optional

if {![info exists view_option]} {
    set view_option "daily"
}

if {![info exists filter_by]} {
    set filter_by "subsite"
}

set package_url [ad_conn package_url]
set view_day_url	[export_vars -base ${package_url}view-day	{cal_id julian_date}]
set view_week_url	[export_vars -base ${package_url}view-week	{cal_id julian_date}]
set view_month_url	[export_vars -base ${package_url}view-month	{cal_id julian_date}]
if {[exists_and_not_null cal_id]} {
	set events_list_url	[export_vars -base ${package_url}events/event-list {{calendar $cal_id} julian_date}]
} else {
	set events_list_url	[export_vars -base ${package_url}events/event-list {julian_date}]
}
set filter_url		[export_vars -base ${package_url}filter/ {cal_id julian_date}]
set user_id [ad_conn user_id]
set rss_url [export_vars -base ${package_url}events/gen-cal-rss {user_id}]
