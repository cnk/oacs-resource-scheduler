ad_page_contract {

    A page to policies to groups

    @author        Jianming He
    @creation-date 8/03/2006
    @cvs-id  $Id$
} {
    resource_id:naturalnum,notnull
    policy_id:naturalnum,notnull
    {return_url ""}
}

crs::resv_resrc::policy::get -by id -policy_id $policy_id

permission::require_permission  -object_id $policy_info(resource_id) -privilege admin

set user_id    [ad_conn user_id]
set package_id [ad_conn package_id]
set title "Assign Policies"
set context [list "Assign Policies"]
if {[regexp cnsi [subsite::get_url]]} {
    set cnsi_context_bar "<br>[ad_context_bar_html [list [list "../../index" "Room Reservation"] [list "../index" "Manage"] $title]]<br><br>"
} else {
    set cnsi_context_bar ""
}



set policy_options [db_list_of_lists select_policies {}]
set group_options  [db_list_of_lists select_groupes {}]

#db_1row get_reservation_details {select date_reserved as request_date, start_date as reservation_start_date, end_date as reservation_end_date from crs_events_vw where event_id = 46322}
#[crs::resv_resrc::policy::check_compliance -group_id -1 -resource_id 12313 \
     -request_date $request_date -reservation_start_date $reservation_start_date \
     -reservation_end_date $reservation_end_date -action "update"]

ad_form -name "policy_assign" -form {
    {policy_select:text(select) disable {label {Policies:}} {options $policy_options}}
    {group_select:text(multiselect),multiple {label {Groups:}} {options $group_options} {help}}
    {ok:text(submit) {label {Ok}}}
} -mode edit -on_request {
    set group_select [db_list select_associated_groups {**SQL**}]
} -cancel_label Cancel -cancel_url $return_url -on_submit {
    foreach group_id $group_select {
	foreach policy_id $policy_select {
	    crs::resv_resrc::policy::assign_to_group -group_id $group_id \
		-policy_id $policy_id
	}
    }
} -after_submit {
    if ![empty_string_p $return_url] {
	ad_returnredirect $return_url
	ad_script_abort
    }

}  -export "resource_id policy_id return_url"












