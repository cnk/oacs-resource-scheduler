ad_page_contract {
    A page that allows you confirm deletion of your reservation

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 12/09/2005
    @cvs-id  $Id$
    
    @request_or_event_id can be a request or a resource (non-room)
    @resource_type request or resource
} {
    {request_or_event_id:notnull}
    {request_type "request"}
    {return_url [get_referrer]}
}

set user_id    [ad_conn user_id]
permission::require_permission -object_id $request_or_event_id -privilege "admin"
set page_title "Confirm Delete"
set context [list [list  $return_url "Personal Events"] $page_title]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $page_title]

if {[string equal $request_type "request"]} {
    set confirm_msg "request and all of it's related events?"
} else {
    set confirm_msg "$request_type from your request?"
}

ad_form -name "confirm" -form {
    {confirm_msg:text(inform) {label {Please Confirm:}} {value {Are you sure you want to delete this $confirm_msg}}}
    {sub_yes:text(submit) {label {Yes}}}
    {sub_no:text(submit) {label {No}}}
} -on_submit {
    if {![empty_string_p $sub_yes]} {
	if {[string equal $request_type "request"]} {
	    crs::request::delete -request_id $request_or_event_id
	    set return_url "view?history=1"
	} elseif {[string equal $request_type "resource"]} {
	    crs::event::delete -event_id $request_or_event_id
	    set return_url "view?history=1"
	} 
    }

} -after_submit {
    ad_returnredirect $return_url
} -export {request_or_event_id request_type return_url}
