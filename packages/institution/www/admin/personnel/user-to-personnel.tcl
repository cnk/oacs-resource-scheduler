# -*- tab-width: 4 -*-
ad_page_contract {
	Add / Edit Personnel

	@author			nick@ucla.edu
	@creation-date	2004/03/17
	@cvs-id			$Id: user-to-personnel.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param personnel_id
} {
	{personnel_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

# checking permissions in here
if {![personnel::user_exists_p -personnel_id $personnel_id]} {
	ad_return_complaint "Error" "User ID does not exist"
	return
} else {
	set employee_check [db_string varify_unique_employee_number "select count(*) from inst_personnel where personnel_id = :personnel_id"]
	if $employee_check {
		ad_return_complaint "Error" "Error: This Personnel ID already exists in the database"
		return
	}
	set button_title "Add"
	set title "$button_title Personnel"
	# require 'create' to create new personnel
	permission::require_permission -object_id $package_id -privilege "create"
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [ad_conn package_url] "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Personnel $button_title"]]

set first_names ""
set last_name ""
db_1row get_name "select first_names, last_name from persons where person_id = :personnel_id"


set language_options [db_list_of_lists all_languages {}]
set status_id_options	[personnel::ui::status_select_options]

#{personnel_id:integer(hidden)						 {value $personnel_id}}

ad_form -name {user} -html {enctype "multipart/form-data"} -form {
	{first_names:text					{label "<font color=f40219>*</font> First Name"} {value $first_names}}
	{last_name:text						{label "<font color=f40219>*</font> Last Name"} {value $last_name}}
	{employee_number:integer,optional	{label "UCLA Employee ID"}}
	{gender:text(select),optional		{label "Gender"}	{options {{"Male" m} {"Female" f}}}}
	{date_of_birth:date,optional		{label "Birth Date"}	{format "MON DD YYYY"}}
	{bio:text(textarea),optional		{label "Bio"}		{html {rows 10 cols 50}}}
	{status_id:integer(select),optional	{label "Status"}	{options $status_id_options}}
	{start_date:date,optional			{label "Start Date"}	{format "Mon DD YYYY"}}
	{end_date:date,optional				{label "End Date"}	{format "Mon DD YYYY"}}
	{notes:text(textarea),optional		{label "Notes"}		{html {rows 10 cols 50}}}
	{languages:text(multiselect),multiple,optional	{label "Languages"}	{html {size 8}} {options $language_options}}
	{photo:text(file),optional			{label "Photo"}}
	{submit:text(submit)				{label "$button_title Personnel"}}
} -on_submit {
	# formating all dates so they can be inserted
	if {![empty_string_p $date_of_birth]} {
		set real_date_of_birth "[lindex $date_of_birth 0]-[lindex $date_of_birth 1]-[lindex $date_of_birth 2]"
	} else {
		set real_date_of_birth ""
	}
	if {![empty_string_p $start_date]} {
		set real_start_date "[lindex $start_date 0]-[lindex $start_date 1]-[lindex $start_date 2]"
	} else {
		set real_start_date ""
	}
	if {![empty_string_p $end_date] && ![empty_string_p $start_date]} {
		set real_end_date "[lindex $end_date 0]-[lindex $end_date 1]-[lindex $end_date 2]"
		# check to see if start date before end date
		set start_date_after_p [db_string events_start_date_after_p {} -default 0]

		if {$start_date_after_p} {
			ad_return_complaint "Error" "The Start Date of the personnel must be before the End Date. Please go back and check your dates. Thank you."
			return
		}
	} else {
		set real_end_date ""
	}
} -after_submit {
	#validating uniquness of employee number
	set unique_id [db_string get_id_count "select count(*) from inst_personnel where employee_number = :employee_number"]
	if $unique_id {
		ad_return_error "Error" "The Employee ID entered is already taken"
		return
	}

	set error_p 0
	db_transaction {
		set personnel_id [personnel::user_to_personnel				\
							-personnel_id 		$personnel_id 		\
							-first_names 		$first_names 		\
							-last_name 			$last_name 			\
							-employee_number	$employee_number	\
							-gender 			$gender 			\
							-status_id 			$status_id 			\
							-notes 				$notes 				\
							-bio 				$bio 				\
							-photo 				$photo 				\
							-languages 			$languages 			\
							-real_start_date 	$real_start_date 	\
							-real_end_date 		$real_end_date 		\
							-real_date_of_birth $real_date_of_birth	]
	} on_error {
		set error_p 1
		db_abort_transaction
	}

	if $error_p {
		ad_return_error "Error Converting User to Personnel" "PERSONNEL NOT ADDED PROPERLY <p> $errmsg"
		return
	}

	template::forward "detail?[export_vars personnel_id]"
} -export {personnel_id}
