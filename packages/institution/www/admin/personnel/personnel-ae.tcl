# /packages/institution/www/personnel/personnel-ae.tcl		-*- tab-width: 4 -*-

ad_page_contract {

	Add / Edit Personnel

	@author			nick@ucla.edu
	@author			avni@ctrl.ucla.edu
	@creation-date	2004/01/12
	@cvs-id			$Id: personnel-ae.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param personnel_id
	@param group_id
	@param physician_p if phyisican=1, redirect to insert physician page
} {
	{personnel_id:naturalnum,optional	}
	{group_id:integer,optional			}
	{physician_p:integer				0}
	{return_url							""}
	{step:naturalnum,optional			}
}

set indefinite_article					"a"
set object_type_key						"person"
set object_type							"Personnel"
set user_id								[ad_conn user_id]
set peer_ip								[ad_conn peeraddr]
set package_id							[ad_conn package_id]
set subsite_url							[site_node_closest_ancestor_package_url]

set sitewide_admin_p					[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]
set admin_through_group_p				0
set personnel_is_physician_p			0

set photo_info ""

# CHECK PERMISSIONS ############################################################
if {[exists_and_not_null personnel_id] && [ns_queryget "action" "Edit"] == "Edit"} {
	# if this is the second step in an 'add', skip the check to make sure the personnel exists

	# Get Personnel Data
	if {![db_0or1row personnel_info {}]} {
		ad_return_complaint 1 "The $object_type you requested does not exist in the database."
		return
	}

	# setup some 'edit' urls
	# Delete
	if {[permission::permission_p -object_id $personnel_id -privilege "delete"]} {
		set personnel_delete_url		"delete?[export_vars {personnel_id return_url}]"
	}

	# Permit
	if {[permission::permission_p -object_id $personnel_id -privilege "admin"]} {
		set subsite_url					[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
		set personnel_permit_url		"${subsite_url}permissions/one?[export_vars -override {{object_id $personnel_id}}]"
	}

	if {[permission::permission_p -object_id $personnel_id -privilege "admin"] || [permission::permission_p -object_id $personnel_id -privilege "write"]} {
		set admin_through_group_p 1
	}

	set action						"Edit"
	set user_execute_action			"Save Changes"
	set can_delete_or_permit_p		[expr [exists_and_not_null personnel_delete_url] || [exists_and_not_null personnel_permit_url]]

	# This is used in the case where a user makes a mistake that causes the edit
	#	(or ADD!) not to validate.	In that case, none of the bodies of ad_form
	#	get called and we still need the 'title' display variable
	set old_action										[ns_queryget action ""]
	if {![empty_string_p $old_action]} {
		set old_action							"to $old_action $indefinite_article $object_type"
	}
} elseif {[exists_and_not_null group_id]} {
	# check for permission to create a personnel in the group
	permission::require_permission -object_id $group_id -privilege "create"
	set admin_through_group_p 1

	set action							"Add"
	set user_execute_action				"Save"
	set can_delete_or_permit_p			0
} else {
	# require 'create' on package to create new personnel
	permission::require_permission -object_id $package_id -privilege "create"
	set admin_though_group_p 1

	set action							"Add"
	set user_execute_action				"Save"
	set can_delete_or_permit_p			0
}
# END CHECK PERMISSIONS ########################################################

# "WIZARD" STUFF ###############################################################
if {[exists_and_not_null step]} {
		append user_execute_action		" & Return to Step $step"
}
# END "WIZARD" STUFF ###########################################################

set context						[list [list "../$object_type_key/" $object_type] $action]
set reqd						{<b style="color: red">*</b>}
# a default value for dates
set now							[template::util::date::today]

set n 0

# BUILDING FORM ELEMENTS ####################################################################################################
# Photo Info
if {[exists_and_not_null photo_p] && $photo_p} {
	set photo_info "
	[template::adp_parse [acs_root_dir]/packages/[ad_conn package_key]/www/photo-template [list personnel_id $personnel_id max_width 100 max_height 125]]
	<br><a href=\"photo-delete?[export_vars {personnel_id}]\">Delete</a>
	"
}

# Determine if the current user logged in has privileges over the personnel
#		fields:
#				start_date,
#				end_date,
#				gender,
#				employee_number,
#				status_id,
#				birthdate
# This is done by seeing if the user has admin or write over the personnel

set form_elements		{
	personnel_id:key
	{physician_p:integer(hidden),optional	{value $physician_p}}
}


	if {$admin_through_group_p || $sitewide_admin_p || $personnel_is_physician_p} {
		if {$action == "Add" || [ns_queryget __new_p 0] == "1"} {
			append form_elements {
				{faculty_p:text(checkbox),optional		{label "Is This Person a Faculty Member?:"} {options {{"" "t"}}} }
			}
		} else {
			append form_elements {
				{faculty_p:text(hidden),optional}
			}
		}
	} else {
		append form_elements {
			{faculty_p:text(hidden),optional}
		}
	}

	if {!$personnel_is_physician_p} {
		append form_elements {
			{first_names:text							{label "<font color=f40219>*</font> First Name"}}
			{middle_name:text,optional					{label "Middle Name"}}
			{last_name:text										{label "<font color=f40219>*</font> Last Name"}}
		}
	} else {
		append form_elements {
			{first_names:text(inform)			{label "<font color=f40219>*</font> First Name"}}
			{middle_name:text(inform),optional	{label "Middle Name"}}
			{last_name:text(inform)						{label "<font color=f40219>*</font> Last Name"}}
		}
	}

	append form_elements {
		{preferred_first_name:text,optional		{label "Preferred First Name"}}
		{preferred_middle_name:text,optional	{label "Preferred Middle Name"}}
		{preferred_last_name:text,optional		{label "Preferred Last Name"}}
	}

	if {$admin_through_group_p || $sitewide_admin_p} {
		append form_elements {
			{employee_number:integer,optional	{label "UCLA Employee ID"}		{maxlength 9}}
			{gender:text(select),optional				{label "Gender"}						{options {{-- {}} {"Male" m} {"Female" f}}}}
			{date_of_birth:date,optional				{label "Birth Date"}}
		}
	} else {
		append form_elements {
			{employee_number:integer(hidden)}
			{gender:text(hidden),optional}
			{date_of_birth:date(hidden),optional}
		}
	}

	append form_elements {
		{bio:text(textarea),optional					{label "Bio"}			{html {rows 10 cols 50}}
			{tooltip {[append unused \
				"Please write your bio in the third person. Your bio should	 describe you and your background-- not your research interests.	If it " \
				"does describe your research interests, please move it into the lay research " \
				"interest field located in Step 2. "]
				 }
			 }
			{help_text {
				Please write your bio in the third person. Your bio should describe you and	 your background-- not your research interests.
				Click <a href="example-bio?[export_vars {personnel_id}]">here</a> for an example.		 If your bio  does describe your research interests,
				please move it into the lay research interest field located in Step 2 by clicking <a href="../research-interests/bio-to-lay-interest?[export_vars {personnel_id}]">
				here</a>.
				}
			}
		}
		{meta_keywords:text(text),optional              {label "Keywords"}             {html {size 40}}
		    {help_text {
				Please separate keywords with commas.
		        }   
            }
	    }
	}

	if {$admin_through_group_p || $sitewide_admin_p} {
		set status_id_options	[personnel::ui::status_select_options]
		append form_elements {
			{status_id:integer(select)					{label "Status"}		{options $status_id_options}}
			{start_date:date,optional					{label "Start Date"}}
			{end_date:date,optional								{label "End Date"}}
			{notes:text(textarea),optional						{label "Notes"}			{html {rows 10 cols 50}} \
					{help_text "Internal use only - not displayed to public."}}
		}
	} else {
		set default_status_id [db_string status_active_id {select category.lookup('//Personnel Status//Active') from dual}]
		append form_elements {
			{status_id:integer(hidden)}
			{start_date:date(hidden),optional}
			{end_date:date(hidden),optional}
			{notes:text(hidden),optional}
		}
	}

set language_options [db_list_of_lists all_languages {}]

if {[exists_and_not_null personnel_id]} {
	set language_values [db_list_of_lists get_languages {}]
} else {
	set language_values [list {"en"}]
}

if {$admin_through_group_p || $sitewide_admin_p || $personnel_is_physician_p} {
	append form_elements {
		{languages:text(multiselect),multiple,optional	{label "Languages"}		{html {size 8}} {options $language_options} {values $language_values}}
	}
} else {
	append form_elements {
		{languages:text(hidden),optional}
	}
}

append form_elements {
	{photo_current:text(inform),optional		{label "Current Portrait"} {before_html $photo_info}}
	{photo:text(file),optional					{label "Portrait"}}
	{submit:text(submit)						{label $user_execute_action}}
	{required:text(inform)						{label "&nbsp;"} {value "Fields marked with a <q>$reqd</q> are required."}}
}
# END BUILDING FORM ELEMENTS ####################################################################################################


ad_form -name "personnel_ae" -html {enctype "multipart/form-data"} -export {group_id action return_url step} -method {post} -form "$form_elements"	\
-select_query_name {personnel_info} -on_request {

	# We check this here because it will cause 'Add' to fail if we put it above
	# since when the data is submitted from the 'Add', it returns to this page
	# as an 'Edit' before the insert is performed and the user is finally
	# returned to where they linked here from initially.
	if {$action == "Edit"} {
		permission::require_permission -object_id $personnel_id -privilege "write"
	}
} -on_submit {

	if ![exists_and_not_null languages] {
		set submitted_languages ""
	} else {
		set submitted_languages $languages
	}

	############################################################################
	# Pre-process date-widget data into default SQL form
	set start_date				[join [lrange $start_date 0 2] "-"]
	set end_date				[join [lrange $end_date 0 2] "-"]
	set date_of_birth			[join [lrange $date_of_birth 0 2] "-"]

	# if dates exist, make sure start-date before end-date
	if {![empty_string_p $start_date] && ![empty_string_p $end_date]} {
		set start_date_after_p [db_string start_date_after_p {} -default 0]

		if {$start_date_after_p} {
			ad_return_complaint 1 {
				The Start Date of the personnel must be before the End Date.
				Please go back, correct this problem, and resubmit your input.
			}
			ad_script_abort
		}
	}
} -new_data {
	if {[db_string institution_admin_p {} -default 0] == 0} {
		#//TODO// better/more accurate permission check/message
		permission::require_permission -object_id $package_id -privilege "admin"
	}

	db_transaction {
		if {[exists_and_not_null employee_number]
			&& ![db_string employee_number_unique_p {} -default 1]} {

			db_1row other_person_with_employee_number {}
			set other_person_url [export_vars -base detail {personnel_id}]
			ad_return_complaint 1 "
				This is already person with the UCLA Employee ID
				<q>$employee_number</q>.  This other person is named
				<q><a href=\"$other_person_url\">$other_person</a></q>.
			"
		} else {
			set error_p 0
			db_transaction {
				set personnel_id [personnel::personnel_add				\
					-first_names			"$first_names"				\
					-middle_name			"$middle_name"				\
					-last_name				"$last_name"				\
					-preferred_first_name	"$preferred_first_name"		\
					-preferred_middle_name	"$preferred_middle_name"	\
					-preferred_last_name	"$preferred_last_name"		\
					-employee_number		"$employee_number"			\
					-gender					"$gender"					\
					-status_id				"$status_id"				\
					-notes					"$notes"					\
					-meta_keywords          "$meta_keywords"            \
					-bio					"$bio"						\
					-photo					"$photo"					\
					-languages				"$submitted_languages"		\
					-real_start_date		"$start_date"				\
					-real_end_date			"$end_date"					\
					-real_date_of_birth		"$date_of_birth"			\
					-context_id				"$user_id"]

				if {[exists_and_not_null faculty_p] && $faculty_p == "t"} {
					db_dml make_faculty {
						insert into inst_faculty(faculty_id) values (:personnel_id)
					}
				}
			}
		}
	}
} -edit_data {
	permission::require_permission -object_id $personnel_id -privilege "write"
	set error_p 0
	db_transaction {
		personnel::personnel_edit -personnel_id "$personnel_id"			\
				-first_names			"$first_names"					\
				-middle_name			"$middle_name"					\
				-last_name				"$last_name"					\
				-preferred_first_name	"$preferred_first_name"			\
				-preferred_middle_name	"$preferred_middle_name"		\
				-preferred_last_name	"$preferred_last_name"			\
				-employee_number		"$employee_number"				\
				-gender					"$gender"						\
				-status_id				"$status_id"					\
				-notes					"$notes"						\
				-meta_keywords          "$meta_keywords"                \
				-bio					"$bio"							\
				-photo					"$photo"						\
				-languages				"$submitted_languages"			\
				-real_start_date		"$start_date"					\
				-real_end_date			"$end_date"						\
				-real_date_of_birth		"$date_of_birth"
	}
} -after_submit {
	if {$physician_p} {
		template::forward "physician-ae?[export_vars {personnel_id group_id return_url}]"
	} elseif {[exists_and_not_null group_id]} {
		template::forward "${subsite_url}institution/admin/title/add-edit?[export_vars {personnel_id group_id return_url}]"
	} elseif {[exists_and_not_null return_url]} {
		template::forward $return_url
	} else {
		template::forward "detail?[export_vars personnel_id]"
	}
}

ad_form -extend -name "personnel_ae" -form {
} -select_query_name {personnel_info}

