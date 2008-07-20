# /packages/ctrl-calendar/www/ae.tcl

ad_page_contract {

    Add A New Calendar into the DB

    @author jeff@ctrl.ucla.edu (JW)
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2005-12-18
    @cvs-id $Id$

    @param request_id primary key

} {
    cal_id:naturalnum,optional
    {cal_type:optional "public"}
    {return_url ""}
} 

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

set title "Add/Edit"

set context_id $package_id
set main_subsite_id [ctrl_procs::subsite::get_main_subsite_id]
set subsite_list_options "[list [list "Main Site" $main_subsite_id]] [db_list_of_lists get_subsite_list {}]"

if {[exists_and_not_null cal_id]} {
    set subsite_id_list [db_list get_calendar_subsite_id_list {}]
} else {
    set subsite_id_list [list]
}

ad_form -name "ae" -form {
    cal_id:key
    {cal_name:text(text)                     {label "Name: "} {html {size 50 maxlength 255}}} 
    {description:text(textarea),optional     {label "Description: "} {html {rows 10 cols 55}}} 
    {subsite_id_list:text(checkbox),optional,multiple {label "Departments: "} {options $subsite_list_options} 
	{help_text "Please select which web sites on which you would like this calendar to display."} }
} -new_request {
    permission::require_permission -object_id $package_id -privilege "create"
} -new_data {
    permission::require_permission -object_id $package_id -privilege "create"

    if {[string equal $cal_type public]} {
	set owner_id ""
    } else {
	set owner_id $user_id
    }

    set var_list [list \
		      [list cal_name $cal_name] \
		      [list description $description] \
		      [list owner_id $owner_id] \
		      [list object_id $cal_id] \
		      [list context_id $package_id] \
		      [list cal_id $cal_id] \
		      [list package_id $package_id]]

    set error_p 0
    db_transaction {
	ctrl::cal::new -var_list $var_list -subsite_id_list $subsite_id_list
	permission::grant -party_id $user_id -object_id $cal_id -privilege admin
    } on_error {
	set error_p 1
    }

    if $error_p {
	ad_return_error "Error creating calendar" "The system was not able to create a calendar due to the following error: <br> <pre>$errmsg</pre>"
	ad_script_abort
    }

} -edit_request {
    permission::require_permission -object_id $cal_id -privilege "write"
    ctrl::cal::get -cal_id $cal_id -column_array "cal_info"
    set cal_name $cal_info(cal_name)
    set description $cal_info(description)
    set object_id $cal_info(object_id)
} -edit_data {
    permission::require_permission -object_id $cal_id -privilege "write"
    ctrl::cal::update -cal_id $cal_id -cal_name $cal_name -description $description -subsite_id_list $subsite_id_list
} -after_submit {
    if ![empty_string_p $return_url] {
	ad_returnredirect $return_url
    } else {
	ad_returnredirect "."
    }
    ad_script_abort
} -export {return_url cal_type}


if [ad_form_new_p -key cal_id] {
    set title "Add Calendar of Events"
    set context "Add"
} else {
    set title "Update Calendar"
    set context "Update"
}
