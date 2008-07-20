# /packages/ctrl-calendar/www/live-filter.tcl	-*-tab-width: 4-*- ex:ts=4:sw=4:
#ad_page_contract {
#	This widget presents an interface for filtering the display of events on a
#	calendar-page.

#	@author			Andrew Helsley (helsleya@cs.ucr.edu)
#	@creation-date	2007-10-28 22:36 PDT
#	@cvs-id			$Id$
#} {
#}

set subsite_id	[ad_conn subsite_id]
set package_id	[ad_conn package_id]
set instance_id	[ad_conn package_id]
set filter_by	[parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance -default "subsite"]
set calendars	[ctrl::cal::get_calendar_list -filter_by $filter_by -filter_id [set ${filter_by}_id ] -truncate_length 18]

ad_form -name "live_filter" -method post -form {
	{title:text(text),optional					{label {Title: }}	{value $title}								}
	{mm_yyyy:date								{label "Date"}		{value ""}			{format "Month YYYY"}	}
	{archived_p:boolean(checkbox),optional		{label "Archived"}	{value $archived_p}	{options {{"" t}} }		}
	{calendar_p:boolean(checkbox),optional		{label "Calendars"}	{value $calendar_p}	{options {{"" t}} }		}
	{calendar:text(checkbox),multiple,optional	{label ""}			{value $calendar}	{options $calendars}	}
} -on_request {
	if {$archived_p == "t"} {
		set live_filter__end_date_matches_p	"end_date < sysdate"
	} else {
		set live_filter__end_date_matches_p	"end_date >= sysdate"
	}
} -on_submit {
}
