# /packages/institution/www/admin/groups/jccc-ae.tcl

ad_page_contract {
    
    Add / Edit JCCC Group Information
    
    @author	        avni@ctrl.ucla.edu (AK)
    @creation-date	2004/11/05
    @cvs-id		$Id: jccc-ae.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
    
    @param group_id
} {
    {group_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

set group_exists_p	[db_0or1row group_exist "select group_name from groups where group_id = :group_id"]
if {!$group_exists_p} {
    ad_return_error "Error" "There is no group with this ID. Please contact your <a href=mailto:[ad_host_administrator]>system administrator</a> if you have any questions."
    return
}

set jccc_group_exists_p [db_string jccc_group_exists {select count(*) from jccc_groups where group_id = :group_id}]
if {$jccc_group_exists_p} {
    set jccc_group_id $group_id
}

# checking permissions in here
permission::require_permission -object_id $group_id -privilege "write"

# Make sure group is a JCCC group
set jccc_group_p [inst::jccc::group_p -group_id $group_id]
if {!$jccc_group_p} {
    ad_return_error "Error" "The group you selected is not a JCCC Group. You have reached this page in error.
    Please contact your system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you
    have any questions. Thank you."
    return
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
	[list [ad_conn package_url] "Faculty Editor"] \
	[list [set subsite_url]institution/group/ "Group Index"] \
	"Edit JCCC Group Information"]]

set title "Edit JCCC Group Information for $group_name"
set group_error 0

ad_form -name jccc_ae -form {
    jccc_group_id:key
    {nci_code:text         {label "NCI Code"} {html {maxlength 10}}}
    {submit:text(submit) {label "Edit"}}
} -new_data {
    
    # create new faculty with all currently displayed information
    set group_error 0
    db_transaction {
	db_dml jccc_group_add {}
    } on_error {
	set group_error 1
	db_abort_transaction
    }
    if {$group_error} {
	ad_return_error "Error" "There was an error updating the JCCC Group Information.<p> $errmsg"
	return
    }

} -edit_data {
    
    # edit all currently displayed information
    set group_error 0
    db_transaction {
	db_dml jccc_group_edit {}
    } on_error {
	set group_error 1
	db_abort_transaction
    }
    if {$group_error} {
	ad_return_error "Error" "There was an error updating the JCCC Group Information.<p> $errmsg"
	return
    }
} -select_query_name {jccc_info_select} -export {group_id} -after_submit {
    ad_returnredirect "detail?[export_vars {group_id}]"
}

