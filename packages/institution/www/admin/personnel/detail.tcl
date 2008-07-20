# -*- tab-width: 4 -*-
# /packages/institution/www/admin/personnel/detail.tcl

ad_page_contract {
	@author		nick@ucla.edu
	@creation-date	2004/01/12
	@cvs-id		$Id: detail.tcl,v 1.4 2007/05/05 06:16:44 kellie Exp $
} {
	{personnel_id:naturalnum	{[ad_conn user_id]}}
}

set user_id	[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]
set subsite_url	[site_node_closest_ancestor_package_url]
set this_url	"[ad_conn url]?[export_vars {personnel_id}]"
set subsite_name [db_string subsite_name {select acs_object.name(:subsite_id) from dual} -default ""]

set sitewide_admin_p	[permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]

if {[db_0or1row personnel_info {}] <= 0} {
	ad_return_error "Error" "There is no Personnel that matches the Personnel ID"
	return
}

set context_bar			[ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
												  [list [ad_conn package_url] "Faculty Editor"] \
												  [list [ad_conn package_url]admin/personnel/ "Personnel Index"] "Detail for $first_names $last_name"]]
if {$user_id == $personnel_id} {
	set user_is_this_person_p 1
}

set date_of_birth		[util_AnsiDatetoPrettyDate $date_of_birth]
set start_date			[util_AnsiDatetoPrettyDate $start_date]
set end_date			[util_AnsiDatetoPrettyDate $end_date]

db_multirow languages			personnel_languages {}

set step 3

set morrissey_admin_p [db_string morrissey_admin_p {} -default 0]
db_multirow -extend {group_url detail_url edit_url delete_url} titles titles {} {
	set detail_url				"../title/detail?[export_vars {gpm_title_id step}]"
	if {$write_p && (!$from_morrissey_p || $morrissey_admin_p)} {
		set edit_url			"../title/add-edit?[export_vars {gpm_title_id step}]"
	} else {
		set edit_url			"../title/request-change?[export_vars -override {{change edit}} {acs_rel_id title_id step}]"
	}

	if {$delete_p && (!$from_morrissey_p || $morrissey_admin_p)} {
		set delete_url			"../title/delete?[export_vars {gpm_title_id step}]"
	} else {
		set delete_url			"../title/request-change?[export_vars -override {{change delete}} {acs_rel_id title_id step}]"
	}

	if {$admin_p} {
		set group_url			"../groups/detail?[export_vars {group_id step}]"
	}
}

set row_total 0
db_multirow -extend {expire_flag row_count} sttp_info			sttp_info {} {
	incr row_total
	set row_count $row_total
	if {$expiration_date < $todays_date} {
		set expire_flag 1
	} else {
		set expire_flag 0
	}
}

db_1row sttp_ct_expire_date {}
set publication_items [db_list_of_lists personnel_publications {}]

ad_form -name publications_display -method post -form {
	{personnel_id:text(hidden) {value $personnel_id}}
	{publication_item:text(checkbox),multiple,optional {label ""} {options $publication_items}}
	{submit:text(submit) {label "Remove Checked"}}
} -on_submit {
	set publication_ids [join $publication_item ","]
	ad_returnredirect "../publication/publication-map-delete-all?[export_url_vars {personnel_id} {publication_ids}]"
}

db_multirow publications personnel_publications {}

## Research Interests
set sttp_add		"../../admin/sttp/sttp-mentor-ae?[export_vars {personnel_id}]"
set sttp_delete		"../../admin/sttp/sttp-delete?[export_vars {personnel_id}]"
set sttp_edit		"../../admin/sttp/sttp-mentor-ae?[export_vars -override {{user_id $personnel_id}} {personnel_id}]"
set sttp_copy       "../../admin/sttp/sttp-mentor-ae-copy?[export_vars -override {{user_id $personnel_id}} {personnel_id}]"

# require 'admin' to edit personnel
set personnel_admin_p [permission::permission_p -object_id $personnel_id -privilege "admin"]
if {$sitewide_admin_p} {
	set personnel_permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $personnel_id}}]"
	if {[db_0or1row external_physician_id {}] > 0} {
		set morrissey_physician_data_url [export_vars -base "../../../healthsciences-data/inspector/physician" {ext_physician_id}]
	}
}

set publication_download_url "../publication/publication?"

# require 'create' to create new personnel
set personnel_create_p [permission::permission_p -object_id $personnel_id -privilege "create"]
set group_admin_p 0
if {$personnel_create_p} {
	# Determine if the current user logged in has privliges over the admin
	#	fields (start_date,end_date,gender,employee_number,status,birthdate)
	# We do this by seeing if the user has admin,write,create,delete over
	#	any of the groups the user belongs to
	set group_admin_p [db_string personnel_group_admin_p {} -default 0]

	set personnel_create_url	"personnel-ae"

	set publication_create_url	"../publication/publication-ae?[export_vars {personnel_id}]"
	set publication_endnote_url	"../publication/endnote-upload-info?[export_vars {personnel_id}]"
	set publication_subset_url	"../publication/order-subset-for-subsite-0?[export_vars -override {personnel_id subsite_id {step 4}}]"

	# //TODO// limit to subsites person is associated with (and has read permission on?)
	set subsites [db_list_of_lists subsites {
		select	instance_name, package_id
		  from	apm_packages
		 where	package_key = 'acs-subsite'
		 order	by instance_name
	}]
	set subsites [linsert $subsites 0 [list "(Default)"]]

	ad_form -name subsite_personnel_publication_edit		-method get \
		-action "../publication/order-subset-for-subsite"	\
		-export {personnel_id} \
		-form {
		{subsite_id:integer(select)		{label " "} {options $subsites}}
		{choose:integer(submit)			{label "Choose"}}
	}

	set physician_create_url				"physician-ae?[export_vars {personnel_id}]"
	set user_create_url						"user-ae?[export_vars {personnel_id}]"
	set faculty_create_url					"faculty-ae?[export_vars {personnel_id}]"
	set faculty_edit_url					"faculty-ae?[export_vars {personnel_id}]"

	set personnel_create_address_url		"../address/add-edit?[export_vars -override {{party_id $personnel_id} {return_url $this_url} {step 2}}]"
	set personnel_create_email_url			"../email/add-edit?[export_vars -override {{party_id $personnel_id} {return_url $this_url} {step 2}}]"
	set personnel_create_url_url			"../url/add-edit?[export_vars -override {{party_id $personnel_id} {return_url $this_url} {step 2}}]"
	set personnel_create_phone_url			"../phone-number/add-edit?[export_vars -override {{party_id $personnel_id} {return_url $this_url} {step 2}}]"
	set personnel_create_certification_url	"../certification/add-edit?[export_vars -override {{party_id $personnel_id} {return_url $this_url} {step 3}}]"
	set personnel_create_resume_url			"../resume/add-edit?[export_vars -override personnel_id {{return_url $this_url} {step 3}}]"
	set personnel_create_image_url			"../party-image/add-edit?[export_vars -override {{party_id $personnel_id} {return_url $this_url} {step 3}}]"
} else {
	set personnel_create_url	""
	set publication_create_url	""
	set publication_map_url		""
	set physician_create_url	""
	set user_create_url			""
	set faculty_create_url		""
}

# require 'delete' to delete new personnel
set personnel_delete_p			[permission::permission_p -object_id $personnel_id -privilege "delete"]
if {$personnel_delete_p} {
	if {$sitewide_admin_p} {
		set personnel_delete_url	"personnel-delete?[export_vars {personnel_id}]"
	}
	set publication_map_delete	"../publication/publication-map-delete?[export_vars {personnel_id}]"
	set publication_map_delete_all	"../publication/publication-map-delete-all?personnel_id=$personnel_id"
	set faculty_delete_url		"faculty-delete?[export_vars {personnel_id}]"
} else {
	set personnel_delete_url	""
	set publication_map_delete_all	""
	set publication_map_delete	""
	set faculty_delete_url		""
}

#require 'write' to edit exisiting personnel
set personnel_write_p [permission::permission_p -object_id $personnel_id -privilege "write"]
if {$personnel_write_p} {
	set step					1
	set personnel_write_url		"personnel-ae?[export_vars {personnel_id step}]"
	set physician_id			$personnel_id
	set physician_write_url		"physician-ae?[export_vars {personnel_id physician_id step}]"

	set step					3
	set title_arrange_url		"../title/arrange-0?[export_vars {personnel_id step}]"
	if {$group_admin_p || $sitewide_admin_p} {
		set title_add_url		"../title/add-edit?[export_vars {personnel_id step}]"
	} else {
		set title_add_url		"../title/request-add?[export_vars {personnel_id step}]"
	}

	set step					4
	set publication_write_url	"../publication/publication-ae?[export_vars {personnel_id step}]"

	# JCCC Specific Code
	set jccc_write_url			""
    set jccc_member_p           [inst::jccc::member_p -personnel_id $personnel_id]
	if {$jccc_member_p} {
		set group_path			"//UCLA//David Geffen School of Medicine at UCLA//Jonsson Comprehensive Cancer Center"
		set user_is_jccc_admin_over_personnel_p [db_string user_is_group_admin_over_personnel_p {} -default 0]
		if {$user_is_jccc_admin_over_personnel_p || $sitewide_admin_p} {
			set jccc_write_url	"jccc-ae?[export_vars {personnel_id}]"
		}
	}

	# SPH Specific Code
	set sph_write_url			""
    set sph_member_p           [inst::sph::member_p -personnel_id $personnel_id]
	if {$sph_member_p} {
		set group_path			"//UCLA//School of Public Health"
		set user_is_sph_admin_over_personnel_p [db_string user_is_group_admin_over_personnel_p {} -default 0]
		if {$user_is_sph_admin_over_personnel_p || $sitewide_admin_p} {
			set sph_write_url	"sph-ae?[export_vars {personnel_id}]"
		}
	}

	# If the personnel is ACCESS personnel (and the user has write privileges on the personnel), 
	# build a URL for viewing/modifying ACCESS data
	set access_write_url ""
	set access_group_id			[db_string access_group_id {select inst_group.lookup('//ACCESS') from dual} -default 0]
	set access_group_member_p	[group::member_p -user_id $personnel_id -group_id $access_group_id -cascade]
	if {$access_group_member_p} {
		set group_path			"//ACCESS"
		set user_is_access_admin_over_personnel_p [db_string user_is_group_admin_over_personnel_p {} -default 0]
		if {$user_is_access_admin_over_personnel_p || $sitewide_admin_p || ($user_id == $personnel_id)} {
			set access_write_url		"access-ae?[export_vars {personnel_id}]"
		}
	}
} else {
	set personnel_write_url		""
	set publication_write_url	""
}

set personnel_addresses			[db_map personnel_addresses]
set personnel_emails			[db_map personnel_emails]
set personnel_urls				[db_map personnel_urls]
set personnel_phones			[db_map personnel_phones]
set personnel_certifications	[db_map personnel_certifications]
set personnel_resumes			[db_map personnel_resumes]
set personnel_images			[db_map personnel_images]

set example_degree_url			"example-degree?[export_vars {personnel_id}]"
set title						"Details for $first_names $last_name"

# RESEARCH INTEREST INFO #################################################################
if {![string compare [string tolower $subsite_name] "access"]} {
	set lay_label		"Web"
	set technical_label	"Print"
} else {
	set lay_label		"Lay"
	set technical_label	"Technical"
}

set lay_research_interest_info	[inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default \
									 -subsite_id $subsite_id \
									 -personnel_id $personnel_id -research_interest_type "lay" -default_p 0]
set lay_research_interest_title	[lindex $lay_research_interest_info 0]
set lay_research_interest [lindex $lay_research_interest_info 1]
set lay_ri_length [string length $lay_research_interest]
set lay_research_interest	[string range $lay_research_interest 0 150]
if {$lay_ri_length >= 150} {
	set lay_research_interest "${lay_research_interest}...."
}
set technical_research_interest_info [inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default \
										  -subsite_id $subsite_id \
										  -personnel_id $personnel_id -research_interest_type "technical" -default_p 0]
set technical_research_interest_title [lindex $technical_research_interest_info 0]
set technical_research_interest [lindex $technical_research_interest_info 1]
set technical_ri_length [string length $technical_research_interest]
set technical_research_interest [string range $technical_research_interest 0 150]
if {$technical_ri_length > 150} {
	set technical_research_interest "${technical_research_interest}...."
}
set personnel_create_ri_url "../research-interests/subsite-select?[export_url_vars personnel_id]"
set personnel_edit_ri_url   "../research-interests/?[export_url_vars personnel_id subsite_id]"
set personnel_delete_ri_url "../research-interests/delete?[export_url_vars subsite_id personnel_id]"
# END RESEARCH INTEREST INFO #################################################################

