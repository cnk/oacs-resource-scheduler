ad_page_contract {
} {
  {event_id:integer,notnull}
}

set user_id [ad_conn user_id]
if {![db_0or1row data "select profile_id from ccal_profiles where owner_id = :user_id"]} {
   set profile_id [ctrl::cal::profile::add -user_id $user_id -package_id 475]
}
foreach category_id [ctrl_event::event_category::current -event_id $event_id] {
   ctrl::cal::profile::add_filter -profile_id $profile_id -cal_id 0 -category_id $category_id
}

set title "Event categories"
set context "Add"

ad_return_template
