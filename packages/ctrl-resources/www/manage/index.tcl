ad_page_contract {
	Room Admin

	@author SH
	@cvs-id $Id$
	@creation-date 2006-01-23
} {
  {orderby:trim "name,asc"}
  {page:integer 1}	
}

ad_maybe_redirect_for_registration
set package_id [ad_conn package_id]
set user_id    [ad_conn user_id]

if ![info exists subsite_id] {
   set subsite_id [ad_conn subsite_id]
}

set create_p [permission::permission_p -object_id $package_id -privilege admin -party_id  $user_id]

if {[regexp {^(.*),(asc|desc)$} $orderby match orderby_name direction]} {
   switch $orderby_name {
      "name"   {set orderby_clause "order by lower(name) $direction"}
   }
}

template::list::create -name room_admin_display -multirow room_list \
   -key            a.room_id \
   -no_data "There are no rooms for you to manage" \
   -page_size 20 \
   -page_groupsize 9 \
   -page_flush_p 1 \
   -page_query_name room_order_all \
   -elements {
        name { label "Name" }
        description { label "Description" }
        capacity {label "Capacity (#Persons)"}
        room {label ""
              display_template "Detail"
              link_url_eval {[export_vars -base room {room_id}]}}
   }

set pagination [template::list::page_where_clause -name "room_admin_display" -and]
db_multirow room_list room_order_page {}

set title "Room Reservation Administration"
set context [list [list Administration]]

if {[regexp cnsi [subsite::get_url]]} {
    set cnsi_context_bar "<br>[ad_context_bar_html [list [list "../index" "Room Reservation"] $title]]<br><br>"
} else {
    set cnsi_context_bar ""
}

ad_return_template
