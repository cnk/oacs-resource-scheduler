# -*- tab-width: 4 -*-
# /packages/institution/www/personnel/physician-ae.tcl
ad_page_contract {
    Add / Edit Physician

	@author			nick@ucla.edu
	@creation-date	2004/02/18
	@cvs-id			$Id: physician-ae.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@param			personnel_id
} {
    {physician_id:integer,optional	}
    {personnel_id:integer,notnull	}
    {group_id:integer				0}
	{return_url						[get_referrer]}
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

# verify current personnel.
if {![exists_and_not_null physician_id] && [personnel::physician_exists_p -personnel_id $personnel_id]} {
    ad_return_error "Error" "The personnel is already a physician."
    return
}

# checking permissions in here
if {[exists_and_not_null physician_id] && [personnel::personnel_exists_p -personnel_id $personnel_id]} {
    set button_title "Edit"
    # require 'write' to edit exisiting personnel
    permission::require_permission -object_id $personnel_id -privilege "write"
} else {
	set button_title "Add"
	if {![personnel::personnel_exists_p -personnel_id $personnel_id]} {
		ad_return_error "Error" "The personnel does not exist."
		return
	}
	# require 'create' to create new personnel
	permission::require_permission -object_id $package_id -privilege "create"
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [ad_conn package_url] "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Physician $button_title"]]

set title "$button_title Physician"
set personnel_error 0
set no_preference "(No Preference)"

set true t

ad_form -name physician_ae -html {
	enctype "multipart/form-data"
} -form {
	physician_id:key
	{group_id:integer(hidden)					{value $group_id}}
	{years_of_practice:integer,optional			{label "Years of Practice"}}
	{primary_care_physician_p:text(select)		{label "<font color=#f40219>*</font> Primary Care Physician"} {options {{"Yes" t} {"No" f}}}}
	{accepting_patients_p:text(select)			{label "<font color=#f40219>*</font> Accepting Patients"} {options {{"Yes" t} {"No" f}}} }
	{marketable_p:text(select)					{label "<font color=#f40219>*</font> Marketable"} {options {{"Yes" t} {"No" f}}} }
	{typical_patient:text(textarea),optional	{label "Typical Patient"} {html {rows 10 cols 50}}}
	{submit:text(submit)						{label $button_title}}
} -export {personnel_id} -new_data {
	# create new physician with all currently displayed information
	set personnel_error 0
	db_transaction {
		personnel::physician_add -personnel_id	$personnel_id				\
			-years_of_practice					$years_of_practice			\
			-primary_care_physician_p			$primary_care_physician_p	\
			-accepting_patients_p				$accepting_patients_p		\
			-marketable_p						$marketable_p				\
			-typical_patient					$typical_patient
	} on_error {
		set personnel_error 1
		db_abort_transaction
	}

	if {$personnel_error} {
		ad_return_error "Error" "PHYSICIAN NOT ADDED PROPERLY - $errmsg"
		return
	}
} -edit_data {
	# edit all currently displayed information
	set personnel_error 0
	db_transaction {
		personnel::physician_edit -personnel_id	$personnel_id				\
			-years_of_practice					$years_of_practice			\
			-primary_care_physician_p			$primary_care_physician_p	\
			-accepting_patients_p				$accepting_patients_p		\
			-marketable_p						$marketable_p				\
			-typical_patient					$typical_patient
	} on_error {
		set personnel_error 1
		db_abort_transaction
	}
	if {$personnel_error} {
		ad_return_error "Error" "PHYSICIAN NOT UPDATED PROPERLY - $errmsg"
		return
	}
} -select_query {
	select	years_of_practice,
			primary_care_physician_p,
			accepting_patients_p,
			marketable_p,
			typical_patient
	  from	inst_physicians
	 where	physician_id = :physician_id
} -after_submit {
	if {![exists_and_not_null return_url]} {
	 	if {$group_id} {
			set return_url "../title/add-edit?[export_vars {personnel_id group_id}]"
		} else {
			set return_url "detail?[export_vars personnel_id]"
		}
	}
	template::forward $return_url
}
