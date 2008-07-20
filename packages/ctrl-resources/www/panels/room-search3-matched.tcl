ad_page_contract {

    A page to display rooms

    @author        Sung Hong 
    @creation-date 04/24/2007
    @cvs-id  $Id$

} {
    {include_num:integer}
    {name_arg:trim ""}
    {capacity_arg:integer,trim ""}
    {location:trim ""}
    {all_day_p ""}
    {all_day_date:trim ""}
    {from_date:trim ""}
    {to_date:trim ""}
    {eq:trim ""}
    {add_services:trim ""}
    {orderby1 "name,asc"}
    {page1:integer 1}
    {orderby2 "name,asc"}
    {page2:integer 1}
    {orderby "name,asc"}
    {page:integer 1}
}
if {$include_num == 1} {
   set orderby1 $orderby
   set page1    $page
} else {
   set orderby $orderby1
   set page    $page1
}
set include_num 1

set package_id [ad_conn package_id]
# check permissions - log in not required for viewing rooms
permission::require_permission -privilege "read" -object_id $package_id

set subsite_id [ad_conn subsite_id]
if {$subsite_id == [ctrl_procs::subsite::get_main_subsite_id]} {
   set filter_subsite ""
} else {
   set filter_subsite [db_map filter_subsite]
}
if {[empty_string_p $name_arg]} {
   set filter_name ""
} else {
   set filter_name [db_map filter_name]
}
if {[empty_string_p $capacity_arg]} {
   set filter_capacity ""
} else {
   set filter_capacity [db_map filter_capacity]
}
if {[empty_string_p $location]} {
   set filter_location ""
} else {
   set filter_location [db_map filter_location]
}

set eq_ctr [llength [split $eq "_"]]
if {$eq_ctr <= 0} {
   set eq_csv ""
   set filter_eq "" 
   set filter_eq2 ""
} else {
   regsub -all "_" $eq "," eq_csv
   set filter_eq [db_map filter_eq]
   set filter_eq2 [db_map filter_eq2]
}
if {[empty_string_p $add_services]} {
   set filter_service ""
} else {
   set filter_service [db_map filter_service]
}
if {$all_day_p == "t" && ![empty_string_p $all_day_date]} {
   set all_day [string range [join $all_day_date "-"] 0 9]
   set filter_all_day [db_map filter_all_day]
} else {
   set all_day ""
   set filter_all_day ""
}
if {![empty_string_p $from_date] && ![empty_string_p $to_date]} {
   set start_date [join $from_date "-"]   
   set end_date [join $to_date "-"]   
   set filter_time [db_map filter_time]
} else {
   set start_date ""
   set end_date ""
   set filter_time ""
}

template::list::create \
   -name room \
   -multirow room_query \
   -key room_id \
   -no_data "No room found" \
        -page_size 10 \
        -page_groupsize 10 \
        -page_flush_p 1 \
        -page_query_name room_select_all \
   -elements {
      name {label "Room Name"}
      description {label "Description"}
      capacity {label "Capacity"}
      floor {label "Floor"}
      services {label "Extra Services"}
      approval_required_p {label "Approval needed to reserve?"
                           display_template "<if @room_query.approval_required_p@ eq t>Yes</if>
                                             <else>No</else>"}
      details_url {label "Options"
                   display_template "<a href=\"@room_query.details_url@\">See Details and Reserve</a>"}
} -orderby {
   name {orderby "lower(r.name)"}
   description {orderby "lower(r.description)"}
   capacity {orderby "r.capacity"}
   floor {orderby "lower(r.floor)"}
   services {orderby "lower(r.services)"}
   approval_required_p {orderby "r.approval_required_p"}
}  -filters {
      include_num {}
      name_arg {}
      capacity_arg {}
      location {}
      all_day_p {}
      all_day_date {}
      from_date {}
      to_date {}
      eq {}
      add_services {}
      orderby1 {}
      page1 {}
      orderby2 {}
      page2 {}
   }

db_multirow -extend {details_url} room_query room_select "" {
   set details_url "../room-details?[export_url_vars room_id all_day_p all_day_date from_date to_date eq]"
}

