ad_page_contract {
    A page to display equipment search results

    @author        Sung Hong (shhong@mednet.ucla.edu)
    @creation-date 04/03/2006
    @cvs-id  $Id$

} {
    {all_day_p ""}
    {all_day_date:array,date ""}
    {from_date:array,date ""}
    {to_date:array,date ""}
    {eq:multiple ""}
    {current_page:naturalnum 0}
    {row_num:naturalnum 25}
    {paginate_p 1}
}

set package_id [ad_conn package_id]
if ![info exists subsite_id] {
   set subsite_id [ad_conn subsite_id]
}
set user_id    [ad_conn user_id]

#check permissions - log in not required for viewing equipments
permission::require_permission -privilege "read" -object_id $package_id

# ------------------------------------------------------------
# Initialize the date arrays if the dates are not defined
# ------------------------------------------------------------
set date_option_list [list date year month day hours minutes ampm]
if ![info exists from_date(date)] {
    foreach option $date_option_list {
        set from_date($option) ""
    }
}
if ![info exists to_date(date)] {
    foreach option $date_option_list {
        set to_date($option) ""
    }
}
if ![info exists all_day_date(date)] {
    foreach option $date_option_list {
        set all_day_date($option) ""
    }
}

# -------------------------------------------------------------------------- 
# Address the issue relating to the short hours for date widgets
# --------------------------------------------------------------------------
if [info exists from_date(short_hours)] {
    set from_date(hours) $from_date(short_hours)
}

if [info exists to_date(short_hours)] {
    set to_date(hours) $to_date(short_hours)
}



# ------------------------------------------------------------
# Construct the filters
# ------------------------------------------------------------
#for each item in the equipment list, build a special table query that filters the results based on eq
set eq_clause ""
if {[llength $eq] > 0 } {
   set eq_list ""
   foreach eq_id $eq {
      lappend eq_list "res.resource_category_id  = $eq_id "
   }
   set eq_clause " and [join $eq_list " or "]"
} 

set title "Equipment listing"
set cnsi_context_bar [crs::cnsi::context_bar -page_title $title]
set context [list [list  "equipment-search" "Search Filter"]  "Equipment Results Listing"]
set passable_context [list [list  "equipment-search" "Search Filter"]]

                set from_date_list [list $from_date(year)\
                                        $from_date(month)\
                                        $from_date(day)\
                                        $from_date(hours)\
                                        $from_date(minutes)\
                                        $from_date(ampm)]

                set to_date_list [list $to_date(year)\
                                      $to_date(month)\
                                      $to_date(day)\
                                      $to_date(hours)\
                                      $to_date(minutes)\
                                      $to_date(ampm)]

db_multirow -extend {details_url} get_equipments get_equipments_query {} {
   set details_url [export_vars -base "equipment-details" [list resource_id \
                                                                [list from_date $from_date_list]\
                                                                [list to_date   $to_date_list]\
                                                                all_day_p\
                                                                [list context $passable_context]\
                                                                eq\
                                                                ]]
}


ad_return_template
