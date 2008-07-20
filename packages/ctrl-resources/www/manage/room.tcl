# -*- tab-width: 4 -*-
ad_page_contract {
	Display the information and resources for the room

	@author			KH
	@cvs-id			$id$
	@creation-date	2005-12-15
} {
	room_id:naturalnum,notnull
	{date:optional ""}
}

set user_id [ad_conn user_id]
# Make sure the room exists first

permission::require_permission -party_id $user_id -object_id $room_id -privilege admin
crs::room::get -room_id $room_id -column_array room_info


set return_url [export_vars -base room room_id]

db_multirow -extend [list edit_link delete_link action] resource_list resource_list {**SQL**} {
	if [string equal $reservable_p Yes] {
		set edit_link [export_vars -base reservable-ae [list return_url resource_id parent_resource_id]]
		set delete_link [export_vars -base reservable-delete [list return_url resource_id parent_resource_id]]
	} else {
		set edit_link [export_vars -base ae [list return_url resource_id parent_resource_id]]
		set delete_link [export_vars -base resource-delete [list return_url resource_id parent_resource_id]]
	}
}

set parent_resource_id $room_id
set href_add_resource_non_reservable [export_vars -base ae [list parent_resource_id return_url]]
set href_add_resource_reservable	 [export_vars -base reservable-ae [list parent_resource_id return_url]]

template::list::create -name resource_list_display -multirow resource_list \
	-key room_id \
	-no_data "No Resources specified" \
	-elements {
		name {
			label "Name"
		}
		resource_category_name {
			label "Category"
		}
		quantity {
			label Qty
		}
		enabled_p {
			label "Enabled?"
			display_template "<if @resource_list.enabled_p@ eq t>Yes</if><else>No</else>"
		}
		reservable_p {
			label "Reservable?"
		}
		action {
			label "Action"
			display_template "<a href='@resource_list.edit_link;noquote@'>Edit</a> <a href='@resource_list.delete_link;noquote@'>Delete</a>"
		}
	}

db_multirow resource_list resource_list {}

db_multirow -extend [list request_details] request_list request_list {} {
	set request_details [export_vars -base ../reservation-details {request_id}]
}

template::list::create -name request_list_display -multirow request_list \
	-no_data "There are no requests" \
	-elements {
		request_details {
			label "Request Name"
			display_template "<a href='@request_list.request_details;noquote@'>@request_list.name@</a>"
		}
		start_date {
			label "Start Date"
		}
		end_date {
			label "End Date"
		}
		status {
			label "Status"
		}
		reserved_by {
			label "Reserved By"
		} 
		link {
			label "Attendee"
			display_template "<a href='../events/event-rsvp-attendee-ae?event_id=@request_list.event_id;noquote@'>View</a>"
		}
	}

set context [list [list index Administration] "Room Detail"]
set title "$room_info(name) Room"

set cnsi_context_bar [crs::cnsi::context_bar -page_title $title -manage_p 1]

if {[exists_and_not_null date]} {
	set date_for_month_widget $date
} else {
	set date_for_month_widget [clock format [clock seconds] -format "%Y-%m-%d"]
}

set calendar_exists_p [db_0or1row calendar_view {}]
if {$calendar_exists_p == 1} {
	set calendar_link [export_vars -base ../calendar/view-month [list cal_id room_id]]
}

# -------------------------------------------------------
# -- Create the default policy if it does exit
# -------------------------------------------------------

set package_id [ad_conn package_id]
set default_policy_exist_p [crs::resv_resrc::policy::get -by name -resource_id $room_id -policy_name default]
if !$default_policy_exist_p {
	crs::resv_resrc::policy::create_default -package_id $package_id -resource_id $room_id
	crs::resv_resrc::policy::get -by name -resource_id $room_id -policy_name default
}
set policy_id $policy_info(policy_id)
set policy_edit_url "policy-ae?[export_url_vars policy_id resource_id=$room_id resource_type=room]"
set return_url "../room?[export_url_vars room_id]"
set policy_assign_url "policy/policy-assign?[export_url_vars resource_id=$room_id policy_id return_url]"


ad_return_template


