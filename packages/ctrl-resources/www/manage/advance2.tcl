# /packages/ctrl-resources/www/manage/advance2.tcl

ad_page_contract {

    Assign Subsite

    @author Hong, Sung
    @creation-date 2007-04-16
    @cvs-id $Id$

    @param room_id primary key
} {
    {room_id:naturalnum}
    {subsite_ids:array ""}
}

set subsite_list [array names subsite_ids]

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $room_id -privilege admin
   db_transaction {
      foreach subsite_id [db_list subsite_added ""] {
         if {[lsearch -glob $subsite_list $subsite_id] == -1} {
            db_foreach rel_select "" {
#               crs::resource::rel_del -rel_id $rel_id
               ctrl::subsite::object_rel_del -object_id $room_id
            }
         }
      }
      foreach subsite_id $subsite_list {
         if {![db_0or1row rel_select ""]} {
#            crs::resource::rel_add -subsite_id $subsite_id -object_id $room_id
            ctrl::subsite::object_rel_new -subsite_id $subsite_id -object_id $room_id
         }
      }
   }

ad_returnredirect "room?room_id=$room_id"
