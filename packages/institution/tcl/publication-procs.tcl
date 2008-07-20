# /packages/institution/tcl/publication-procs.tcl		-*- tab-width: 4 -*-

ad_library {

	Helpers for publications

	@author nick@ucla.edu
	@author avni@ctrl.ucla.edu (AK)
	@creation-date 2004/02/01
	@cvs-id $Id: publication-procs.tcl,v 1.2 2007/01/26 02:02:30 andy Exp $

	@publication::publication_exist
	@publication::publication_add
	@publication::publication_edit
	@publication::publication_personnel_map
	@publication::publication_delete
	@publication::xml_upload
	@publication::txt_upload
}

namespace eval publication {}

ad_proc -public publication::publication_exist {
	{-publication_id:required}
} {
	This function to check if publication with publication_id exists in the inst_publications table.
	This function returns greater than 0 if the publication with publication_id exists, otherwise 0.
} {
	return [db_string get_publication_check {select count(*) from inst_publications where publication_id = :publication_id}]
}

ad_proc -public publication::publication_add {
	{-title:required}
	{-publication_name ""}
	{-url ""}
	{-authors ""}
	{-volume ""}
	{-issue ""}
	{-page_ranges ""}
	{-year ""}
	{-publisher ""}
	{-publish_date ""}
	{-publication ""}
	{-priority_number ""}
	{-personnel_id ""}
	{-context_id ""}
} {
	This function takes all the above information and creates a new row in the
	inst_publications table with all the information supplied. Then creates a
	new row in the inst_personnel_publication_map table to associate the new
	publication with the personnel_id.

		This function returns the publication_id on success otherwise 0.
} {
	# create new object/publication with all currently displayed information
	set publication_error 0

	db_transaction {
		set publication_id [db_exec_plsql publication_create {
			begin
				:1 := inst_publication.new(
					title				=> :title,
					publication_name	=> :publication_name,
					url					=> :url,
					authors				=> :authors,
					volume				=> :volume,
					issue				=> :issue,
					page_ranges			=> :page_ranges,
					year				=> :year,
					publisher			=> :publisher,
					priority_number		=> :priority_number,
					context_id			=> :context_id
				);
			end;
		}]

		db_dml publication_insertion {}

		if {![empty_string_p $publication]} {
			set publication_tmpfilename [ns_queryget publication.tmpfile]
			set extension [string tolower [file extension $publication]]
			regsub "\." $extension "" extension
			set file_type [ns_guesstype $publication]
			set file_bytes [file size $publication_tmpfilename]

			db_dml update_publication {} -blob_files [list $publication_tmpfilename]
		}

		if {![empty_string_p $personnel_id]} {
			db_dml ippm_create {}
		}
	} on_error {
		set publication_error 1
		db_abort_transaction
	}

	if {$publication_error} {
		ad_return_error "Error" "PUBLICATION NOT ADDED PROPERLY - $errmsg"
		return
	}

	return $publication_id
}


ad_proc -public publication::publication_edit {
	{-publication_id:required}
	{-title:required}
	{-publication_name ""}
	{-url ""}
	{-authors ""}
	{-volume ""}
	{-issue ""}
	{-page_ranges ""}
	{-year ""}
	{-publisher ""}
	{-publish_date ""}
	{-publication ""}
	{-priority_number ""}
} {
	This function takes all the above information and updates the row in the
	inst_publications table with all the information supplied. NOTE: This
	function overwrites EVERYTHING, so if something is passed in blank, the old
	value will be deleted from the table.

	This function returns 1 on success otherwise 0.
} {
	set publication_error 0
	db_transaction {
		db_dml publication_update {}

		if {![empty_string_p $publication]} {
			set publication_tmpfilename [ns_queryget publication.tmpfile]
			set extension	[string tolower [file extension $publication]]
			regsub "\." $extension "" extension
			set file_type	[ns_guesstype $publication]
			set file_bytes	[file size $publication_tmpfilename]

			db_dml update_publication {} -blob_files [list $publication_tmpfilename]
		}
	} on_error {
		set publication_error 1
		db_abort_transaction
	}
	if {$publication_error} {
		ad_return_complaint 1 "Publication Information NOT UPDATED PROPERLY - $errmsg"
		return
	}
	return 1
}

ad_proc -public publication::publication_personnel_map {
	{-publication:required}
	{-personnel_id:required}
} {
	This function creates a new row in the inst_personnel_publication_map table to assocaite the personnel to the
	the publication.
	This function return 1 on success, otherwise 0.
} {

	set map_error 0
	db_transaction {
		db_dml ippm_create {}
	} on_error {
		set map_error 1
		db_abort_transaction
	}
	if {$map_error} {
		ad_return_error "Error" "Publication Not Mapped Properly - $errmsg"
		return
	}
}

ad_proc -public publication::publication_personnel_map_remove {
	{-personnel_id:required}
	{-publication_id:required}
} {
	This function unmaps one publication from a personnel
} {
	set success_p 1
	db_transaction {
		db_dml delete_publication_personnel_subsets {
			delete from inst_psnl_publ_ordered_subsets
			where  publication_id = :publication_id 
			and	   personnel_id = :personnel_id
		}

		db_dml delete_publication_maps {
			delete from inst_personnel_publication_map
			where publication_id = :publication_id 
			and personnel_id = :personnel_id
		}

		inst::access::update_publication_to_null_for_personnel -personnel_id $personnel_id -publication_id $publication_id

		set publication_map_exists_p [db_string publication_personnel_map_exists_p {
			select count(*)
			from   inst_personnel_publication_map
			where  publication_id = :publication_id
		}]

		if {!$publication_map_exists_p} {
			publication::publication_delete -publication_id $publication_id
		}
	
	} on_error {
		set success_p 0
		db_abort_transaction
	}
	
	return $success_p
}
	

ad_proc -public publication::publication_personnel_map_remove_all {
	{-personnel_id:required}
} {
	This function unmaps all publications for this person.
	It also deletes the publication if no one else is mapped to it.
	Only site wide administrators are allowed to do this.
} {
	db_foreach personnel_publication_select {
		select publication_id
		from   inst_personnel_publication_map
		where  personnel_id = :personnel_id
	} {
		publication::publication_personnel_map_remove -personnel_id $personnel_id -publication_id $publication_id
	}
	return
}

ad_proc -public publication::publication_delete {
	{-publication_id:required}
} {
	This function deletes all rows from the inst_personnel_publication_map and inst_publications
	tables wit the publication_id.
	This function return 1 on success, otherwise 0.
} {

	set publication_error 0
	db_transaction {

		inst::access::update_publication_to_null -publication_id $publication_id
		db_dml publication_map_delete {}
		publication::pubmed::delete -publication_id $publication_id
		db_exec_plsql publication_delete {
			begin
			inst_publication.delete (publication_id => :publication_id);
			end;
		}
	} on_error {
		set publication_error 1
		db_abort_transaction
	}
	if {$publication_error} {
		ad_return_complaint 1 "Publication not deleted properly- $errmsg:"
		return
	}
	return 1
}


ad_proc -public publication::xml_upload {
	{-personnel:required}
	{-xml_doc:required}
} {
	This function reads the properly formatted xml exported from EndNote 7 or 8, 
	parses the STRING, creates rows in the
	inst_publications table for each Record, and associates
	all the personnel in the personnel list with each newly
	created row.

	This function return a list of number of records with no titles,
	list of titles successfully updated, list of titles not successfully
	updated.
} {
	if {[exists_and_not_null personnel] && [llength $personnel] > 0} {
		set context_id [lindex $personnel 0]
	} else {
		set context_id [ad_conn user_id]
	}
	
	# Change all style tags to be span
	#### First change <style....> to <span....>
	regsub -all {<style} $xml_doc {<span} xml_doc
	#### Now change </style> to </span>
	regsub -all {</style>} $xml_doc {</span>} xml_doc


	set element_list ""
	# Need to preprocess the xml document to regsub out the HTML tags
	set tags_with_close [list "REFERENCE_TYPE" "REFNUM" "ACCESSION_NUMBER" "DATE" \
			"ABSTRACT" "AUTHOR_ADDRESSS" "AUTHOR" "NOTES" "SECONDARY_TITLE" "KEYWORD" \
			"VOLUME" "NUMBER" "PAGES" "PUBLISHER" "TITLE" "YEAR" "AUTH-ADDRESS" "SECONDARY-TITLE" "ACCESSION-NUM" "URL" ]
	set return_content $xml_doc
	set previous_content $xml_doc
	set page_content $return_content

	foreach tag_type $tags_with_close {

		set page_content $return_content
		set previous_content $return_content

		set indices_list [regexp -indices -nocase -all -inline "<${tag_type}>.*?</${tag_type}>" $page_content]

		set offset 0
		foreach pair $indices_list {

			set start [lindex $pair 0]
			set end [lindex $pair 1]
			set tag [string trim [string range $page_content $start $end]]

			#parse out a string
			set param_string ""
			regexp -nocase "<${tag_type}\s*?.*?>(.*)</${tag_type}>" $tag match param_string
			set param_string [string trim $param_string]

			regsub -all {<} $param_string {\&lt;} param_string
			regsub -all {>} $param_string {\&gt;} param_string
			set param_string "<${tag_type}>${param_string}</${tag_type}>"

			set return_content [string replace $return_content [expr $start+$offset] [expr $end+$offset] $param_string]

			#update the offset now that the string has been replaced
			set offset [expr $offset+[expr [string length $return_content]-[string length $previous_content]]]
			set previous_content $return_content
		}
	}
	### End preprocessing the xml document to regsub the HTML tag brackets with &lt; and &gt;

	set document [dom parse -simple $return_content]
	set records_root [ctrl_procs::tdom_get_node_pointer $document "RECORDS" "records"]

	if {[empty_string_p $records_root]} {
		ad_return_error "Error" "ERROR: Invalid XML."
		return
	}

	set records_list [ctrl_procs::tdom_get_node_pointer $records_root "RECORD" "record"]

	if {[empty_string_p $records_list]} {
		ad_return_error "Error" "ERROR: You must upload atleast one publication."
		return
	}

	set success_list ""
	set failure_list ""
	set no_title_counter 0
	foreach record $records_list {

		# getting volume info
		set volume [ctrl_procs::tdom_get_tag_value $record "VOLUME" "volume"]

		# getting issue info
		set issue [ctrl_procs::tdom_get_tag_value $record "NUMBER" "number"]

		# getting page_ranges
		set page_ranges [ctrl_procs::tdom_get_tag_value $record "PAGES" "pages"]

		# getting publisher
		set publisher [ctrl_procs::tdom_get_tag_value $record "PUBLISHER" "publisher"]

		# getting title
		set title [ctrl_procs::tdom_get_tag_value $record "TITLE" "title"]

		# getting year
		set year [ctrl_procs::tdom_get_tag_value $record YEAR year]
		### Need to remove span tags if there are any
		regexp -nocase "<span.*?>(.*)</span>" $year match year

		# checking that year is an integer
		set result [regexp {^[ +-]?\d+$} $year]
		if {!$result} {
			set year ""
		}

		# getting publication_name
		set publication_name [ctrl_procs::tdom_get_tag_value $record SECONDARY_TITLE secondary_title SECONDARY-TITLE secondary-title]

		# getting date
		set publication_date [string trim [ctrl_procs::tdom_get_tag_value $record DATE date]]
		### Need to remove span tags if there are any
		regexp -nocase "<span.*?>(.*)</span>" $publication_date match publication_date

		# Date Format must be either YYYY/MM/DD or YYYY-MM-DD
		### If this is version 8 check if format is MM DD and switch to YYYY/Mon/DD
		set split_publication_date [split $publication_date " "]

		if {[llength $split_publication_date] == 2} {
			set month [lindex $split_publication_date 0]
			set day [lindex $split_publication_date 1]
			set publication_date "$year/$month/$day"
			set date_format "yyyy/mon/dd"
		} else {
			set date_format ""
			set result [regexp {[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]} $publication_date]
			if {$result} {
				set date_format "yyyy/mm/dd"
			}
		
			set result [regexp {[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]} $publication_date]
			if {$result} {
				set date_format "yyyy-mm-dd"
			}
		}

		# getting url
		set url [ctrl_procs::tdom_get_tag_value $record URL url]
		### Need to remove span tags if there are any
		regexp -nocase "<span.*?>(.*)</span>" $url match url
		set url [string trim $url]

		# getting authors
		set authors ""
		set authors_root [ctrl_procs::tdom_get_node_pointer $record "AUTHORS" "authors"]
		if {![empty_string_p $authors_root]} {
			set authors_list [ctrl_procs::tdom_get_node_pointer $authors_root "AUTHOR" "author"]
			foreach author $authors_list {
				append authors "[[$author firstChild] nodeValue] "
			}
		}

		if {![empty_string_p $title]} {

			db_transaction {
				set publication_id [db_exec_plsql publication_create {
					begin
					:1 := inst_publication.new(
					title				=> :title,
					publication_name	=> :publication_name,
					url					=> :url,
					authors				=> :authors,
					volume				=> :volume,
					issue				=> :issue,
					page_ranges			=> :page_ranges,
					year				=> :year,
					publisher			=> :publisher,
					context_id			=> :context_id
					);
					end;
				}]

				if {![empty_string_p $publication_date] && ![empty_string_p $date_format]} {
					db_dml date_insert {
						update	inst_publications
						set		publish_date	= to_date(:publication_date, :date_format)
						where	publication_id	= :publication_id
					}
				}

				foreach person $personnel {
					db_dml per_pub_map {
						insert into inst_personnel_publication_map(personnel_id, publication_id, mapping_date) values (:person, :publication_id, sysdate)
					}
				}
			} on_error {
				set error_p 1
				db_abort_transaction
			}

			if {[exists_and_not_null error_p]} {
				# add to error list
				if {[string length $failure_list] == 0} {
					append failure_list "$title"
				} else {
					append failure_list ", $title"
				}
			} else {
				if {[string length $success_list] == 0} {
					append success_list "$title"
				} else {
					append success_list ", $title"
				}
			}
		} else {
			incr no_title_counter
		}
		# END of RECORD loop
	}

	$document delete
	return [list $no_title_counter $success_list $failure_list]
}


ad_proc -public publication::txt_upload {
	{-personnel:required}
	{-txt_file_id:required}
} {
	This function reads the properly formatted .txt exported from EndNote 6 in EndNote export formatting,
	parses the file, creates rows in the inst_publications table for each Record, and associates all the
	personnel in the personnel list with each newly created row.
	This function return a list of number of records with no titles, list of titles successfully updated, list of titles not successfully
	updated.
} {
		# initializing vars for each record pass
		set volume ""
		set issue ""
		set page_ranges ""
		set publisher ""
		set title ""
		set year ""
		set publication_name ""
		set publication_date ""
		set url ""
		set authors ""
		if {[exists_and_not_null personnel] && [llength $personnel] > 0} {
			set context_id [lindex $personnel 0]
		} else {
			set context_id [ad_conn user_id]
		}

		set current_delimitor ""
		#set line [gets $txt_file_id line]
		#		set output_text ""

		set success_list ""
		set failure_list ""
		# starts at negative one since first line read should be a %0
		set no_title_counter -1
		while {[gets $txt_file_id line] != -1} {

			set line_length [expr [string length $line] - 1]
			set delimitor [string range $line 0 2]

			if {[string compare $delimitor "%0 "] == 0} {
				# DO INSERTION HERE AND RESET VARIABLES
				set error_p 0
				if {![empty_string_p $title]} {
					# checking that year is an integer since procv THAT YEAR IS NUMBER ONLY
					set result [regexp {^[ +-]?\d+$} $year]
					if {!$result} {
						set year ""
					}

					# Date format must be either YYYY/MM/DD or YYYY-MM-DD
					# need to trim the date
					set publication_date [string trim $publication_date]
					set date_format ""
					set result [regexp {[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]} $publication_date]
					if {$result} {
						set date_format 1
					}

					set result [regexp {[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]} $publication_date]
					if {$result} {
						set date_format 2
					}

					# does not insert Date yet since need to do formating check first.
					db_transaction {
						set publication_id [db_exec_plsql publication_create {
							begin
							:1 := inst_publication.new(
							title				=> :title,
							publication_name	=> :publication_name,
							url					=> :url,
							authors				=> :authors,
							volume				=> :volume,
							issue				=> :issue,
							page_ranges			=> :page_ranges,
							year				=> :year,
							publisher			=> :publisher,
							context_id			=> :context_id
							);
							end;
						}]

						foreach person $personnel {
							db_dml per_pub_map {
								insert into inst_personnel_publication_map(
								personnel_id,
								publication_id,
								mapping_date
								) values (
								:person,
								:publication_id,
								sysdate
								)
							}
						}

						if {$date_format == 1} {
							db_dml date_insert_1 {
								update	inst_publications
								set		publish_date	= to_date(:publication_date, 'YYYY/MM/DD')
								where	publication_id	= :publication_id
							}
						} elseif {$date_format == 2} {
							db_dml date_insert_2 {
								update	inst_publications
								set		publish_date	= to_date(:publication_date, 'YYYY-MM-DD')
								where	publication_id	= :publication_id
							}
						}

					} on_error {
						set error_p 1
						db_abort_transaction
					}
					if $error_p {
						if {[string length $failure_list] == 0} {
							append failure_list "$title"
						} else {
							append failure_list ", $title"
						}
					} else {
						if {[string length $success_list] == 0} {
							append success_list "$title"
						} else {
							append success_list ", $title"
						}
					}

					set volume ""
					set issue ""
					set page_ranges ""
					set publisher ""
					set title ""
					set year ""
					set publication_name ""
					set publication_date ""
					set url ""
					set authors ""
				} else {
					incr no_title_counter
				}
			} elseif {[string range $delimitor 0 0] == "%"} {
				switch $delimitor {
					"%A " {
						#checking for author
						set authors [string range $line 3 $line_length]
						set current_delimitor "%A "
					}
					"%D " {
						#checking for year
						set year [string range $line 3 $line_length]
						set current_delimitor "%D "
					}
					"%T " {
						#checking for title
						set title [string range $line 3 $line_length]
						set current_delimitor "%T "
					}
					"%B " {
						#checking for publication_name
						set publication_name [string range $line 3 $line_length]
						set current_delimitor "%B "
					}
					"%I " {
						#checking for publisher
						set publisher [string range $line 3 $line_length]
						set current_delimitor "%I "
					}
					"%V " {
						#checking for volume
						set volume [string range $line 3 $line_length]
						set current_delimitor "%V "
					}
					"%P " {
						#checking for page_ranges
						set page_ranges [string range $line 3 $line_length]
						set current_delimitor "%P "
					}
					"%8 " {
						#checking for publish_date
						set publication_date [string range $line 3 $line_length]
						set current_delimitor "%8 "
					}
					"%U " {
						#checking for url
						set url [string range $line 3 $line_length]
						set current_delimitor "%U "
					}
					"%N " {
						#checking for issue
						set issue [string range $line 3 $line_length]
						set current_delimitor "%N "
					}
				}
			} elseif {$line_length > 0} {
				switch $current_delimitor {
					"%A " {append authors [string range $line 0 $line_length] }
					"%D " {append year [string range $line 0 $line_length] }
					"%T " {append title [string range $line 0 $line_length] }
					"%B " {append publication_name [string range $line 0 $line_length] }
					"%I " {append publisher [string range $line 0 $line_length] }
					"%V " {append volume [string range $line 0 $line_length] }
					"%P " {append page_ranges [string range $line 0 $line_length] }
					"%8 " {append publication_date [string range $line 0 $line_length] }
					"%U " {append url [string range $line 0 $line_length] }
					"%N " {append issue [string range $line 0 $line_length] }
				}
			} else {
				ad_return_error "Error" "The text file is in an invalid format. Please make sure you have exported the file with
				the \"EndNote Export\" Output Style. Please go back and try again. Thank you."
				return
			}

		}

		# DO INSERTION HERE FOR LAST ONE
		set error_p 0
		if {![empty_string_p $title]} {
				# checking that year is an integer since procv THAT YEAR IS NUMBER ONLY
				set result [regexp {^[ +-]?\d+$} $year]
				if {!$result} {
						set year ""
				}

				# does not insert Date yet since need to do formating check first.
				# Date format must be either YYYY/MM/DD or YYYY-MM-DD
				# need to trim the date
				set publication_date [string trim $publication_date]
				set date_format ""
				set result [regexp {[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]} $publication_date]
				if {$result} {
						set date_format 1
				}

				set result [regexp {[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]} $publication_date]
				if {$result} {
						set date_format 2
				}

				db_transaction {
								set publication_id [db_exec_plsql publication_create {
										begin
												:1 := inst_publication.new(
														title							=> :title,
														publication_name		=> :publication_name,
														url										=> :url,
														authors							=> :authors,
														volume							=> :volume,
														issue							=> :issue,
														page_ranges						=> :page_ranges,
														year							=> :year,
														publisher						=> :publisher,
														context_id						=> :context_id
												);
										end;
								}]

						foreach person $personnel {
								db_dml per_pub_map {
										insert into inst_personnel_publication_map(personnel_id, publication_id, mapping_date) values (:person, :publication_id, sysdate)
								}
						}

						if {$date_format == 1} {
								db_dml date_insert_1 {
										update inst_publications
										set publish_date = to_date(:publication_date, 'YYYY/MM/DD')
										where publication_id = :publication_id
								}
						} elseif {$date_format == 2} {
								db_dml date_insert_2 {
										update inst_publications
										set publish_date = to_date(:publication_date, 'YYYY-MM-DD')
										where publication_id = :publication_id
								}
						}
				} on_error {
						set error_p 1
						db_abort_transaction
				}

				if $error_p {
						if {[string length $failure_list] == 0} {
								append failure_list "$title"
						} else {
								append failure_list ", $title"
						}
				}

				if {[string length $success_list] == 0} {
						append success_list "$title"
				} else {
						append success_list ", $title"
				}
		} else {
				incr no_title_counter
		}

		close $txt_file_id
		return [list $no_title_counter $success_list $failure_list]
}


ad_proc -private publication::audit {
	{-publication_id:required}
} {
	Copies over the current data in inst_publications for the publication passed in
	into the  inst_publications_audit table
} {
	set success_p 1
	db_transaction {
		db_dml publication_audit {}
	} on_error {
		set success_p 0
		db_abort_transaction
	}
	return $success_p
}
