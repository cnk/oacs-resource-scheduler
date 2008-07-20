# -*- tab-width: 4 -*-
# /packages/institution/tcl/personnel-procs.tcl
ad_library {
	Helpers for personnel

	@author nick@ucla.edu
	@creation-date 2004/01/28
	@cvs-id $Id: personnel-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@personnel::personnel_exists_p
	@personnel::faculty_exists_p
	@personnel::physician_exists_p
	@personnel::user_exists_p
	@personnel::get_status_id
	@personnel::delete
	@personnel::physician_delete
	@personnel::faculty_delete

	@personnel::unassociate

	@personnel::personnel_add
	@personnel::personnel_edit
	@personnel::user_to_personnel
	@personnel::physician_add
	@personnel::physician_edit
	@personnel::user_add
	@personnel::personnel_to_user
	@personnel::faculty_add

	@personnel::ui::status_select_options
}

namespace eval personnel {}

# start: procs to test for existance

ad_proc -public personnel::personnel_exists_p {
	{-personnel_id:required}
} {
	This function to check if personnel with personnel_id exists in the
	inst_personnel table.  This function returns 1 if the personnel with
	personnel_id exists in the inst_personnel table otherwise 0.
} {
	return [db_string get_personnel_check {} -default 0]
}

ad_proc -public personnel::faculty_exists_p {
	{-personnel_id:required}
} {
	This function to check if personnel with personnel_id exists in the
	inst_faculty table.	 This function returns 1 if the faculty with
	personnel_id exists in the inst_faculty table otherwise 0.
} {
	return [db_string get_faculty_check {} -default 0]
}

ad_proc -public personnel::physician_exists_p {
	{-personnel_id:required}
} {
	This function to check if personnel with personnel_id exists in the
	inst_physicians table.  This function returns 1 if the physician with
	personnel_id exists in the inst_physicians table otherwise 0.
} {
	return [db_string get_physician_check {} -default 0]
}

ad_proc -public personnel::user_exists_p {
	{-personnel_id:required}
} {
	This function to check if personnel with personnel_id exists in the users
	table.  This function returns 1 if the user with personnel_id exists in the
	users table otherwise 0.
} {
	return [db_string get_user_check {} -default 0]
}
# end: procs to test for existence

ad_proc -public personnel::get_status_id {
	{-name}
} {
	(Documentation not provided)

	@param	name	The name of the status to retrieve the ID of
	@return			The Category ID that corresponds to the name
	@error			Returns 0 if the status was not found

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-17 11:45 PDT
} {
	return [db_string get_status_id {} -default 0]
}

# start: procs to delete personnel
# ad_tested
ad_proc -public personnel::delete {
	{-personnel_id:required}
} {
	This function removes the personnel completely from the system.  It removes
	any association to all groups, it deletes all language associations, it
	removes any physician and/or faculty association, and then it removes the
	personnel and user from the system.

	This function returns 1 if personnel deleted properly otherwise 0
} {
	personnel::physician_delete -personnel_id $personnel_id
	personnel::faculty_delete -personnel_id $personnel_id
	inst::jccc::personnel_delete -personnel_id $personnel_id

	inst::subsite_personnel_research_interests::personnel_research_interest_delete -personnel_id $personnel_id
	db_dml vsp_delete_mappings {
		delete	from vsp_physician_mapping
		where	physician_id	= :personnel_id
	}

	personnel::sttp_mentorship_delete -personnel_id $personnel_id
	publication::publication_personnel_map_remove_all -personnel_id $personnel_id
	db_foreach remove_any_permissions {
		select	object_id,
				privilege
		  from	acs_permissions
		 where	:personnel_id in
				(object_id, grantee_id)
	} {
		permission::revoke				\
			-object_id	$object_id		\
			-party_id	$personnel_id	\
			-privilege	$privilege
	}

	db_exec_plsql personnel_delete {
		begin
			inst_person.delete(personnel_id => :personnel_id);
		end;
	}

	return 1
}

ad_proc -public personnel::physician_delete {
	{-personnel_id:required}
} {
	This function deletes any personnel with personnel_id from the
	inst_physicians table.  This function returns 1 if physician deleted
	properly otherwise 0.
} {
	db_dml physician_delete_proc {}
	return 1
}

ad_proc -public personnel::faculty_delete {
	{-personnel_id:required}
} {
	This function deletes any personnel with personnel_id from the inst_faculty
	table.  This function returns 1 if faculty deleted properly otherwise 0.
} {
	db_dml faculty_delete_proc {}
	return 1
}

ad_proc -public personnel::sttp_mentorship_delete {
	{-personnel_id:required}
} {
	This function deletes any personnel with personnel_id from the
	inst_short_term_trnng_prog table.  This function returns 1 if sttp
	mentorship deleted properly otherwise 0.
} {
	db_foreach sttp_requests_for_personnel {} {
		db_exec_plsql sttp_delete {}
	}
	return 1
}

# end: procs to delete personnel

ad_proc -public personnel::unassociate {
	{-personnel_id:required}
	{-group_id:required}
	{-title_id ""}
} {
	This function deletes any row with the same rel_id and title_id from the
	inst_group_personnel_map, and it deletes any row in the acs_rel with the
	same rel_id if there are no more rows in the inst_group_personnel_map
	with the rel_id.  This function returns 1 if personnel deleted properly
	otherwise 0.
} {
	set rel_id [db_string get_rel_id {
		select	rel_id
		  from	acs_rels
		 where	object_id_two	= :personnel_id
		   and	object_id_one	= :group_id
	} -default 0]

	if {$rel_id != 0} {
		if {![empty_string_p $title_id]} {
			db_exec_plsql group_map_delete_with_title {}
		} else {
			db_exec_plsql group_map_delete {}
		}
	}

	return 1
}

################################################################################
# Testing
# ad_tested
ad_proc -public personnel::personnel_add {
	{-first_names:required}
	{-middle_name ""}
	{-last_name:required}
	{-preferred_first_name ""}
	{-preferred_middle_name ""}
	{-preferred_last_name ""}
	{-employee_number ""}
	{-gender ""}
	{-status_id ""}
	{-notes ""}
	{-meta_keywords ""}
	{-bio ""}
	{-photo ""}
	{-languages ""}
	{-real_date_of_birth ""}
	{-real_start_date ""}
	{-real_end_date ""}
	{-context_id ""}
} {
	This function takes all the above information and creates a new person
	object and then using that person_id, it creates a new row in the
	inst_personnel table with all the information supplied.  This function
	returns personnel_id if success, 0 on failure.
} {

	# create new person/personnel with all currently displayed information
	set personnel_error 0
	set personnel_id [db_exec_plsql personnel_create {
		begin
			:1 := inst_person.new (
				first_names		=> :first_names ,
				middle_name		=> :middle_name ,
				last_name		=> :last_name ,
				employee_number	=> :employee_number ,
				gender			=> :gender ,
				status_id		=> :status_id ,
				notes			=> :notes ,
		        meta_keywords   => :meta_keywords ,
				context_id		=> :context_id
			);
		end;
	}]

	db_dml personnel_insertion {} -clobs [list $bio]

	if {![empty_string_p $photo]} {

		set photo_tmpfilename [ns_queryget photo.tmpfile]
		set extension [string tolower [file extension $photo]]
		regsub "\." $extension "" extension
		set file_type [ns_guesstype $photo]
		set file_bytes [file size $photo_tmpfilename]

		# get the dimensions if they exist
		if {$extension == "jpeg" || $extension == "jpg" } {
			catch { set dimensions [ns_jpegsize $photo_tmpfilename] }
		} elseif {$extension == "gif"} {
			catch { set dimensions [ns_gifsize $photo_tmpfilename] }
		}

		if {[exists_and_not_null dimensions]} {
			set width [lindex $dimensions 0]
			set height [lindex $dimensions 1]
		} else {
			set width ""
			set height ""
		}

		db_dml update_photo {} -blob_files [list $photo_tmpfilename]
	}

	# entering language information
	if {![empty_string_p $languages]} {
		foreach language $languages {
			db_dml language_map {}
		}
	}
	return $personnel_id
}

# ad_tested
ad_proc -public personnel::personnel_edit {
	{-personnel_id:required}
	{-first_names:required}
	{-middle_name ""}
	{-last_name:required}
	{-preferred_first_name ""}
	{-preferred_middle_name ""}
	{-preferred_last_name ""}
	{-employee_number ""}
	{-gender ""}
	{-status_id ""}
	{-notes ""}
	{-meta_keywords ""}
	{-bio ""}
	{-photo ""}
	{-languages ""}
	{-real_date_of_birth ""}
	{-real_start_date ""}
	{-real_end_date ""}
} {
	This function updates both the persons and inst_personnel table. NOTE: This
	function overwrites EVERYTHING, so if something is passed in blank, the old
	value will be deleted from the table.  The persons table uses the
	first_names and last_name parameters, and everything else belongs to
	inst_personnel table.  This function returns personnel_id if success, 0 on
	failure.
} {
	# photo info
	if {![empty_string_p $photo]} {

		set photo_tmpfilename [ns_queryget photo.tmpfile]
		set extension [string tolower [file extension $photo]]
		regsub "\." $extension "" extension
		set file_type [ns_guesstype $photo]
		set file_bytes [file size $photo_tmpfilename]

		# get the dimensions if they exist
		if {$extension == "jpeg" || $extension == "jpg" } {
			catch { set dimensions [ns_jpegsize $photo_tmpfilename] }
		} elseif {$extension == "gif"} {
			catch { set dimensions [ns_gifsize $photo_tmpfilename] }
		}

		if {[exists_and_not_null dimensions]} {
			set width [lindex $dimensions 0]
			set height [lindex $dimensions 1]
		} else {
			set width ""
			set height ""
		}

		db_dml update_photo {} -blob_files [list $photo_tmpfilename]

	}

	db_dml persons_edit {}
	db_dml personnel_update {} -clobs [list $bio]


	### LANGUAGES
	# erasing all previous languages
	set error_p 0
	db_transaction {
		db_dml language_delete {}
		# entering language information
		foreach language $languages {
			if {![empty_string_p [string trim $language]]} {
				db_dml language_map {}
			}
		}
	} on_error {
		set error_p 1
		db_abort_transaction
	}

	### END LANGUAGES

	set user_id [ad_conn user_id]
	set peer_ip	[ad_conn peeraddr]
	db_dml person_object_modified {}
}

# ad_tested
ad_proc -public personnel::user_to_personnel {
	{-personnel_id:required}
	{-first_names:required}
	{-middle_name ""}
	{-last_name:required}
	{-preferred_first_name ""}
	{-preferred_middle_name ""}
	{-preferred_last_name ""}
	{-employee_number ""}
	{-gender ""}
	{-status_id ""}
	{-notes ""}
	{-bio ""}
	{-photo ""}
	{-languages ""}
	{-real_date_of_birth ""}
	{-real_start_date ""}
	{-real_end_date ""}
} {
	This function takes a current user_id number and turns that user into a
	personnel by creating a new row in the inst_personnel table with the same
	user_id. NOTE: The user_id cannot already be the same id as any personnel.
	This function returns personnel_id if success, 0 on failure.
} {
	# create new person/personnel with all currently displayed information

	db_dml personnel_new {}
	db_dml personnel_insertion {} -clobs [list $bio]

	if {![empty_string_p $photo]} {

		set photo_tmpfilename [ns_queryget photo.tmpfile]
		set extension [string tolower [file extension $photo]]
		regsub "\." $extension "" extension
		set file_type [ns_guesstype $photo]
		set file_bytes [file size $photo_tmpfilename]

		# get the dimensions if they exist
		if {$extension == "jpeg" || $extension == "jpg" } {
			catch { set dimensions [ns_jpegsize $photo_tmpfilename] }
		} elseif {$extension == "gif"} {
			catch { set dimensions [ns_gifsize $photo_tmpfilename] }
		}

		if {[exists_and_not_null dimensions]} {
			set width [lindex $dimensions 0]
			set height [lindex $dimensions 1]
		} else {
			set width ""
			set height ""
		}

		db_dml update_photo {} -blob_files [list $photo_tmpfilename]
	}

	# entering language information
	if {![empty_string_p $languages]} {
		foreach language $languages {
			db_dml language_map {}
		}
	}

	set email_p [db_string get_user_email {
		select	email
		  from	parties
		 where	party_id = :personnel_id
	}]
	set email_type_id [db_exec_plsql get_email_type {
		begin
			:1 := category.lookup('//Contact Information//Email//Email Address');
		end;
	}]

	set email_temp [db_exec_plsql add_personnel_email {
		begin
			:1 := inst_party_email.new (
					owner_id	=> :personnel_id,
					type_id		=> :email_type_id,
					email		=> :email_p
			);
		end;
	}]

	return $personnel_id
}

# ad_tested
ad_proc -public personnel::physician_add {
	{-personnel_id:required}
	{-years_of_practice ""}
	{-primary_care_physician_p:required}
	{-accepting_patients_p:required}
	{-marketable_p:required}
	{-typical_patient ""}
} {
	This function turns a current personnel to a physician by creating a row in
	the inst_physicians table with the information from above. NOTE:
	Personnel_id must exist in inst_personnel table.  This function returns 1 if
	success, 0 on failure.
} {
	db_dml physician_add {}
	return 1
}

# ad_tested
ad_proc -public personnel::physician_edit {
	{-personnel_id:required}
	{-years_of_practice ""}
	{-primary_care_physician_p:required}
	{-accepting_patients_p:required}
	{-marketable_p:required}
	{-typical_patient ""}
} {
	This function updates the inst_physicians table with the information above.
	NOTE: This function overwrites EVERYTHING, so if something is passed in
	blank, the old value will be deleted from the table.  This function returns
	1 if success, 0 on failure.
} {
	db_dml update_physicians {}
	return 1
}

#ad_tested
ad_proc -public personnel::user_add {
	{-priv_email:required}
	{-first_names:required}
	{-last_name:required}
	{-password:required}
} {
	This function creates a new user object in the system and should be used
	only to create a user who is already not a personnel.  This function returns
	user_id if success, 0 on failure.
} {
	set new_user_id [ad_user_new $priv_email $first_names $last_name $password "" ""]
	return $new_user_id
}

# ad_tested
ad_proc -public personnel::personnel_to_user {
	{-personnel_id:required}
	{-priv_email:required}
	{-first_names:required}
	{-middle_name ""}
	{-last_name:required}
	{-password:required}
} {
	This function turns a current personnel with a valid personnel_id from the
	inst_personnel table into a user. This function should be used only to
	create a user who is already a personnel.  This function returns user_id if
	success, 0 on failure.
} {
	set true "t"
	set false "f"

	set salt [sec_random_token]
	set hashed_password [ns_sha1 "$password$salt"]

	db_exec_plsql personnel_user {
		begin
			inst_person.personnel_to_user (
				personnel_id	=> :personnel_id,
				p_email			=> :priv_email,
				first_names		=> :first_names,
				middle_name		=> :middle_name,
				last_name		=> :last_name,
				password		=> :hashed_password,
				salt			=> :salt
			);
		end;
	}

	return $personnel_id
}

#not ad_tested
ad_proc -public personnel::faculty_add {
	{-faculty_id:required}
} {
	This function creates a new row in the inst_faculty table with the
	faculty_id. NOTE: faculty_id must be a valid personnel_id from
	inst_personnel table.  This function returns 1 if success, 0 on failure.
} {
	db_dml faculty_new {}
	return 1
}

namespace eval personnel::ui {}
ad_proc -public personnel::ui::status_select_options {
} {
	Returns a list-of-lists suitable for allowing someone to select a category for use in 'personnel.status_id'.

	@return			DESCRIPTION

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-05-17 15:19 PDT
} {
	set user_id	[ad_conn user_id]
	set options	[db_list_of_lists status_select_options {}]
	set options	[tree::sorter::sort_list_of_lists -list $options]
	return $options
}

