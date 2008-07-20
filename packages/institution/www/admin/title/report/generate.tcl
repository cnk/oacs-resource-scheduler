# /institution/www/admin/personnel-title-report.tab.tcl		-*- tab-width: 4 -*-
ad_page_contract {
	Output a report of personnel-titles within a department's divisions.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-12-15 14:38 PST
	@cvs-id			$Id: generate.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	department_id:integer
}

################################################################################
# Check for sibling groups which conflict in the first 32 letters of short_name:
#	col	parent_group_id	format 999999
#	col	g1_group_id		format 999999
#	col	pname			format a48
#	col	g1_oname		format a60
#	col	g2_oname		format a60
#	col	g1_sname		format a60
#	col	g2_sname		format a60
#	select	g1.parent_group_id,
#			g1.group_id							as g1_group_id,
#			g2.group_id							as g2_group_id,
#			acs_object.name(g1.parent_group_id)	as pname,
#			acs_object.name(g1.group_id)		as g1_oname,
#			acs_object.name(g2.group_id)		as g2_oname,
#			g1.short_name						as g1_sname,
#			g2.short_name						as g2_sname
#	  from	inst_groups	g1,
#			inst_groups	g2
#	 where	(lower(substr(g1.short_name,1,32)) = lower(substr(g2.short_name,1,32))
#			or lower(substr(acs_object.name(g1.group_id),1,32)) = lower(substr(acs_object.name(g2.group_id),1,32)))
#	   and	g1.parent_group_id = g2.parent_group_id
#	   and	g1.group_id < g2.group_id;
#
#
################################################################################
set department_name [db_string department-name {
	select	acs_object.name(:department_id) from dual
}]

set physician_title_id [db_string physician-title-id {
	select	category.lookup('//Personnel Title//Physician') from dual
}]

# one-way (not necessarily collision-free) transform of file-name to one that is
# safe for using in most file-systems
proc path_hash {dir file} {
	regsub -all -- { } $file {_} file
	regsub -all -- {/} $file {} file
	regsub -all -- {:} $file {} file
	regsub -all -- {,} $file {} file
	regsub -all -- {&} $file {and} file
	regsub -all -- "\r" $file {} file
	regsub -all -- "\n" $file {} file
	if {[string length $dir] > 0} {
		return "$dir/$file"
	} else {
		return $file
	}
}

# save a chunk of text to a file
proc save {path data} {
	set ch [open $path {WRONLY CREAT}]
	puts -nonewline $ch $data
	close $ch
}

################################################################################
# Produce a README.txt
################################################################################
save /tmp/README.txt "
Background\r
\r
This is a report of titles/appointments within a department and its divisions.\r
Each division will appear in a separate tab at the bottom of the Excel Sheet.\r
Please change the details of existing titles as appropriate.  To remove a title,\r
please change the 'status' and do not delete the row.  To add a title, make sure\r
to fill in UCLA employee ID, title, and status.  The end date is optional, feel\r
free to fill it out at your convenience.\r
\r
Directions\r
	to remove a title, please change the status of the title\r
	to add a title, create a new row in the appropriate tab, fill in its
		employee\r ID and choose the title\r
	fill in end-date at your convenience\r
\r
Fields and Their Meanings\r
\r
Special Note About Physicians\r
\r
Physician titles are changed through the Medical Group, but feel free to make\r
any changes to these you'd like and we will forward them to the appropriate\r
people for further consideration.\r
"

################################################################################
# Produce tree of titles
################################################################################
set titles_tree_txt ""
db_foreach personnel-title {
	select	name								as title,
			rpad(' ', (level-1)*4, ' ') || name	as pretty_title,
			description							as description
	  from	categories
	connect	by prior category_id = parent_category_id
	 start	with parent_category_id = category.lookup('//Personnel Title')
} {
	append titles_tree_txt $title "\t" $pretty_title "\t" $description "\r\n"
}

#//TODO// sort these

# output file named /tmp/titles.txt w/ data in it
save /tmp/title-codes.tab $titles_tree_txt

################################################################################
# Produce tree of status-codes
################################################################################
set status_tree_txt ""
db_foreach personnel-title {
	select	name								as title,
			rpad(' ', (level-1)*4, ' ') || name	as pretty_title,
			description							as description
	  from	categories
	connect	by prior category_id = parent_category_id
	 start	with parent_category_id = category.lookup('//Personnel Status')
} {
	append status_tree_txt $title "\t" $pretty_title "\t" $description "\r\n"
}

#//TODO// sort these

# output file named /tmp/status-codes.txt w/ data in it
save /tmp/status-codes.tab $status_tree_txt

################################################################################
# Directly-associated titles
################################################################################
set tab_delimited_table	"Title ID\tFaculty ID\tUniversity ID\tSubgroup\tMember\tTitle\tEnd Date\tStatus\tComments\r\n"
db_foreach personnel-department-title {
	select	gpm.gpm_title_id									as title_id,
			psnl.personnel_id									as faculty_id,
			lpad(nvl(psnl.university_id, psnl.ucla_id), 9, '0')	as university_id,
			:department_name									as department,
			:department_name									as subgroup,
			acs_object.name(rel.object_id_two)					as member,
			nvl(gpm.pretty_title, ttl.name)						as title,
			gpm.end_date										as end_date,
			stt.name											as status
	  from	inst_personnel				psnl,
			persons						psn,
			acs_rels					rel,
			inst_group_personnel_map	gpm,
			categories					ttl,
			categories					stt
	 where	psn.person_id		= psnl.personnel_id
	   and	psnl.personnel_id	= rel.object_id_two
	   and	rel.object_id_one	= :department_id
	   and	rel.rel_id			= gpm.acs_rel_id
	   and	gpm.title_id		= ttl.category_id
	   and	gpm.status_id		= stt.category_id (+)
	 order	by department, subgroup, member, title, end_date, status
} {
	#-   and	:physician_title_id	not in
	#-		(ttl.parent_category_id, ttl.category_id)

	append tab_delimited_table	\
		$title_id		"\t"	\
		$faculty_id		"\t"	\
		$university_id	"\t"	\
		$subgroup		"\t"	\
		$member			"\t"	\
		$title			"\t"	\
		$end_date		"\t"	\
		$status			"\r\n"
}

set file_name [path_hash "" "$department_name.tab"]
save /tmp/$file_name $tab_delimited_table
lappend file_names $file_name

# this transformed department name is not used until later...
regsub -- {.tab$} $file_name {} zipfile_base
set zipfile_name $zipfile_base.zip

################################################################################
# Sub*-division titles
################################################################################
set divisions [db_list deparment-divisions {
	select	group_id
	  from	inst_groups		grp
	 where	parent_group_id	= :department_id
}]

foreach division_id $divisions {
	set division_name		""
	set tab_delimited_table	"Title ID\tFaculty ID\tUniversity ID\tSubgroup\tMember\tTitle\tEnd Date\tStatus\tComments\r\n"

	db_foreach personnel-title {
		select	gpm.gpm_title_id									as title_id,
				psnl.personnel_id									as faculty_id,
				lpad(nvl(psnl.university_id, psnl.ucla_id), 9, '0')	as university_id,
				acs_object.name(gem.ancestor_id)					as division,
				acs_object.name(gem.parent_id)						as subgroup,
				acs_object.name(gem.child_id)						as member,
				nvl(gpm.pretty_title, ttl.name)						as title,
				gpm.end_date										as end_date,
				stt.name											as status
		  from	inst_personnel				psnl,
				persons						psn,
				vw_group_element_map 		gem,
				inst_group_personnel_map	gpm,
				categories					ttl,
				categories					stt
		 where	psn.person_id		= psnl.personnel_id
		   and	psnl.personnel_id	= gem.child_id
		   and	gem.ancestor_id		= :division_id
		   and	gem.rel_id			= gpm.acs_rel_id
		   and	gpm.title_id		= ttl.category_id
		   and	gpm.status_id		= stt.category_id (+)
		 order	by division, subgroup, member, title, end_date, status
	} {
		#-   and	:physician_title_id	not in
		#-		(ttl.parent_category_id, ttl.category_id)

		# cleanup a couple division names that are not unique enough for Excel (first 32 chars are the same)
		regsub {\(Goldschmied\)} $subgroup {} subgroup
		regsub {^ACCESS Department - } $subgroup {} subgroup

		set division_name $division
		append tab_delimited_table	\
			$title_id		"\t"	\
			$faculty_id		"\t"	\
			$university_id	"\t"	\
			$subgroup		"\t"	\
			$member			"\t"	\
			$title			"\t"	\
			$end_date		"\t"	\
			$status			"\r\n"
	}

	# output file named $division_name.tab w/ data in it
	if {[exists_and_not_null division_name]} {
		set file_name [path_hash "" "$division_name.tab"]
		save /tmp/$file_name $tab_delimited_table
		lappend file_names $file_name
	}
}

################################################################################
# Produce a manifest
save /tmp/manifest.tab [join $file_names "\r\n"]

################################################################################
# Produce zip file of README, tree-of-titles, tree-of-status-codes, department,
# and each division.
################################################################################
set olddir [pwd]
cd /tmp
exec cp /web/ucla/packages/institution/www/admin/title/report/Start-Here.xls /tmp
eval "exec zip $zipfile_name manifest.tab README.txt title-codes.tab status-codes.tab Start-Here.xls $file_names"
eval "exec rm manifest.tab README.txt title-codes.tab status-codes.tab Start-Here.xls $file_names"
cd $olddir

template::forward [export_vars -base $zipfile_name]
# vim:set ts=4 sw=4
