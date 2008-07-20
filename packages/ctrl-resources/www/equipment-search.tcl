ad_page_contract {

    A page to input search filters

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$
} {
}

#We allow ability to search rooms even to non-users of the system.
set user_id    [ad_conn user_id]
set title "Search for Equipments"
set package_id [ad_conn package_id]
set context [list "Search for Equipments"]

set cnsi_context_bar [crs::cnsi::context_bar -page_title $title]

set eq_options [crs::ctrl::category::option_list -path "//Equipment Types"]
set yes_no_options [list [list "No" 0] [list "Yes" 1] ]

ad_form -name "search" -method get  -form {
    {all_day_p:text(radio),optional {label {All Day?}} {options $yes_no_options} {value 0}}
    {all_day_date:date,to_sql(sql_date),from_sql(sql_date),optional {label {Date:}} {format "MON DD YYYY"} {help}}
    {from_date:date,to_sql(sql_date),from_sql(sql_date),optional {label {Date:}} {format "MON DD YYYY HH12:MI AM"} {help}}
    {to_date:date,to_sql(sql_date),from_sql(sql_date),optional {label {Date:}} {format "MON DD YYYY HH12:MI AM"} {help}}
    {eq:text(checkbox),optional {label ""} {options $eq_options}}
    {sub:text(submit) {label {Search}}}
} -action {equipment-search-results}


set previous_reservations_link "view?[export_url_vars history=1]"










