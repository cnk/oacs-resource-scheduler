# /packages/institution/www/admin/personnel/jccc-ae.tcl

ad_page_contract {
    
    Add / Edit JCCC Personnel Information
    
    @author	        avni@ctrl.ucla.edu (AK)
    @creation-date	2004/11/05
    @cvs-id		$Id: jccc-ae.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
    
    @param personnel_id
} {
    {personnel_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

set personnel_exists_p	[db_0or1row personnel_exist "select first_names, middle_name, last_name from persons where person_id = :personnel_id"]
if {!$personnel_exists_p} {
    ad_return_error "Error" "There is no personnel with this ID. Please contact your <a href=mailto:[ad_host_administrator]>system administrator</a> if you have any questions."
    return
}

set jccc_personnel_exists_p [db_string jccc_personnel_exists {select count(*) from jccc_personnel where personnel_id = :personnel_id}]
if {$jccc_personnel_exists_p} {
    set jccc_personnel_id $personnel_id
}

# checking permissions in here
permission::require_permission -object_id $personnel_id -privilege "write"

# Make sure personnel is a JCCC personnel
set jccc_member_p [inst::jccc::member_p -personnel_id $personnel_id]
if {!$jccc_member_p} {
    ad_return_error "Error" "The personnel you selected is not a JCCC Personnel. You have reached this page in error.
    Please contact your system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you
    have any questions. Thank you."
    return
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
	[list [ad_conn package_url] "Faculty Editor"] \
	[list [set subsite_url]institution/personnel/ "Personnel Index"] \
	"Edit JCCC Personnel Information"]]

set title "Edit JCCC Personnel Information for $first_names $last_name"
set personnel_error 0

ad_form -name jccc_ae -form {
    jccc_personnel_id:key
    {nci_funding_p:text(select)              {label "<font color=#f40219>*</font> NCI Funding"} {options {{-- {}} {"Yes" t} {"No" f}}}}
    {expired_p:text(select)                  {label "<font color=#f40219>*</font> Expired"} {options {{-- {}} {"Yes" t} {"No" f}}}}
    {expired_comment:text(textarea),optional {label "Expired Comment"} {html {rows 10 cols 50}}}
    {core_p:text(select)                     {label "<font color=#f40219>*</font> Core Member"} {options {{-- {}} {"Yes" t} {"No" f}}}}
    {regular_p:text(select)                  {label "<font color=#f40219>*</font> Regular Member"} {options {{-- {}} {"Yes" t} {"No" f}}}}
    {split_member_p:text(select)             {label "<font color=#f40219>*</font> Split Member"} {options {{-- {}} {"Yes" t} {"No" f}}}}
    {membership_status:text,optional         {label "Membership Status"} {html {maxlength 1000}}}
    {notes:text(textarea),optional           {label "Notes"} {html {rows 10 cols 50}}}
    {submit:text(submit) {label "Edit"}}
} -new_data {
    
    set personnel_error 0
    db_transaction {
	db_dml jccc_personnel_add {}
    } on_error {
	set personnel_error 1
	db_abort_transaction
    }
    if {$personnel_error} {
	ad_return_error "Error" "There was an error updating the JCCC Personnel Information.<p> $errmsg"
	return
    }

} -edit_data {
    
    # edit all currently displayed information
    set personnel_error 0
    db_transaction {
	db_dml jccc_personnel_edit {}
    } on_error {
	set personnel_error 1
	db_abort_transaction
    }
    if {$personnel_error} {
	ad_return_error "Error" "There was an error updating the JCCC Personnel Information.<p> $errmsg"
	return
    }
} -select_query_name {jccc_info_select} -export {personnel_id} -after_submit {
    ad_returnredirect "detail?[export_vars {personnel_id}]"
}

