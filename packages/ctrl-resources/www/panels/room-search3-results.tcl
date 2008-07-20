ad_page_contract {

    A page to display rooms

    @author        Sung Hong
    @creation-date 04/24/2007
    @cvs-id  $Id$

} {
    {include_num:integer 1}
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
   set orderby2 $orderby
   set page2    $page
}

set title "Room listing"
set context [list [list  "../room-search3" "Search Filter"]  "Room Results Listing"]

ad_return_template
