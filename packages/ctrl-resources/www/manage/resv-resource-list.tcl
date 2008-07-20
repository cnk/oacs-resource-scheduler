ad_page_contract {
    List room reservations

    @author KH
    @cvs-id $Id$
    @creation-date 2005-12-14
} {
    {page:naturalnum 1}
    {page_size:naturalnum 10}
}

ad_maybe_redirect_for_registration
set user_id [ad_conn user_id]

set package_id [ad_conn package_id]
if ![info exists subsite_id] {
   set subsite_id [ad_conn subsite_id]
}

set return_url [export_vars -base resv-resource-list]
set start_row [expr ($page-1)*$page_size+1]
set end_row [expr $page*$page_size]

set create_p [permission::permission_p -object_id $package_id -privilege create -party_id  $user_id]
if $create_p {
    set create_link [list "Add Reservable Equipment" [export_vars -base reservable-ae] "Add Reservable Equipment"]
} else {
    set create_link ""
}

db_multirow -extend [list edit_link delete_link view_url]  resv_resource_list resv_resource_list {**SQL**} {
    set edit_link_url [export_vars -base reservable-ae {resource_id}]
    set edit_link "<a href='$edit_link_url'>Edit</a>"
    set delete_link_url [export_vars -base reservable-delete [list return_url resource_id]]
    set delete_link "<a href='$delete_link_url'>Delete</a>"
    set view_url "resv-resource?[export_url_vars resource_id]"
}

template::list::create -name resv_resource_list_display -multirow resv_resource_list \
    -key room_id \
   -no_data "There are no general equipment for you to manage" \
    -actions $create_link \
    -page_size $page_size \
    -page_query_name resv_resource_id_list \
    -elements {
	name {
	    label "Equipment"
	    display_template "<a href='@resv_resource_list.view_url@'>@resv_resource_list.name@</a>"
	}
	resource_category_name {
	    label "Category"
	}
	enabled_p {
	    label "Enabled?"
	    display_template "<if @resv_resource_list.enabled_p@ eq t>Yes</if><else>No</else>"
	}
	services {
	    label "Services"
	}
	actions {
	    label "Actions"
	    display_template "@resv_resource_list.edit_link;noquote@ @resv_resource_list.delete_link;noquote@"
	}
    }

set title "General Reservable Equipment List"
set context [list $title]
set cnsi_context_bar [crs::cnsi::context_bar -page_title $title -manage_p 1]


ad_return_template
