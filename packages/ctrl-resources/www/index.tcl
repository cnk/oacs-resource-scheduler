ad_page_contract {
    Main index page for resources

    @author KH
    @cvs-id $Id$
    @creation-date 2005-12-20
}

set page_title "Welcome to the Room Reservation System"

set package_id [ad_conn package_id]

set search_url "room-search3"
set search_url2 "equipment-search"
set admin_room_url "manage/"
set admin_resv_resource_url "manage/resv-resource-list"
set all_rooms "room-search-results"
set video_url "quick-category-search?group_name=video"
set data_projector_url "quick-category-search?group_name=data_projector"
set slide_projector_url "quick-category-search?group_name=slide_projector"
set sound_url "quick-category-search?group_name=sound"

set user_common_resv_list [crs::customize::get_user_most_resv_room]
multirow create user_most_common room_id room_name reserve_url 
foreach room_info $user_common_resv_list {
    set room_id [lindex $room_info 0]
    set reserve_url "room-details?[export_url_vars room_id]"
    multirow append user_most_common $room_id [lindex $room_info 1] $reserve_url

}

multirow create pkg_most_common room_id room_name reserve_url
set pkg_common_resv_list [crs::customize::get_pkg_most_resv_room]

foreach room_info $pkg_common_resv_list {
    set room_id [lindex $room_info 0]
    set reserve_url "room-details?[export_url_vars room_id]"
    multirow append pkg_most_common [lindex $room_info 0] [lindex $room_info 1] $reserve_url
}
