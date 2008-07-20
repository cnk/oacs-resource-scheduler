# -*- tab-width: 4 -*-

ad_page_contract {
	
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2003/??/??
	@cvsid			$Id: index.tcl,v 1.2 2007/01/06 03:10:08 avni Exp $

	@modification-date 2005/8/25
	@modified-by    avni@ctrl.ucla.edu (AK)
	Heavily modified to improve speed. Also cleaned up a lot of code.
	
} {
	{combine_method:integer			 0}
	{return_url						 [get_referrer]}
	{search_language_spoken:optional ""}
	{search_first_name:optional		 ""}
	{search_last_name:optional		 ""}
	{search_keyword:optional         ""}
	{fn_cond:integer,optional		 2}
	{ln_cond:integer,optional		 2}
	{display:optional				 "search_last_name"}
}

#//TODO// use [db_map partialquery_name] to get pieces of queries
set title "Search for Personnel"
set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]
set subsite_url [site_node_closest_ancestor_package_url]

set no_preference "(No Preference)"

# The 'set' for holding the search criteria:
array set criteria [list]

# The 'set' for holding a list of data-sources:
array set from [list \
		persons 1 \
		inst_personnel 1]

# The 'set' for holding the table-joining criteria:
#	Join Criteria are held separate so that, when the user selects
# the 'Any' method (so that the search query is built using an 'OR'
# to make the list of criteria that get put in the WHERE clause)
# we can still make sure that the part of the WHERE clause that
# are criteria for joining tables uses an 'AND' in between.  Without
# this distinction, we would get back many meaningless rows due to
# extensive cartesian-products.
array set join_criteria [list inst_personnel.personnel_id\ =\ persons.person_id 1]

# If we are searching through a subsite, add in the criteria for properly
# selecting only those personnel who are part of the subsite.
set subsite_criteria [subsite::parties_sql -persons -party_id {inst_personnel.personnel_id}]
set join_criteria($subsite_criteria) 1

# Determine which kind of junction should be placed between search criteria.
if {$combine_method == 0} {
	# Conjunction:
	set junction [db_map junction__all]
} else {
	# Disjunction:
	set junction [db_map junction__any]
}

################################################################################
# SET UP SELECT OPTIONS
################################################################################
# for Language
set language_options			[linsert [db_list_of_lists possible_languages {}] 0 [list $no_preference]]

# for Department/Division/...
set groups						[linsert [db_list_of_lists subsite_groups {}] 0 [list $no_preference]]

# a list of URLs for searching on the letter that begins the last-name
set ltr_index [list]
foreach ltr {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z} {
	if {![string compare $ltr $search_last_name]} {
		lappend ltr_index "<b>$ltr</b>"
	} else {
		lappend ltr_index "<a href=\"\?search_last_name=$ltr&ln_cond=1\">$ltr</a>"
	}		
}
set letter_index [join $ltr_index "&nbsp;"]

set force_reload [ns_rand]

################################################################################
# Create the search form
################################################################################
ad_form -name search -action "?[export_vars {force_reload}]" -form {
	{combine_method:integer(select),optional	  {label ""}                {value 0} {options {{"All" 0} {"Any" 1}}}}
	{search_language_spoken:text(select),optional {label "Language Spoken"}	{value $search_language_spoken}	{options $language_options}}
	{fn_cond:integer(select)					  {label ""}                {value $fn_cond}		{options {{"is" 0} {"contains" 2} {"begins with" 1} {"ends with" 3}}}}
	{search_first_name:text,optional			  {label "First Name"}}
	{ln_cond:integer(select)		              {label ""}  			    {value $ln_cond} {options {{"is" 0} {"contains" 2} {"begins with" 1} {"ends with" 3}}}}
	{search_last_name:text,optional				  {label "Last Name"}}
	{search_keyword:text,optional                 {label "Keyword"}         {value $search_keyword} {html {size 50}}}
	{group_id:integer(select),optional			  {label "Department/Division/..."} {options $groups}}
	{search:text(submit)						  {label "Search"}			}
	{display:text(select)						  {label "View Results By"}	{value $display} {options {{"First Name then Last Name" "search_first_names"} {"Last Name  then  First Name" "search_last_name"}}}}
} -on_request {

	if {![exists_and_not_null search_language_spoken] && ![exists_and_not_null search_first_name] && \
			![exists_and_not_null search_last_name] && ![exists_and_not_null search_keyword] && \
			![exists_and_not_null group_id]} {
		# Do no search if no search fields are filled out

		set search_p 0
		
	} else {	
		set search_p 1

		###########################################################################
		# Pre-process/Clean Search Criteria:
		###########################################################################
		# Language Spoken
		if {[exists_and_not_null search_language_spoken]} {
			set from(inst_personnel_language_map)												1
			set criteria(inst_personnel_language_map.language_id\ =\ :search_language_spoken)	1
			set join_criteria(inst_personnel_language_map.personnel_id\ =\ persons.person_id)	1
		} elseif {[info exists search_language_spoken]} {
			unset search_language_spoken
		}
		
		# First Name - notice the case-insensitive comparision
		if {[exists_and_not_null search_first_name]} {
			set from(persons)	1
			if {![info exists fn_cond] || ($fn_cond == 0)} {
				set criteria(lower(first_names)\ =\ lower(:search_first_name))		1
			} else {
				set criteria(lower(first_names)\ like\ lower(:search_first_name))	1
				switch $fn_cond {
					1 { set search_first_name "$search_first_name%" }
					2 { set search_first_name "%$search_first_name%" }
					3 { set search_first_name "%$search_first_name" }
				}
			}
		} elseif {[info exists search_first_name]} {
			unset search_first_name
		}
		
		# Last Name - notice the case-insensitive comparision
		if {[exists_and_not_null search_last_name]} {
			set from(persons)	1
			if {![info exists ln_cond] || ($ln_cond == 0)} {
				set criteria(lower(last_name)\ =\ lower(:search_last_name))	1
			} else {
				switch $ln_cond {
					1 {	set search_last_name_modified "$search_last_name%"}
					2 { set search_last_name_modified "%$search_last_name%" }
					3 { set search_last_name_modified "%$search_last_name" }
				}
				set criteria(lower(last_name)\ like\ lower(:search_last_name_modified)) 1 
			}
		} elseif {[info exists search_last_name]} {
			unset search_last_name
		}
		
		# Keyword 
		if {[exists_and_not_null search_keyword]} {
			# Search inst_personnel.meta_keywords

		    # Search research_interest table
			set from(inst_subsite_pers_res_intrsts) 1
			set criteria_key {
				(lower(lay_title)								like lower('%' || :search_keyword || '%')
				 or lower(dbms_lob.substr(lay_interest,3950,1))	like lower('%' || :search_keyword || '%')
				 or lower(technical_title)						like lower('%' || :search_keyword || '%')
				 or lower((dbms_lob.substr(technical_interest,3950,1))) like lower('%' || :search_keyword || '%')
				 or lower(inst_personnel.meta_keywords)		    like lower('%' || :search_keyword || '%'))
			}
			set criteria($criteria_key) 1
			set join_criteria(inst_personnel.personnel_id\ =\ inst_subsite_pers_res_intrsts.personnel_id(+))	1
		} elseif {[info exists search_keyword]} {
			unset search_keyword
		}
		
		# Department
		if {[exists_and_not_null group_id]} {
			set from(group_approved_member_map)								1
			set criteria(group_id\ =\ :group_id)							1
			set join_criteria(group_approved_member_map.member_id\ =\ inst_personnel.personnel_id)	1
		} elseif {[info exists group_id]} {
			unset group_id
		}

		# If the person is not looking for anyone by name, only show personnel who are
		# active.
		if {(![exists_and_not_null search_first_name] && ![exists_and_not_null search_last_name] && ![exists_and_not_null search_keyword])} {
			# Put this in the 'Join Criteria' so that they are always included
			# in a conjunction ('AND' expression), and thus never subject to an
			# 'OR'
			set active [personnel::get_status_id -name "Active"]
			set join_criteria(inst_personnel.status_id\ =\ :active) 1
		}
		
		###########################################################################
		# Construct data sources:
		###########################################################################
		# Make a list of tables to be put in the FROM clause
		set from_list [join [array names from] ",\n\t\t"]
		
		###########################################################################
		# Construct conditions for the WHERE clause:
		###########################################################################
		# Get Join Criteria:
		set criteria_list ""
		if {[array size join_criteria] > 0} {
			append criteria_list "(" [join [array names join_criteria] "\n\t\t and "] ")"
		}
		
		if {([array size criteria] > 0) && ([array size join_criteria] > 0)} {
			append criteria_list "\n\t\t and "
		}
		
		# Get Search Criteria:
		if {[array size criteria] > 0} {
			append criteria_list "(" [join [array names criteria] "\n\t\t\t $junction"] ")"
		}
		
		# WHERE clause will not be empty, make sure to put 'where' before it:
		if {[exists_and_not_null criteria_list]} {
			set criteria_list "where $criteria_list"
		} else {
			set criteria_list "where 0=1"
		}
		
		# The basic piece of SQL for filtering and ordering results
		set filter_and_sort_sql "
		from	$from_list
		$criteria_list
		order  by last_name, first_names
		"
		
		# The query used to retrieve the attributes of the selected rows
		set select_attributes_sql "
		select	distinct inst_personnel.personnel_id,
				first_names,
				last_name,
				degree_titles
			$filter_and_sort_sql
		"

		db_multirow -extend {
			detail_url
			edit_url
			delete_url
			permit_url
			action_url_exists_p
		} found search_personnel_query $select_attributes_sql {
			# //TODO// check permissions before setting each of these
			set detail_url	"detail?[export_vars {personnel_id}]"
			set edit_url	"personnel-ae?[export_vars {personnel_id}]"
			set delete_url	"personnel-delete?[export_vars {personnel_id}]"
			set permit_url	"${subsite_url}permissions/one?[export_vars -override {{object_id $personnel_id}}]"
		}
		set n_results ${found:rowcount}
	}
} -after_submit {
	if {![exists_and_not_null search_language_spoken] && ![exists_and_not_null search_first_name] && \
			![exists_and_not_null search_last_name] && ![exists_and_not_null search_keyword] && \
			![exists_and_not_null group_id]} {
		# Do no search if no search fields are filled out
		set search_p 0
	} else {
		set search_p 1
		###########################################################################
		# Pre-process/Clean Search Criteria:
		###########################################################################
		# Language Spoken
		if {[exists_and_not_null search_language_spoken]} {
			set from(inst_personnel_language_map)												1
			set criteria(inst_personnel_language_map.language_id\ =\ :search_language_spoken)	1
			set join_criteria(inst_personnel_language_map.personnel_id\ =\ persons.person_id)	1
		} elseif {[info exists search_language_spoken]} {
			unset search_language_spoken
		}
		
		# First Name - notice the case-insensitive comparision
		if {[exists_and_not_null search_first_name]} {
			set from(persons)	1
			if {![info exists fn_cond] || ($fn_cond == 0)} {
				set criteria(lower(first_names)\ =\ lower(:search_first_name))		1
			} else {
				set criteria(lower(first_names)\ like\ lower(:search_first_name))	1
				switch $fn_cond {
					1 { set search_first_name "$search_first_name%" }
					2 { set search_first_name "%$search_first_name%" }
					3 { set search_first_name "%$search_first_name" }
				}
			}
		} elseif {[info exists search_first_name]} {
			unset search_first_name
		}
		
		# Last Name - notice the case-insensitive comparision
		if {[exists_and_not_null search_last_name]} {
			set from(persons)	1
			if {![info exists ln_cond] || ($ln_cond == 0)} {
				set criteria(lower(last_name)\ =\ lower(:search_last_name))	1
			} else {
				set criteria(lower(last_name)\ like\ lower(:search_last_name)) 1
				switch $ln_cond {
					1 { set search_last_name "$search_last_name%" }
					2 { set search_last_name "%$search_last_name%" }
					3 { set search_last_name "%$search_last_name" }
				}
			}
		} elseif {[info exists search_last_name]} {
			unset search_last_name
		}
		
		# Keyword
		if {[exists_and_not_null search_keyword]} {
			set from(inst_subsite_pers_res_intrsts) 1
			set criteria_key {
				(lower(lay_title)								like lower('%' || :search_keyword || '%')
				 or lower(dbms_lob.substr(lay_interest,3950,1))	like lower('%' || :search_keyword || '%')
				 or lower(technical_title)						like lower('%' || :search_keyword || '%')
				 or lower((dbms_lob.substr(technical_interest,3950,1))) like lower('%' || :search_keyword || '%')
				 or lower(inst_personnel.meta_keywords)		    like lower('%' || :search_keyword || '%'))
			}
			set criteria($criteria_key) 1
			set join_criteria(inst_personnel.personnel_id\ =\ inst_subsite_pers_res_intrsts.personnel_id(+))	1
		} elseif {[info exists search_keyword]} {
			unset search_keyword
		}
		
		# Department
		if {[exists_and_not_null group_id]} {
			set from(group_approved_member_map)								1
			set criteria(group_id\ =\ :group_id)							1
			set join_criteria(group_approved_member_map.member_id\ =\ inst_personnel.personnel_id)	1
		} elseif {[info exists group_id]} {
			unset group_id
		}
		
		# If the person is not looking for anyone by name, only show personnel who are
		# active.
		if {(![exists_and_not_null search_first_name] && ![exists_and_not_null search_last_name] && ![exists_and_not_null search_keyword])} {
			# Put this in the 'Join Criteria' so that they are always included
			# in a conjunction ('AND' expression), and thus never subject to an
			# 'OR'
			set active [personnel::get_status_id -name "Active"]
			set join_criteria(inst_personnel.status_id\ =\ :active) 1
		}
		
		###########################################################################
		# Construct data sources:
		###########################################################################
		# Make a list of tables to be put in the FROM clause
		set from_list [join [array names from] ",\n\t\t"]

		###########################################################################
		# Construct conditions for the WHERE clause:
		###########################################################################
		# Get Join Criteria:
		set criteria_list ""
		if {[array size join_criteria] > 0} {
			append criteria_list "(" [join [array names join_criteria] "\n\t\t and "] ")"
		}
		
		if {([array size criteria] > 0) && ([array size join_criteria] > 0)} {
			append criteria_list "\n\t\t and "
		}
		
		# Get Search Criteria:
		if {[array size criteria] > 0} {
			append criteria_list "(" [join [array names criteria] "\n\t\t\t $junction"] ")"
		}
		
		# WHERE clause will not be empty, make sure to put 'where' before it:
		if {[exists_and_not_null criteria_list]} {
			set criteria_list "where $criteria_list"
		}
		
		# The basic piece of SQL for filtering and ordering results
		set filter_and_sort_sql "
		from	$from_list
		$criteria_list
		order  by last_name, first_names
		"
		
		# The query used to retrieve the attributes of the selected rows
		set select_attributes_sql "
		select	distinct inst_personnel.personnel_id,
		first_names,
		last_name,
		degree_titles,
		decode(inst_personnel.personnel_id - :user_id, 0, 1, 0)	as user_is_this_person_p
		$filter_and_sort_sql
		"
		
		db_multirow -extend {detail_url} found search_personnel_query $select_attributes_sql {
			# url for showing details about a particular personnel
			set detail_url	"detail?[export_vars {personnel_id return_url}]"
			# this is not an "action URL" so don't set personnel_action_url_exists_p
		}
		set n_results   ${found:rowcount}
	}

}

