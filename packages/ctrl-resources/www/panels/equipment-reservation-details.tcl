#
#
# An includable page to show the details of the reservation
#
#
# @param Request_id the request_id for the reservation
# @param Update_status_p if 1, then display a formwidget to update the status
#
#
#
#

set user_id [auth::require_login]
if { [template::util::is_nil request_id] } {
    set request_id ""
}
if { [template::util::is_nil update_status_p] } {
    set update_status_p 0
}

permission::require_permission -object_id $request_id -privilege "read"
set admin_p [permission::permission_p -object_id $request_id -privilege "admin"]
set write_p [permission::permission_p -object_id $request_id -privilege "write"]
set delete_p [permission::permission_p -object_id $request_id -privilege "delete"]
set status_options [list [list \
                              [list "approved" "approved" ]\
                              [list "denied" "denied" ]\
                              [list "pending" "pending" ]\
                              [list "cancelled" "cancelled" ]]]

#form for updating status
set the_form {
    {sub:text(submit) {label {OK}}}
}

set on_submit {}
set on_request ""
db_multirow -extend {room_p edit_url delete_url widget_name status_update_url}  get_events get_events {} {
    set room_p [crs::room::is_room_p -resource_id $event_object_id]
    if {!$room_p} {
       set edit_url "equipment-details?[export_url_vars resource_id=$event_object_id request_id=$request_id event_id=$event_id]"
       set delete_url "equipment-reservation-delete-confirm?[export_url_vars request_or_event_id=$request_id]"
       set status_update_url "equipment-reservation-details?[export_url_vars request_id update_status_p=1]"
       append the_form "
        {status_${event_id}:text(select),optional {options $status_options}}
    "
        append on_submit "
        crs::event::update_status -event_id $event_id -status \[set status_${event_id} \]
    "
        append on_request "
        set [subst status_{$event_id}] $status
    " 
    } else {
        set delete_url "equipment-reservation-delete-confirm?[export_url_vars request_or_event_id=$event_id request_type=resource]"
    }
    set widget_name status_${event_id}
}

ad_form -name "update" -form $the_form -on_request $on_request \
    -on_submit $on_submit  \
    -export {request_id update_status_p}\
    -after_submit {
        ad_returnredirect "equipment-reservation-details?[export_url_vars request_id]"
    }
