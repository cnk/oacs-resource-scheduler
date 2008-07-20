set package_id [ad_conn package_id]
set user_id    [ad_conn user_id]

if ![info exists subsite_id] {
   set subsite_id [ad_conn subsite_id]
}

if {$subsite_id == [ctrl_procs::subsite::get_main_subsite_id]} {
   set filter_subsite_d ""
   set filter_subsite_v ""
} else {
   set filter_subsite_d [db_map filter_subsite_d]
   set filter_subsite_v [db_map filter_subsite_v]
}

# check permissions - log in not required for viewing rooms
permission::require_permission -privilege "read" -object_id $package_id

# ------------------------------------------------------------
# Set constants for date list for readability
# ------------------------------------------------------------
set c_date 0
set c_year 1
set c_month 2
set c_day 3
set c_hours 4
set c_minutes 5
set c_ampm 6

# ------------------------------------------------------------
# Construct the filters 
# ------------------------------------------------------------
set search_filter_list [list]
if ![empty_string_p $name] {
    lappend search_filter_list [db_map filter_room_name]
}
if ![empty_string_p $capacity] {
    lappend search_filter_list [db_map filter_capacity]
}
if ![empty_string_p $location] {
    lappend search_filter_list [db_map filter_location]
}

set search_filter ""
if {[llength $search_filter_list] > 0} {
    set search_filter " and [join $search_filter_list " and "]"
}
# --------------------------------------------------------------------------
# Create the two multirows
# ---------------------------------------------------------------------------
multirow create get_rooms_no_amenities room_id width length height capacity how_to_reserve \
    approval_required_p address_id department_id room floor name description resource_category_id \
    services property_tag details_url

multirow create get_rooms room_id width length height capacity how_to_reserve \
    approval_required_p address_id department_id room floor name description resource_category_id \
    services property_tag details_url


# --------------------------------------------------------------------------
# If user selected any equipment factor into the query
# ---------------------------------------------------------------------------

set page_eq_list $eq
if {[llength $page_eq_list] > 0 } {
    set eq_list_count [llength $page_eq_list]
    set eq_list_csv [join $page_eq_list ", "] 

    set sql_entry(room_best_match)  [db_map rooms_with_equipment]
    set sql_entry(room_some_match) [db_map rooms_with_some_equipment]

    set multirow_names [list "get_rooms" room_best_match "get_rooms_no_amenities" room_some_match]
    set show_recommendations 1
} else {
    set sql_entry(room_best_match) [db_map rooms_with_no_equipment]
    set multirow_names [list "get_rooms" room_best_match]
    set show_recommendations 0
}


# --------------------------------------------------------------------------
# Done with constructing the query
# ---------------------------------------------------------------------------

set passable_context [list [list  "room-search" "Search Filter"]]
set matched_rooms [list]

# ---------------------------------------------------------------
# Run separate queries for the best match and some match display
# -----------------------------------------------------------------
set display_rowcount 0
set counter 0
foreach {multirow sql_name} $multirow_names {

    set table_sql [set sql_entry($sql_name)]

    db_foreach get_result_rooms {} {

	if {[lsearch $matched_rooms $room_id] == -1} {
	    lappend matched_rooms $room_id

	    if {[lindex $from_date_list $c_date] == ""} {
		set from_date_temp ""
	    } else {
		set from_date_temp "[lindex $from_date_list $c_date] [lindex $from_date_list $c_hours]:[lindex $from_date_list $c_minutes]"
	    }

	    if {[lindex $to_date_list $c_date] == "" } {
		set to_date_temp ""
	    } else {
		set to_date_temp "[lindex $to_date_list $c_date] [lindex $to_date_list $c_hours]:[lindex $to_date_list $c_minutes]"
	    }
	    if {![llength $all_day_date_list] > 0 } {
		set all_day_date_temp ""
	    } else {
		set all_day_date_temp "$all_day_date_list"
	    }

	    # -----------------------------------------------------------------
	    # room is reservable if 1. no date options were specified
	    #                       2. there is no reservation conflict
	    # ----------------------------------------------------------------
	    if {[empty_string_p $all_day_date_temp] && [empty_string_p $from_date_temp] && [empty_string_p $to_date_temp]} {
		set flag 0
	    } else {
		set flag [crs::request::check_conflict -resv_resource_id $room_id -all_day_p $all_day_p -start_date $from_date_temp -end_date $to_date_temp -all_day_date $all_day_date_temp]
	    }

	    # ----------------------------------------------------------------
	    # flag is false then room is reservable
	    # ----------------------------------------------------------------
	    if {!$flag} {
		
		#remove date item from the list
		set export_from_date_list [lindex [ctrl::list::lists_minus $from_date_list [lindex $from_date_list $c_date]] 0]
		set export_to_date_list [lindex [ctrl::list::lists_minus $to_date_list [lindex $to_date_list $c_date]] 0]
		set details_url [export_vars -base "room-details" [list room_id \
								       [list from_date $export_from_date_list]\
								       [list to_date $export_to_date_list]\
								       [list all_day_date  $all_day_date_list]\
								       all_day_p \
								       [list context $passable_context]\
								       eq
								      ]]

		multirow append $multirow $room_id $width $length $height "$capacity" \
		    $how_to_reserve $approval_required_p \
		    $address_id $department_id $room $floor $name $description $resource_category_id \
		    $services $property_tag $details_url
		incr display_rowcount
		if {$display_rowcount > $max_returnresults} {
		    break
		}
	    }
	}
    }
    if {$display_rowcount > $max_returnresults} {
	break
    }
    incr counter
}

