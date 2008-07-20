# parameters accepted:
# @param title:required
# @param context:required
# @param cal_id:required
# @param view_option:optional daily

if ![info exists view_option] {
    set view_option daily 
}


set weekly_view "<a href='view-week?[export_url_vars room_id]'>Weekly</a>"
set monthly_view "<a href='view-month?[export_url_vars room_id]'>Monthly</a>"
set daily_view "<a href='view-day?[export_url_vars room_id julian_date]'>Daily</a>"

switch $view_option {
    weekly {
	set weekly_view "Weekly"
    } 
    monthly {
	set monthly_view "Monthly"
    }
    default {
	set daily_view "Daily"
    }
}
