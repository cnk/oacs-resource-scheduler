ad_page_contract {
    List resources

    @author KH
    @cvs-id $Id$
    @creation-date 2005-12-14
} {
    {page:naturalnum 1}
    {page_size:naturalnum 10}
}


set package_id [ad_conn package_id]
set return_url [export_vars -base resource-list]
set start_row [expr ($page-1)*$page_size+1]
set end_row [expr $page*$page_size]

db_multirow -extend [list dimensions edit_link add_image_link delete_link]  resource_list resource_list {**SQL**} {
    set edit_link_url [export_vars -base ae {resource_id}]
    set edit_link "<a href='$edit_link_url'>Edit</a>"
    set add_image_link_url [export_vars -base image-add {resource_id}]
    set add_image_link "<a href='$add_image_link_url'>Add Images</a>"
    set delete_link_url [export_vars -base resource-delete {resource_id return_url}]
    set delete_link "<a href='$delete_link_url'>Delete</a>"
}

template::list::create -name resource_list_display -multirow resource_list \
    -key resource_id \
    -actions [list "Add Resource" [export_vars -base ae] "Add Resource"] \
    -page_size $page_size \
    -page_flush_p 1 \
    -page_groupsize 10 \
    -page_query_name resource_id_list \
    -no_data {No resources} \
    -elements {
	name {
	    label "Resource Name"
	}
	resource_category_name {
	    label "Category"
	}
	services {
	    label "Services"
	}
	enabled_p {
	    label "Enabled?"
	}
	actions {
	    label "Actions"
	    display_template "@resource_list.edit_link;noquote@ @resource_list.delete_link;noquote@ @resource_list.add_image_link;noquote@"
	}
    }

set context [list [list index Resources] "Resource List"]
set title "Resource List"


ad_return_template

