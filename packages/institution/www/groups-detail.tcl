# -*- tab-width: 4 -*-
ad_page_contract {
	@author helsleya@cs.ucr.edu
} {
	{group_id:integer,optional}
	{path:optional}
	{show:optional ""}
	{hide:optional ""}
} -validate {
	group_id_xor_path_defined {
		if {[exists_and_not_null group_id] == [exists_and_not_null path]} {
			ad_complain {
				Exactly one of <code>group_id</code> or <code>path</code>
				must be given when retrieving this page.
			}
		}
	}
}

set subsite_id	[ad_conn subsite_id]
set subsite_url [site_node::get_url_from_object_id -object_id $subsite_id]
set context		[list [list "/" ""] "Departments"]

if {[exists_and_not_null path]} {
	set group_id [db_string group_path_to_group_id {
		select inst_group.lookup(:path) from dual
	}]
}

### CHECK IF GROUP IS AN ALIAS FOR ANOTHER GROUP
set alias_for_group_id [db_string get_alias_for_group_id {} -default 0]
if {$alias_for_group_id} {
	set group_id $alias_for_group_id
}

if {![db_0or1row group_detail {} -column_array details]} {
	ad_return_complaint 1 "The requested group does not exist."
	ad_script_abort
}

# Determine if we want to show the name of the parent-group
set show_parent_name_p [db_string is_subsite_root_p "
	select 0 from dual
	where [subsite::parties_sql -only -root -trunk -groups -party_id {:group_id}]
" -default 1]

regsub -all "<\\\[\\.>"			$details(description) "<blockquote>"			details(description)
regsub -all "<\\.\\\]>"			$details(description) "</blockquote>"			details(description)
regsub -all "(\[.?!:\])\n"		$details(description) "\\1<p>\\\&nl;\\\&nl;"	details(description)
regsub -all "\n"				$details(description) "<br>\\\&nl;"				details(description)
regsub -all "\\\&nl;"			$details(description) "\n"						details(description)
regsub -all "\[^<\]\\\[\[^>\]"	$details(description) "\\\\\["					details(description)
regsub -all "\[^<\]\\\]\[^>\]"	$details(description) "\\\\\]"					details(description)

# replace any '<image.../>' tags:
set details(description) [party_image::subst -party_id $group_id $details(description)]

################################################################################
# Replace references to handbook departments, divisions or programs with valid
# URLs to the corresponding group.  This is a three step process:
#	1 - define a proc that translates handbook_id's into group_id's
#	2 - create a string that contains calls to a proc to translate the id
#	3 - perform the required substitutions in the resulting string
################################################################################
# Step 1:
proc map_hb_id {handbook_id} {
	return [db_string handbook_id_to_group_id {
		select	inst_group_id
		  from	ext_group_id_map
		 where	handbook_program_id = :handbook_id
	}]
}

# Step 2:
regsub -all "<\[\[\]>(\[0-9\]+)<\[\]\]>"	$details(description) "
		<a href=\"groups-detail?group_id=\[map_hb_id \\1\]\">\\\[here\\\]</a>
	" details(description)

# Step 3:
set details(description) [subst -novariables $details(description)]
################################################################################

# figure out if this is a PCN office
set pcn_p [string equal $details(group_type) "Primary Care Network Office"]

if {$pcn_p} {
	# only show parent group of PCN if parent is also a PCN office
	if {$details(parent_group_type) != "Primary Care Network Office"} {
		set show_parent_name_p 0
	}

	set title				"UCLA Healthcare - $details(short_name)"
	set group_phones_filter	""
	set physician_filter	{iphys.primary_care_physician_p		= 't'}
	set epgm_join_type		{(+)}

	set image_name "front"
	set front_photo_id [db_string get_image_id_by_name {
		select	image_id
		  from	inst_party_images
		 where	party_id	= :group_id
		   and	description	= :image_name
	} -default ""]

	set image_name "map"
	set map_image_id [db_string get_image_id_by_name {
		select	image_id
		  from	inst_party_images
		 where	party_id	= :group_id
		   and	description	= :image_name
	} -default ""]
} else {
	set title				"Departments"
	set group_phones_filter [db_map group_phones_filter]
	set physician_filter	"1 = 1"
	set epgm_join_type		""
}

# get a list of groups within this group, their count, and type
set children				[db_map group_children]
set children_list			[db_list group_children {}]
set children_p				[llength $children_list]
set subgroup_types			[db_list subgroup_types {}]

# if its a PCN Office and only has a single PCN within it, forward to that PCN
if {$pcn_p && $children_p == 1} {
	set group_id [lindex $children_list 0]
	template::forward "groups-detail?[export_url_vars group_id]"
}

# get information that categorizes this group
db_multirow group_cat_info	group_cat_info {}

# group contact info
db_multirow addresses		group_addresses {}
db_multirow -extend {format_phone_p} phones group_phone {} {
	set format_phone_p [regexp -- {^[0-9]+$} $phone_number]
}
db_multirow urls			group_urls {} {
	regsub -- {^(http(s)?://)?(.*)$} $url {http\2://\3} url
	if {$name == "Group Home Page Redirect"} {
		template::forward $url
	}
}
db_multirow emails			group_emails {}
db_multirow certifications	group_certifications {}

array set unique_titles [list]

# figure out which subset of personnel belong to the subsite
set subsite_id				[ad_conn subsite_id]
set subsite_personnel_p		[subsite::parties_sql -persons -party_id {p.person_id}]

# retrieve the personnel, filtering through the subsite_personnel_p predicate
set at_least_one_pcp_p		0
db_multirow personnel		group_personnel {} {
	if {![info exists unique_titles($title_id)]} {
		set unique_titles($title_id) $personnel_id
		set title_names($title_id) $title_singular
	} elseif {$unique_titles($title_id) != $personnel_id} {
		set title_names($title_id) $title_plural
	}

	if {$pcp_p} {
		set at_least_one_pcp_p 1
	}
}

db_multirow leaders			group_leaders {}

# Retrieve Vital Signs articles associated with any specialty of this group
db_multirow article_info	group_vital_signs_articles {} {}

if {[ad_conn user_id] > 0 &&
	[permission::permission_p -object_id $group_id -privilege write] &&
	![permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]} {
	set edit_url "admin/groups/detail?[export_vars {group_id}]"
}

# if there is only a URL, forward to it
if {[expr	${emails:rowcount}			+ \
			$children_p					+ \
			${group_cat_info:rowcount}	+ \
			${addresses:rowcount}		+ \
			${phones:rowcount}			+ \
			${emails:rowcount}			+ \
			${certifications:rowcount}	+ \
			${personnel:rowcount}		+ \
			${leaders:rowcount}			+ \
			${article_info:rowcount}] == 0 &&
	${urls:rowcount} == 1 &&
	![info exists edit_url]
	} {
	template::forward [multirow get urls 1 url]
}
