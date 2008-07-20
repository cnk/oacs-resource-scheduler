ad_page_contract {

    A page to input search filters

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$
} {
}

#We allow ability to search rooms even to non-users of the system.
set user_id    [ad_conn user_id]
set title "Search for Rooms"
set package_id [ad_conn package_id]
set context [list "Search for Rooms"]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $title]

set eq_options [crs::ctrl::category::option_list -path "//Equipment Types"]
set yes_no_options [list [list "No" "f"] [list "Yes" "t"] ]

ad_form -name "search" -method get  -form {
    {name_arg:text(text),optional    {label {Room Number:}} {html {size 20}}}
    {capacity_arg:text(text),optional   {label {Minimum capacity:}} {html {size 2}} }
    {location:text(text),optional   {label {Location:}} {html {size 50}}}
    {all_day_p:text(radio),optional {label {All Day?}} {options $yes_no_options} {value 0}}
    {all_day_date:date,to_sql(linear_date),optional {label {Date:}} {format "MON DD YYYY"} {help}}
    {from_date:date,to_sql(linear_date),optional {label {Date:}} {format "MON DD YYYY HH12:MI AM"} {help}}
    {to_date:date,to_sql(linear_date),optional {label {Date:}} {format "MON DD YYYY HH12:MI AM"} {help}}
    {eq:text(checkbox),multiple,optional {label ""} {options $eq_options}}
    {add_services:text(textarea),optional,nospell    {label {Extra Services or Requests:}} {html {rows 6 cols 35}}}
    {sub:text(submit) {label {Search}}}
} -validate {
    {all_day_date {$all_day_p != "t" || ![empty_string_p $all_day_date]} "<font color=red>Please enter all day event date</font>"}
} -on_submit {
   if {[llength $eq]>=0} {
      set eq [join $eq "_"] 
   }
} -after_submit {
   set include_num 1
   ad_returnredirect "panels/room-search3-results?[export_url_vars include_num name_arg capacity_arg location all_day_p all_day_date from_date to_date eq add_services]"
}

set previous_reservations_link "view?[export_url_vars history=1]"










