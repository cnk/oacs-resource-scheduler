# /packages/ctrl-resources/www/manage/advance.tcl

ad_page_contract {

    Assign Subsite

    @author Hong, Sung
    @creation-date 2007-04-16
    @cvs-id $Id$

    @param room_id primary key
} {
    {room_id:naturalnum}
}

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $room_id -privilege admin
set context [list [list index Administration] [list "room?room_id=$room_id" "Room Detail"] "Advance"]
set cnsi_context_bar [crs::cnsi::context_bar -page_title "Advance" -manage_p 1]

set checked_list [list]
db_foreach subsite_added "" {
   lappend checked_list $subsite_id
}

### Digest acs-subsite
set root_subsite_id [ctrl_procs::subsite::get_main_subsite_id]
multirow create subsite subsite_name subsite_id write_p checked
db_foreach subsite_select "" {
   if {[lsearch -glob $checked_list $subsite_id] > -1} {
      set checked 1
   } else {
      set checked 0
   }
   multirow append subsite $subsite_name $subsite_id $write_p $checked
}
