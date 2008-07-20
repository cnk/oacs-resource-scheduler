# /packages/ctrl-events/www/admin/objects.tcl

ad_page_contract {

    List Event Objects
    
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 12/5/2005
    @cvs-id $Id: objects.tcl,v 1.1 2006/08/02 22:50:43 avni Exp $
} {
    {object_type_id:naturalnum "0"}
} -properties {
    object_list:multirow
}

set subsite_url [site_node_closest_ancestor_package_url]
set context_id [ad_conn package_id]

if {$object_type_id !=0 && ![empty_string_p $object_type_id]} {
    # Make sure the object_type exists
    set object_type_exists_p [ctrl_event::category::exists_p $object_type_id]
    if {!$object_type_exists_p} {
	ad_return_error "Error" "You have selected an object type
	that no longer exists in the database. Please contact your system administrator
	if you have any questions."
	return
    }
    set object_type_constraint_clause "and ceo.category_id = :object_type_id"
    set object_type_name [ctrl_event::category::get_info $object_type_id "name"]
} else {
    set object_type_constraint_clause ""
    set object_type_name ""
}

set title "Event Objects"
db_multirow object_list object_list_query {}

set object_type_options [ctrl_event::category::get_category_options -context_id $context_id]

ad_form -name object_type_list -form {
    {object_type_id:integer(select) {label "Object Type: "} {value $object_type_id} {options $object_type_options}}
    {submit_filter:text(submit)     {label "Go"}}
}

set object_add_link "<a href=\"object-add\">Add Event Object</a>"
