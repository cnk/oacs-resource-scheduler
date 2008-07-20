# -*- tab-width: 4 -*-
ad_page_contract {
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2003/??/??
	@cvsid			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{select_into:sql_identifier,optional}
	{select_to:optional					}
	{exclude_group_id:integer,optional	}
	{return_url							[get_referrer]}
	{combine_method:integer				0}
	{research_interest:integer,optional	""}
	{language_spoken:optional			""}
	{gender:optional					""}
	{first_name:optional				""}
	{last_name:optional					""}
	{fn_cond:integer,optional			0}
	{ln_cond:integer,optional			0}
	{display:optional					"last_name"}
	{startrow:naturalnum,optional		1}
}

#//TODO// add search by title: title, group, status, university-id, start-date, end-date
#//TODO// use [db_map partialquery_name] to get pieces of queries
set subsite_url	[site_node_closest_ancestor_package_url]
set title		"Search for Personnel"
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]
set maxrows		15
set endrow		[expr $startrow + $maxrows - 1]

set no_preference "(No Preference)"

# The 'set' for holding the search criteria:
array set criteria [list]

# The 'set' for holding a list of data-sources:
array set from [list \
					acs_objects 1 \
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
array set join_criteria \
			[list \
				inst_personnel.personnel_id\ =\ persons.person_id 1 \
				inst_personnel.personnel_id\ =\ acs_objects.object_id 1]

# If we are searching through a subsite, add in the criteria for properly
# selecting only those personnel who are part of the subsite.  Do not put in the
# criteria if the page was told to exclude direct members of a particular group.
if {[exists_and_not_null select_into] && [exists_and_not_null select_to]} {
	set subsite_criteria "1 = 1"
} elseif {[exists_and_not_null exclude_group_id]} {
	set subsite_criteria {
		not exists
		(select	1
		   from	vw_group_member_map
		  where	parent_id	= :exclude_group_id
			and	child_id	= inst_personnel.personnel_id)
	}
} else {
	set subsite_criteria [subsite::parties_sql -persons -party_id {inst_personnel.personnel_id}]
}
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
# for Research Interest
set research_interest_options	[linsert [db_list_of_lists research_interests {}] 0 [list $no_preference]]

# for Language
set language_options			[linsert [db_list_of_lists possible_languages {}] 0 [list $no_preference]]

# for Department/Division/...
set groups						[linsert [db_list_of_lists subsite_groups {}] 0 [list $no_preference]]

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
ad_form -name search -export [list exclude_group_id select_to select_into return_url] -action "?[export_vars {force_reload}]" -form {
	{combine_method:integer(select),optional	{label ""}						{value 0}					{options {{"All" 0} {"Any" 1}}}}
	{research_interest:integer(select),optional	{label "Research Interest"}		{value $research_interest}	{options $research_interest_options}}
	{language_spoken:text(select),optional		{label "Language Spoken"}		{value $language_spoken}	{options $language_options}}
	{gender:text(select),optional				{label "Gender"}				{value $gender}				{options {{"$no_preference"} {"Female" "f"} {"Male" "m"}}}}
	{fn_cond:integer(select)					{label ""}						{value 2}					{options {{"is" 0} {"contains" 2} {"begins with" 1} {"ends with" 3}}}}
	{first_name:text,optional					{label "First Name"}			{value $first_name}}
	{ln_cond:integer(select)					{label ""}						{value 2}					{options {{"is" 0} {"contains" 2} {"begins with" 1} {"ends with" 3}}}}
	{last_name:text,optional					{label "Last Name"}				{value $last_name}}
	{group_id:integer(select),optional			{label "Department/Division/..."} {options $groups}}
	{search:text(submit)						{label "Search"}				{html {onClick "reSubmitInitial(false); return false;"}}}
	{display:text(select)						{label "View Results By"}		{value $display}			{options {{"First Name then Last Name" "first_names"} {"Last Name  then  First Name" "last_name"}}}}
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

	# Research Interest
	if {[exists_and_not_null research_interest]} {
		set from(inst_party_category_map\ ipcm_for_ci)							1
		set criteria(ipcm_for_ci.category_id\ =\ :research_interest)				1
		set join_criteria(ipcm_for_ci.party_id\ =\ persons.person_id)				1
	} else { unset research_interest }

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

	# Department
	if {[exists_and_not_null group_id]} {
		set from(group_approved_member_map)								1
		set criteria(group_id\ =\ :group_id)							1
		set join_criteria(group_approved_member_map.member_id\ =\ inst_personnel.personnel_id)	1
	} else { unset group_id }

	# If the person is not looking for anyone by name, only show personnel who are
	# active.
	if {(![exists_and_not_null first_name] && ![exists_and_not_null last_name])} {
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

	# The query used to count the selected rows
	set count_sql "
		select	count(personnel_id)
			$filter_and_sort_sql
	"

	# The query used to retrieve the attributes of the selected rows
	set select_attributes_sql "
		select	distinct personnel_id,
				first_names,
				last_name,
				degree_titles,
				sign(dbms_lob.getlength(photo)) photo_p
			$filter_and_sort_sql
	"

	# The query used to retrieve the attributes of the selected rows on the page
	set paginate_sql "
		select	*
		  from	(select	search_results.*,
						rownum as unpaginated_rownum
				   from	($select_attributes_sql) search_results)
		 where	unpaginated_rownum between :startrow and :endrow
	"

#	ns_returnnotice 200 SQL "<pre>$count_sql</pre>"
#	ad_script_abort

	set n_results [db_string count_sql $count_sql -default 0]
	db_multirow -extend {
		detail_url
		photo_url
		departments_html
	} found search_personnel_query $paginate_sql {
		if {[exists_and_not_null select_into] && [exists_and_not_null select_to]} {
			set detail_url	[export_vars -base $select_to -override [list [list $select_into $personnel_id]]]
		} elseif {![exists_and_not_null exclude_group_id]} {
			set detail_url	"../detail?[export_vars {personnel_id}]"
		} else {
			set detail_url	"../../title/add-edit?[export_vars -override {{group_id $exclude_group_id}} {personnel_id return_url}]"
		}
		set photo_url "../photo?[export_vars {personnel_id}]"

		set departments_html [join [db_list inst_personnel_position_info {
			select	g.short_name as department
			  from	acs_rels ar,
					inst_group_personnel_map igpm,
					categories pc,
					categories gc,
					inst_groups g
			 where	ar.object_id_two = :personnel_id
			   and	ar.object_id_one = g.group_id
			   and	ar.rel_id		 = igpm.acs_rel_id
			   and	igpm.title_id	 = pc.category_id
			   and	g.group_type_id	 = gc.category_id
			 order	by gc.profiling_weight, pc.name, g.short_name
		}] "</li><li>"]
	}

	# some display variables
	set n_results_on_page	${found:rowcount}
	set last_position		[max 1 [expr $n_results - ($n_results % $maxrows) + 1]]
	set first_visible		$startrow
	set last_visible		[min $n_results [expr $startrow + $maxrows - 1]]
}
