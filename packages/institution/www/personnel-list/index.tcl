# -*- tab-width: 4 -*-
ad_page_contract {
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2003/??/??
	@cvsid			$Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{group_id:naturalnum,optional 0}
}

set title		"Search for Personnel"
set subsite_url	[site_node_closest_ancestor_package_url]
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]

if {$group_id == 0 || [empty_string_p $group_id]} {
	set group_table		""
	set group_matches_p	"1 = 1"
} else {
	set group_table		", group_distinct_member_map gdmm"
	set group_matches_p	"(p.person_id = gdmm.member_id and gdmm.group_id = :group_id)"
}

set personnel_sql "
	select	psnl.personnel_id,
			first_names,
			last_name,
			upper(substr(last_name, 1, 1))	as last_name_initial,
			psnl.degree_titles
	  from	inst_personnel	psnl,
			persons			p
			$group_table
	 where	p.person_id		= psnl.personnel_id
	   and	(psnl.status_id		is null
			or psnl.status_id	in
			(category.lookup('//Personnel Status//Active'),
			 category.lookup('//Personnel Status//Accepting Patients')))
	   and	(psnl.start_date	is null	or	psnl.start_date	< sysdate)
	   and	(psnl.end_date		is null	or	psnl.end_date	> sysdate)
	   and	$group_matches_p
	   and	[subsite::parties_sql -persons -party_id {p.person_id}]
	  order	by last_name_initial, last_name, first_names
"

set letter_index_list [list]
db_multirow -extend {
	detail_url
	photo_url
	departments_html
} personnel personnel_sql $personnel_sql {
	if {[lsearch $letter_index_list $last_name_initial] == -1} {
		lappend letter_index_list $last_name_initial
	}
	set detail_url "../personnel?[export_vars {personnel_id}]"
}

# Pick the midpoint-letter (not necessarily midpoint by number of rows output)
#	to break into a second column of names.
set letter_index_length_half	[expr [llength $letter_index_list]/2]
set middle_letter_index			[lindex $letter_index_list $letter_index_length_half]

## Build Letter Index List
# a list of URLs for searching on the letter that begins the last-name
set letter_index_list [list]
foreach letter {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z} {
	lappend letter_index_list "<a href=\"#$letter\">$letter</a>"
}
set letter_index_list [join $letter_index_list "&nbsp;"]
## End Building Letter Index List
