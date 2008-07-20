# /packages/ctrl-calendar/www/events/event-list.tcl			-*- tab-width: 4 -*-
ad_page_contract {

	A plain list of events.  By default, only future events are shown, with the
	earliest events first.

	@author			shhong@mednet.ucla.edu (SH)
	@author			avni@ctrl.ucla.edu (AK)
	@author			kellie@ctrl.ucla.edu (KL)

	@creation-date:	03/22/2006
	@cvs-id			$Id$
} {
	{search_constraint:trim	""}
	{title:trim				""}
	{description:trim		""}
	{calendar:multiple		""}
	{category:multiple		""}
	{archived_p:trim		"f"}
	{calendar_p:trim		"f"}
	{category_p:trim		"f"}
	{julian_date:naturalnum,optional}
}

set page_title		"Event List"
set context			$page_title
set instance_id		[ad_conn package_id]
set subsite_id		[ad_conn subsite_id]
set user_id			[ad_conn user_id]

set package_admin_p	[permission::permission_p -party_id [ad_conn user_id] -object_id $instance_id -privilege admin]

set filter_by		[parameter::get -package_id $subsite_id -parameter cc_subsite_or_instance -default "subsite"]
set calendar_list	[ctrl::cal::get_calendar_list -filter_by $filter_by -filter_id [set ${filter_by}_id ] -truncate_length 18]
set category_list	[ctrl::category::option_list -path "[ctrl::cal::category::root_info -info path -package_id $instance_id]//Event Categories" -disable_spacing 0]
set today			[clock format [clock seconds] -format "%Y %m"]

### CONSTRAINTS ################################################################

### Subsite or Package Constraint ##############################################
switch $filter_by {
	"subsite" {
		set table_constraint " , acs_rels ar, ctrl_subsite_for_object_rels csfor "
		set filter_constraint " and ar.object_id_one = :subsite_id
								and ar.object_id_two = cc.cal_id
								and ar.rel_id		 = csfor.rel_id"
	}
	default {
		set table_constraint ""
		set filter_constraint "and cc.package_id = :instance_id"
	}
}
### End Subsite or Package Constraint ##########################################

set header_stuff "<link rel=\"alternate\" type=\"application/rss+xml\" title=\"User RSS\" href=\"gen-cal-rss?user_id=$user_id&filter_by=$filter_by\">
				  <link rel=\"alternate\" type=\"application/rss+xml\" title=\"All RSS\" href=\"gen-cal-rss?filter_by=$filter_by\">"

### Search Constraint ##########################################################
set search_constraint ""

if {![empty_string_p $title]} {
	set title [string tolower $title]
	append search_constraint " and lower(ce.title) like '%'||:title||'%'"
}

if {![empty_string_p $description]} {
	set description [string tolower $description]
	append search_constraint " and lower(ce.notes) like '%'||:description||'%'"
}

### Calendar Constraint #####################################################################################################
set i 0
foreach cal $calendar {
   if {$cal > 0} {
	if {$i == 0} {
		append search_constraint " and ((cc.cal_id=$cal)"
	} else {
		append search_constraint " or (cc.cal_id=$cal)"
	}
	incr i
   }
}
if {$i > 0} {
	append search_constraint ")"
}

### Category Constraint ######################################################################################################
set i 0
foreach cat $category {
	if {$i == 0} {
		append search_constraint " and ((c.category_id=$cat)"
	} else {
		append search_constraint " or (c.category_id=$cat)"
	}
	incr i
}
if {$i > 0} {
	append search_constraint ")"
}

################################################################################
### END CONSTRAINTS ############################################################
################################################################################

ad_form -name "event_list" -method post -form {
	{mm_yyyy:date {label "Date"} {format "Month YYYY"} {value ""}}
	{calendar:text(checkbox),multiple,optional {options $calendar_list} {value $calendar}}
	{category:text(checkbox),multiple,optional {options $category_list} {value $category}}
	{title:text(text),optional {label {Title: }} {value $title}}
	{description:text(text),optional {label {Description: }} {value $description}}
	{archived_p:boolean(checkbox),optional {label "Archived"} {value $archived_p} {options {{"" t}}}}
	{calendar_p:boolean(checkbox),optional {label "Calendars"} {value $calendar_p} {options {{"" t}}}}
	{category_p:boolean(checkbox),optional {label "Categories"} {value $category_p} {options {{"" t}}}}
} -validate {
	#{mm_yyyy {![empty_string_p [string trim [lindex $mm_yyyy 1]]]} "No value supplied for month"}
} -on_request {
	if {$archived_p=="t"} {
		set year_month_constraint "and ce.end_date < sysdate"
	} else {
		set year_month_constraint "and ce.end_date >= sysdate"
	}
} -on_submit {
	if {![empty_string_p $mm_yyyy]} {
		set yyyy	[format "%04d" [string trim [lindex $mm_yyyy 0]]]
		set mm		[format "%02d" [string trim [lindex $mm_yyyy 1]]]

		if {![empty_string_p $yyyy] && ![empty_string_p $mm]} {
			set year_month				"$yyyy\-$mm"
			set year_month_constraint	"and to_char(ce.end_date, 'yyyy-mm') = :year_month"
		} elseif {[empty_string_p $mm]} {
			set year_month				"$yyyy"
			set year_month_constraint	"and to_char(ce.end_date, 'yyyy') = :year_month"
		} elseif {[empty_string_p $yyyy]} {
			set year_month				"$mm"
			set year_month_constraint	"and to_char(ce.end_date, 'mm') = :year_month"
		} else {
			ad_return_error "Formatting Error" "
				There is a formatting error with the dates you selected. Please
				contact your system administrator at [ad_host_administrator] to
				resolve this problem. Thank you.
			"
			return
		}
	} else {
		if {$archived_p=="t"} {
			set year_month_constraint "and ce.end_date < sysdate"
		} else {
			set year_month_constraint "and ce.end_date >= sysdate"
		}
	}
}

db_multirow -extend {
	event_image_display categories event_admin_p digest_posted_list
	digest_notposted_list edit_link delete_link cancel_link cal_names
} events get_monthly_events "" {
	set event_image_display [ctrl_event::event_image_display	-event_id $event_id]
	set categories			[ctrl_event::category::category_csv	-event_id $event_id]
	set edit_link			"<a href=\"event-ae?[export_url_vars event_id]\">Edit</a>"
	set delete_link			"<a href=\"event-delete?[export_url_vars event_id]\">Delete</a>"

	if {[string equal $current_status "cancelled"]} {
		set status_url	[export_vars -base event-status {event_id {status scheduled}}]
		set cancel_link	"<a href=\"$status_url\">Reschedule</a>"
	} else {
		set status_url	[export_vars -base event-status {event_id {status cancelled}}]
		set cancel_link	"<a href=\"$status_url\">Cancel</a>"
	}

	# get the names of the calendars this event is mapped to
	set cal_names [join [db_list get_event_calendar_names {}] "<br />"]

	# if the user has admin over the event, provide the option to post to digest
	set event_admin_p [permission::permission_p -object_id $event_id -privilege "admin"]
	if {$event_admin_p} {
		# get the list of eligible digests to which this event has not been posted
		set digest_notposted_list	[ctrl::cal::digest::get_notposted_digest_list -cal_id 0 -event_id $event_id]
		# get the list of digest names to which this event has been posted
		set digest_posted_list		[join [ctrl::cal::digest::get_posted_digest_list -event_id $event_id] ","]
	}
}
