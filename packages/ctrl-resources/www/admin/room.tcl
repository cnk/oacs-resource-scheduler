ad_page_contract {
    Display the information and resources for the room

    @author KH
    @cvs-id $id$
    @creation-date 2005-12-15
} {
    room_id:naturalnum,notnull
}

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $room_id -privilege read
crs::room::get -room_id $room_id -column_array room_info

set return_url [export_vars -base room room_id]

db_multirow -extend [list edit_link delete_link action] resource_list resource_list {**SQL**} {
    if [string equal $reservable_p Yes] {
	set edit_link [export_vars -base reservable-ae [list return_url resource_id]]
	set delete_link [export_vars -base reservable-delete [list return_url resource_id]]
    } else {
	set edit_link [export_vars -base ae [list return_url resource_id]]
	set delete_link [export_vars -base resource-delete [list return_url resource_id]]
    }
}

db_multirow -extend [list calendar_link] calendar_view calendar_view {**SQL**} {
    set calendar_link [export_vars -base /calendar/view-month [list calendar_id]]
}

set parent_resource_id $room_id

template::list::create -name resource_list_display -multirow resource_list \
    -key room_id \
    -actions [list "Add A Non-Reservable Resource" [export_vars -base ae [list parent_resource_id return_url]] "Add Resource"  \
		  "Add A Reservable Resource  " [export_vars -base reservable-ae [list parent_resource_id return_url]] "Add A Reservable Resource"] \
    -no_data "No Resources specified" \
    -elements {
	name {
	    label "Resource Name"
	}
	resource_category_name {
	    label "Category"
	}
	quantity {
	    label Qty
	}
	enabled_p {
	    label "Enabled?"
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
    set request_details [export_vars -base request/request {request_id}]
}

template::list::create -name request_list_display -multirow request_list \
    -no_data "There are no requests" \
    -elements {
	request_details {
	    label "Request Name"
	    display_template "<a href='@request_list.request_details;noquote@'>@request_list.name@</a>"
	}
	description {
	    label "Description"
	}
	status {
	    label "Status"
	}
	reserved_by {
	    label "Reserved By"
	} 
    }

set context [list [list index Resources] [list "room-list" "Room List"] "One Room"]
set title "$room_info(name) Room"

ad_return_template


