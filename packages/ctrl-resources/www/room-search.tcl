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

set eq_options [crs::ctrl::category::option_list -path "//Equipment Types"]
set yes_no_options [list [list "No" 0] [list "Yes" 1] ]

ad_form -name "search" -method get  -form {
    {name:text(text),optional    {label {Room Number:}} {html {size 20}}}
    {capacity:text(text),optional   {label {Minimum capacity:}} {html {size 2}} }
    {location:text(text),optional   {label {Location:}} {html {size 50}}}
    {all_day_p:text(radio),optional {label {All Day?}} {options $yes_no_options} {value 0}}
    {all_day_date:date,to_sql(sql_date),from_sql(sql_date),optional {label {Date:}} {format "MON DD YYYY"} {help}}
    {from_date:date,to_sql(sql_date),from_sql(sql_date),optional {label {Date:}} {format "MON DD YYYY HH12:MI AM"} {help}}
    {to_date:date,to_sql(sql_date),from_sql(sql_date),optional {label {Date:}} {format "MON DD YYYY HH12:MI AM"} {help}}
    {eq:text(checkbox),optional {label ""} {options $eq_options}}
    {add_services:text(textarea),optional,nospell    {label {Extra Services or Requests:}} {html {rows 6 cols 35}}}
    {sub:text(submit) {label {Search}}}
} -on_request {
#    set from_date [template::util::date::now]
#    set to_date [template::util::date::now_min_interval_plus_hour]
} -action {room-search-results}

set previous_reservations_link "view?[export_url_vars history=1]"










