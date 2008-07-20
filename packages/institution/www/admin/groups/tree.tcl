# -*- tab-width: 4 -*-
# @author			helsleya@cs.ucr.edu (AH)
# @creation-date	2004-01-21
# @cvs-id			$Id: tree.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

# TEMPLATE INPUTS: roots [show] [hide] [root_group_id] [return_url]
#	The user of this template is also responsible for passing in (by reference)
#	any bind variables which are needed in the 'roots' subquery.

# Check for the 'canary' variable (detects attempts to access this template directly)
if {![info exists roots]} {
	ad_return_error "Invalid Request" {
		This template may only be used as a component of another page.  If you
		arrived here as a result of clicking on a URL, please notify the
		webmaster.
	}
	ad_script_abort
}

if {[info exists maxdepth]} {
	set rigid_p 1
	set depth_filter "(:maxdepth = -1 or level <= :maxdepth)"
} else {
	set rigid_p 0
	set depth_filter "0 = 1"
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

# this is used to create a proper URL for setting permissions
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# this is used for the expand_url below
set this_page [ad_conn url]

# this is the common part of all (well, almost all) urls on this page
set parent_url "[ad_conn package_url]admin/groups/"

################################################################################
################################################################################
# Manage the cookies that store expanded groups.
# The show and hide below should each be idempotent.
set expanded			[ad_get_cookie "expanded_groups" ""]
set visible_expanded	[ad_get_cookie "visible_expanded_groups" ""]
if {$visible_expanded == "null"} {
	set visible_expanded ""
}
if {![regexp {^(|[0-9]+(:[0-9]+)*)$} $expanded]} {
	ad_complain -key expanded "The cookie 'expanded' must be a colon-separated list of integers"
}
if {![regexp {^(|[0-9]+(:[0-9]+)*)$} $visible_expanded]} {
	ad_complain -key expanded "The cookie 'visible_expanded' must be a colon-separated list of integers"
}
if {[ad_complaints_count] > 0} {
	ad_return_complaint	[ad_complaints_count] "<li>[join [ad_complaints_get_list] "</li>\n<li>"]</li>\n"
	ad_script_abort
}

set expanded			[split $expanded ":"]
set visible_expanded	[split $visible_expanded ":"]
template::util::list_to_lookup $expanded			expanded_set
template::util::list_to_lookup $visible_expanded	visible_expanded_set

# SHOW #########################################################################
# add those groups that were expanded but hidden and are now visible because a single node was expanded by the user
if {[exists_and_not_null show] && ![info exists visible_expanded_set($show)]} {
	set visible_expanded_set($show) -1
	set expanded_set($show) -1

	# NOTE: the ordering (by level) is _very_ important here
	set r_group_id $show

	db_foreach group_descendants_by_level {} {
		if {[info exists visible_expanded_set($parent_group_id)] && \
			[info exists expanded_set($group_id)]} {
			set visible_expanded_set($group_id) -1
		}
	}
}

# HIDE #########################################################################
# remove those groups that were expanded but are now hidden because a single node was hidden by the user
if {[exists_and_not_null hide] && [info exists visible_expanded_set($hide)]} {
	unset visible_expanded_set($hide)
	if {[info exists expanded_set($hide)]} {
		unset expanded_set($hide)
	}

	set r_group_id $hide
	db_foreach group_descendants {} {
		if {[info exists visible_expanded_set($child_id)]} {
			unset visible_expanded_set($child_id)
		}
	}
}

################################################################################
# remove place holder from visible expanded set when placeholder is not the only node in the set
if {[array size visible_expanded_set] > 1 && [info exists visible_expanded_set(null)]} {
	unset visible_expanded_set(null)
} elseif {[array size visible_expanded_set] < 1} {
	set visible_expanded_set(null) -1
}

set expanded			[array names expanded_set]
set visible_expanded	[array names visible_expanded_set]
################################################################################
################################################################################

# force browsers with poor caching behavior to obey
set force_reload		[ns_rand]

################################################################################
################################################################################
# GET TREE DATA
if {[info exists root_group_id]} {
	set group_id		$root_group_id
}

# This is a variable used in rendering to figure out how many columns the table
# will need in order to display the groups.
set max_visible_depth	[db_string max_visible_depth {}]

# setup a row to establish the columns that will hold 'expand' widgets
#//TODO// maybe replace 'emptyrow' with a 'colgroup' tag?
set emptyrow ""
for {set i 0} {$i < $max_visible_depth} {incr i} {
	append emptyrow "<td align=\"right\" width=\"25px\"></td>\n\t\t\t"
}

# setup a stack to use in constructing the sort-key
set stack [list]

# 'group_action_url_exists_p' tells us whether the user is allowed to perform actions on the group.
#	An action URL is (typically) anything except 'view' or 'details'
set group_action_url_exists_p 0

# find out what kind of actions the enclosing page limits us to
if {![array exists allow_action_p]} {
	array set allow_action_p {
		view	1
		add		1
		edit	1
		delete	1
		permit	1
	}
} else {
	if {![info exists allow_action_p(view)]} {
		set allow_action_p(view)	0
	}
	if {![info exists allow_action_p(add)]} {
		set allow_action_p(add)		0
	}
	if {![info exists allow_action_p(edit)]} {
		set allow_action_p(edit)	0
	}
	if {![info exists allow_action_p(delete)]} {
		set allow_action_p(delete)	0
	}
	if {![info exists allow_action_p(permit)]} {
		set allow_action_p(permit)	0
	}
}

db_multirow -extend {
	action_url_exists_p
	create_subgroup_url
	edit_url
	delete_url
	permit_url
	expand_url
	expand_txt
	detail_url
	detail_colspan
	sort_key
	jccc_url
	titles_report_url
} group_tree_view group_tree {} {
	# read_p --> user can see this group
	# All results from the query should be readable, but just in case...
	if {!$read_p} {
		continue
	} elseif {$allow_action_p(view)} {
		# url for showing details about a particular group
		set detail_url	"${parent_url}detail?[export_vars {group_id}]"
		# this is not an "action URL" so don't set group_action_url_exists_p
	}

	# write_p --> user can edit this group
	if {$allow_action_p(edit) && $write_p}	{
		set edit_url "${parent_url}add-edit?[export_vars {group_id}]"
		set action_url_exists_p				1
		set group_action_url_exists_p	1
	}

	# create_p --> user can create a subgroup within this group
	if {$allow_action_p(add) && $create_p} {
		set create_subgroup_url "${parent_url}add-edit?[export_vars -override {{parent_group_id $group_id}}]"
		set action_url_exists_p				1
		set group_action_url_exists_p	1
	}

	# delete_p --> user can delete this group
	if {$allow_action_p(delete) && $delete_p}	{
		set delete_url "${parent_url}delete?[export_vars {group_id}]"
		set action_url_exists_p				1
		set group_action_url_exists_p	1
	}

	# admin_p --> user can change the privileges on this group
	if {$allow_action_p(permit) && $admin_p}	{
		set permit_url "${subsite_url}permissions/one?[export_vars -override {{object_id $group_id}}]"
		set action_url_exists_p				1
		set group_action_url_exists_p	1

		set titles_report_url [export_vars -base ${parent_url}../title/report/generate {{department_id $group_id}}]
	}

	# jccc_url -->
	set jccc_group_p 0
	set jccc_url ""

	set detail_colspan [expr $max_visible_depth - $level + 1 + $rigid_p]

	# text to go with above url: '+' for un-expanded composite groups,,
	#  '-' for expanded composite groups, and '' for non-composite groups
	if {$n_children > 0} {
		set url_vars [list force_reload]
		if {[info exists root_group_id]} {
			lappend url_vars "group_id $root_group_id"
		}

		if {![info exists maxdepth]} {
			# make url for expanding/hiding subsidiary groups
			if {[info exists visible_expanded_set($group_id)]} {
				lappend url_vars "hide $group_id"
				set expand_txt "-"
			} else {
				lappend url_vars "show $group_id"
				set expand_txt "+"
			}

			set expand_url "${this_page}?[export_vars $url_vars]"
		}
	}

	# setup a sort-key:
	#	1. Pop off the top until 'level - 1' items are in the stack.
	#	2. Push the name of the current group onto the stack.
	#	3. The sort-key is the concatenation of the stack elements.
	#		To enhance run-time efficiency in deep trees, we avoid always
	#		concatenating long lists by keeping a string ('sk_tmp') and
	#		chopping off the bits of it that change between rows.
	set top		[llength $stack]
	set newtop	[expr $level - 1]
	if {$newtop < $top && $newtop >= 0} {
		set topelements	"//[join [lrange $stack $newtop end] //]"
		set stack		[lreplace $stack $newtop end]
		set	sk_tmp		[string range $sk_tmp \
							 0 \
							 [expr [string length $sk_tmp] \
								  - [string length $topelements] \
								  - 1]]
	}
	lappend	stack			"$short_name $group_id"
	append	sk_tmp			"//" $short_name " " $group_id
	set		sort_key		$sk_tmp

	# root_w_child_exists_p, unique_group_types
	set level [expr $level - $rigid_p]
}

# sort results by the sort-key
set tbl [template::util::multirow_to_list group_tree_view]
if {[llength $tbl] > 1} {
	set row [lindex $tbl 0]
	set sort_index [expr 1 + [lsearch -exact $row "sort_key"]]
	template::util::list_to_multirow group_tree_view [lsort -index $sort_index $tbl]
}

# //TODO// figure out why this is incremented and leave a comment...
incr max_visible_depth

ad_set_cookie -replace 't' -path [ns_conn url] "expanded_groups" [join $expanded ":"]
ad_set_cookie -replace 't' -path [ns_conn url] "visible_expanded_groups" [join $visible_expanded ":"]
