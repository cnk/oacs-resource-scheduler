# /packages/institution/www/search-faculty/index.tcl		-*- tab-width: 4 -*-
# modified from: /packages/institution/www/search-personnel/index.tcl
ad_page_contract {
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2003/??/??
	@cvs-id			$Id: index.tcl,v 1.2 2007/01/06 03:10:08 avni Exp $
} {
	{select_into:sql_identifier,optional	}
	{select_to:optional						}
	{return_url								[get_referrer]}
	{combine_method:integer					0}
	{language_spoken:optional				""}
	{gender:optional						""}
	{first_name:optional					""}
	{last_name:optional						""}
	{keyword:optional						""}
	{fn_cond:integer,optional				0}
	{ln_cond:integer,optional				0}
	{display:optional						"last_name"}
	{startrow:naturalnum,optional			1}
}

#//TODO// use [db_map partialquery_name] to get pieces of queries
set subsite_url [site_node_closest_ancestor_package_url]
set title "Search for Faculty"
set package_id [ad_conn package_id]
set subsite_id [ad_conn subsite_id]
set maxrows 15

set no_preference "(No Preference)"

# The 'set' for holding the search criteria:
array set criteria [list "(
		inst_personnel.status_id = category.lookup('//Personnel Status//Active')
		or inst_personnel.status_id = category.lookup('//Personnel Status//Accepting Patients')
	)
" 1]

# The 'set' for holding a list of data-sources:
array set from [list				\
					acs_objects		1 \
					persons			1 \
					inst_faculty	1 \
					inst_personnel	1]

# The 'set' for holding the table-joining criteria:
#	Join Criteria are held separate so that, when the user selects
# the 'Any' method (so that the search query is built using an 'OR'
# to make the list of criteria that get put in the WHERE clause)
# we can still make sure that the part of the WHERE clause that
# are criteria for joining tables uses an 'AND' in between.  Without
# this distinction, we would get back many meaningless rows due to
# extensive cartesian-products.
array set join_criteria \
			[list \
				inst_faculty.faculty_id\ =\ inst_personnel.personnel_id 1 \
				inst_faculty.faculty_id\ =\ persons.person_id 1 \
				inst_faculty.faculty_id\ =\ acs_objects.object_id 1]

# If we are searching through a subsite, add in the criteria for properly
# selecting only those faculty who are part of the subsite.
set subsite_criteria [subsite::parties_sql -persons -party_id {inst_faculty.faculty_id}]
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

# a list of URLs for searching on the letter that begins the last-name
set ltr_index [list]
foreach ltr {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z} {
	lappend ltr_index "<a href=\"\#\" onClick=\"doSearchOnLetter('$ltr');\">$ltr</a>"
}
set letter_index [join $ltr_index "&nbsp;"]

set force_reload [ns_rand]

################################################################################
# Create the search form
################################################################################
ad_form -name search -action "?[export_vars {force_reload}]" -form {
	{combine_method:integer(select),optional	{label ""}						{value 0}					{options {{"All" 0} {"Any" 1}}}}
	{language_spoken:text(select),optional		{label "Language Spoken"}		{value $language_spoken}	{options $language_options}}
	{gender:text(select),optional				{label "Gender"}				{value $gender}			{options {{"$no_preference"} {"Female" "f"} {"Male" "m"}}}}
	{fn_cond:integer(select)					{label ""}						{value 2}				{options {{"is" 0} {"contains" 2} {"begins with" 1} {"ends with" 3}}}}
	{first_name:text,optional					{label "First Name"}			{value $first_name}}
	{ln_cond:integer(select)					{label ""}						{value 2}				{options {{"is" 0} {"contains" 2} {"begins with" 1} {"ends with" 3}}}}
	{last_name:text,optional					{label "Last Name"}				{value $last_name}}
	{keyword:text,optional                      {label "Keyword"}               {value $keyword} {html {size 50}}}
	{search:text(submit)						{label "Search"}				{html {onClick "reSubmitInitial(false); return false;"}}}
	{display:text(select)						{label "View Results By"}		{value $display}        {options {{"First Name then Last Name" "first_names"} {"Last Name  then  First Name" "last_name"}}}}
} -after_submit {
	###########################################################################
	# Pre-process/Clean Search Criteria:
	###########################################################################
	# Language Spoken
	if {[exists_and_not_null language_spoken]} {
		set from(inst_personnel_language_map)												1
		set criteria(inst_personnel_language_map.language_id\ =\ :language_spoken)			1
		set join_criteria(inst_personnel_language_map.personnel_id\ =\ persons.person_id)	1
	} else { unset language_spoken }

	# Gender
	if {[exists_and_not_null gender]} {
		set from(inst_personnel)													1
		set criteria(gender\ =\ :gender)											1
		set join_criteria(persons.person_id\ =\ inst_personnel.personnel_id)		1
	} else { unset gender }

	# First Name - notice the case-insensitive comparision
	if {[exists_and_not_null first_name]} {
		set from(persons)	1
		if {![info exists fn_cond] || ($fn_cond == 0)} {
			set criteria(lower(first_names)\ =\ lower(:first_name))		1
		} else {
			set criteria(lower(first_names)\ like\ lower(:first_name))	1
			switch $fn_cond {
				1 { set first_name "$first_name%" }
				2 { set first_name "%$first_name%" }
				3 { set first_name "%$first_name" }
			}
		}
	} else { unset first_name }

	# Last Name - notice the case-insensitive comparision
	if {[exists_and_not_null last_name]} {
		set from(persons)	1
		if {![info exists ln_cond] || ($ln_cond == 0)} {
			set criteria(lower(last_name)\ =\ lower(:last_name))	1
		} else {
			set criteria(lower(last_name)\ like\ lower(:last_name)) 1
			switch $ln_cond {
				1 { set last_name "$last_name%" }
				2 { set last_name "%$last_name%" }
				3 { set last_name "%$last_name" }
			}
		}
	} else { unset last_name }

	# Keyword
	#set keyword ""
	if {[exists_and_not_null keyword]} {
		set from(inst_subsite_pers_res_intrsts) 1
		set criteria_key {
			(lower(lay_title)								like lower('%' || :keyword || '%')
			or lower(dbms_lob.substr(lay_interest,3950,1))	like lower('%' || :keyword || '%')
			or lower(technical_title)						like lower('%' || :keyword || '%')
			or lower((dbms_lob.substr(technical_interest,3950,1))) like lower('%' || :keyword || '%')
			or lower(inst_personnel.meta_keywords)		    like lower('%' || :keyword || '%'))
		}
		set criteria($criteria_key) 1
		set join_criteria(inst_faculty.faculty_id\ =\ inst_subsite_pers_res_intrsts.personnel_id(+))	1
	} else { unset keyword }

	# If the person is not looking for anyone by name, only show faculty who are
	# active.
	if {(![exists_and_not_null first_name] && ![exists_and_not_null last_name] && ![exists_and_not_null keyword])} {
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

	set sql "
		select	distinct faculty_id,
				first_names,
				last_name,
				degree_titles,
				sign(dbms_lob.getlength(photo)) photo_p
		  from	$from_list
		  $criteria_list
		  order  by last_name, first_names "

#DBG	ns_returnnotice 200 SQL "<pre>$sql</pre>"
#DBG	ad_script_abort

#ns_returnnotice 200 SQL "<pre>$sql</pre>"
#ad_script_abort

	# Keep our own row-number since the automatic db_multirow variable
	# will be clobbered by calling 'continue'.
	set rownum		0

	db_multirow -extend {
		detail_url
		photo_url
		result_in_range_p
		departments
	} found search_faculty_query $sql {
		incr rownum
		set detail_url "../personnel?[export_vars -override {{personnel_id $faculty_id}}]"
		set photo_url "../photo?[export_vars -override {{personnel_id $faculty_id}}]"

		if {($rownum < $startrow) || $rownum >= ($startrow + $maxrows)} {
			# Call 'continue' so that the row doesn't get processed twice
			# (see the docs on db_multirow and search for 'continue')
			continue
		} else {
			set result_in_range_p 1

			set departments [join [db_list inst_personnel_position_info {
				select	g.short_name as department
				from	acs_rels ar,
						inst_group_personnel_map igpm,
						categories pc,
						categories gc,
						inst_groups g
				where	ar.object_id_two = :faculty_id
				and		ar.object_id_one = g.group_id
				and		ar.rel_id		 = igpm.acs_rel_id
				and		igpm.title_id	 = pc.category_id
				and		g.group_type_id	 = gc.category_id
				order by gc.profiling_weight, pc.name, g.short_name
			}] "</li><li>"]
		}
	}

	# Set this since we cannot trust ${found:rowcount} since the 'continue'
	# above will remove some rows
	set rowcount	$rownum

	# some display variables
	set last_position [max 1 [expr $rowcount - ($rowcount % $maxrows) + 1]]
	set first_visible $startrow
	set last_visible [min $rowcount [expr $startrow + $maxrows - 1]]
}
