# -*- tab-width: 4 -*-
#
# NOTE: great care should be taken in what values are passed to this template,
# specifically for the <code>roots</code> variable, since it is <i>not</i>
# passed to the query using a bind variable.  This allows Oracle to optimize
# query execution time, minimizes the amount of data that must pass from TCL to
# Oracle (otherwise the data would be extensive lists of object-ids), and is
# very flexible.
#
# @param	roots				A query returning a list of id&apos; (or a list
#									of id&apos;) of categories that should be
#									displayed at the top-level.
# @param	root_category_id	(optional) Used to keep track of the category
#									that is being viewed -- otherwise URLs
#									followed by clicking expand or collapse will
#									always lead back to the top-level category
#									display page, a confusing thing to have
#									happen.
#								NOTE: We call this <code>root_category_id</code>
#									because <code>category_id</code> will get
#									clobbered by the queries.
# @param	show				(optional) The id of a category to expand in the
#									category-tree.
# @param	hide				(optional) The id of a category to collapse in
#									the category-tree.
# @param	allow_action_p		(optional) The set of all actions that may be
#									displayed in the tree (from <code>view, add,
#									edit, delete, permit</code>)  This variable
#									is a TCL array, set an <code>action</code>
#									to <code>1</code> to enable it,
#									<code>0</code> to disable it.
#									If the array is not passed, it is assumed all actions
#									should be displayed when sufficient privileges exits.
#									If the array is passed, then it is assumed no actions
#									should ever be displayed in the tree.
# @param	tree_title			(optional) The title to use for the column
#									showing the <code>name</code> of each
#									category.
#
# @author			helsleya@cs.ucr.edu (AH)
# @creation-date	2004-01-07
# @cvs-id			$Id: tree.tcl,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
#

# Check for the 'canary' variable (detects attempts to access this template directly)
if {![info exists roots]} {
	ad_return_error "Invalid Request" {
		This template may only be used as a component of another page.  If you
		arrived here as a result of clicking on a URL, please notify the
		webmaster.
	}
	ad_script_abort
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]

# this variable is used to build proper URLs for managing permissions
set subsite_url	[site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]

# this is used for the expand_url below
set this_page [ad_conn url]

# this is the common part of all (well, almost all) urls on this page
set parent_url "[ad_conn package_url]"

if {![info exists tree_title]} {
	set tree_title "Category"
}

ns_log notice "TREE tree_title: $tree_title"

################################################################################
################################################################################
# Manage the cookies that store expanded categories.
# The show and hide below should each be idempotent.
set expanded			[split [ad_get_cookie "expanded_categories" ""] ":"]
set visible_expanded	[split [ad_get_cookie "visible_expanded_categories" "null"] ":"]

template::util::list_to_lookup $expanded			expanded_set
template::util::list_to_lookup $visible_expanded	visible_expanded_set

# SHOW #########################################################################
# add those categories that were expanded but hidden and are now visible because a single node was expanded by the user
if {[exists_and_not_null show] && ![info exists visible_expanded_set($show)]} {
	set visible_expanded_set($show) -1
	set expanded_set($show) -1

	# NOTE: the ordering (by level) is _very_ important here
	set r_category_id $show

	db_foreach category_descendants_by_level {} {
		if {[info exists visible_expanded_set($parent_category_id)] && \
			[info exists expanded_set($category_id)]} {
			set visible_expanded_set($category_id) -1
		}
	}
}

# HIDE #########################################################################
# remove those categories that were expanded but are now hidden because a single node was hidden by the user
if {[exists_and_not_null hide] && [info exists visible_expanded_set($hide)]} {
	unset visible_expanded_set($hide)
	if {[info exists expanded_set($hide)]} {
		unset expanded_set($hide)
	}

	set r_category_id $hide
	db_foreach category_descendants {} {
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

if {[string equal [string tolower [db_type]] "postgresql"]} {
	### in Postgresql, we have trouble with extra rows that are not within the tree. 
	### in Oracle, the start with eliminates them; in postgres, this code removes them
	if {[exists_and_not_null root_category_id]} {
		set root_category_treelevel [db_string root_category_treelevel {} -default 1]
		set visible_expanded [db_list visible_expanded_pruned {}]
		lappend visible_expanded $root_category_id
	}
}

################################################################################
################################################################################

# force browsers with poor caching behavior to obey (i.e. Safari)
set force_reload		[ns_rand]

################################################################################
################################################################################
# GET TREE DATA
# set 'category_id' so it can be used in a 'roots' clause that is a sub-query
if {[exists_and_not_null root_category_id]} {
	set category_id		$root_category_id
}
set maxdepth			[db_string max_visible_depth {}]

# setup a row to establish the columns that will hold 'expand' widgets
#//TODO// maybe replace 'emptyrow' with a 'colgroup' tag?
set emptyrow ""
for {set i 0} {$i < $maxdepth} {incr i} {
	append emptyrow "<td align=\"right\" width=\"25px\"></td>\n\t\t\t"
}

# setup a stack to use in constructing the sort-key
set stack [list]

# 'category_action_url_exists_p' tells us whether the user is allowed to perform actions on the category.
#	An action URL is (typically) anything except 'view' or 'details'
set category_action_url_exists_p 0

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
	create_subcategory_url
	edit_url
	delete_url
	permit_url
	expand_url
	expand_txt
	detail_url
	detail_colspan
	sort_key
} category_tree_view category_tree {} {
	# read_p --> user can see this category
	# All results from the query should be readable, but just in case...
	if {!$read_p} {
		continue
	} elseif {$allow_action_p(view)} {
		# remember, the 'index' page for a category is actually a detail page
		# url for showing details about a particular category
		set detail_url	"${parent_url}?[export_vars {category_id}]"
		# this is not an "action URL" so don't set category_action_url_exists_p
	}

	# write_p --> user can edit this category
	if {$allow_action_p(edit) && $write_p}	{
		set edit_url "${parent_url}add-edit?[export_vars {category_id}]"
		set action_url_exists_p				1
		set category_action_url_exists_p	1
	}

	# create_p --> user can create a subcategory within this category
	if {$allow_action_p(add) && $create_p} {
		set create_subcategory_url "${parent_url}add-edit?[export_vars -override {{parent_category_id $category_id}}]"
		set action_url_exists_p				1
		set category_action_url_exists_p	1
	}

	# delete_p --> user can delete this category
	if {$allow_action_p(delete) && $delete_p}	{
		set delete_url "${parent_url}delete?[export_vars {category_id}]"
		set action_url_exists_p				1
		set category_action_url_exists_p	1
	}

	# admin_p --> user can change the privileges on this category
	if {$allow_action_p(permit) && $admin_p}	{
		set permit_url "${subsite_url}permissions/one?[export_vars -override {{object_id $category_id}}]"
		set action_url_exists_p				1
		set category_action_url_exists_p	1
	}

	set detail_colspan [expr $maxdepth - $level + 1]

	# text to go with above url: '+' for un-expanded composite categories,,
	#  '-' for expanded composite categories, and '' for non-composite categories
	if {$n_children > 0} {
		set url_vars [list force_reload]
		if {[info exists root_category_id]} {
			lappend url_vars [list category_id $root_category_id]
		}

		# make url for expanding/hiding subsidiary categories
		if {[info exists visible_expanded_set($category_id)]} {
			lappend url_vars [list hide $category_id]
			set expand_txt "-"
		} else {
			lappend url_vars [list show $category_id]
			set expand_txt "+"
		}

		set expand_url "${this_page}?[export_vars $url_vars]"
	} else {
		set expand_txt {&nbsp;}
	}
	
	if {[string equal [string tolower [db_type]]  "oracle"]} {
		# setup a sort-key:
		#	1. Pop off the top until 'level - 1' items are in the stack.
		#	2. Push the name of the current category onto the stack.
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
		lappend	stack $name
		append	sk_tmp "//" $name
		set sort_key $sk_tmp
	} elseif {[string equal [string tolower [db_type]]  "postgresql"]} {
		set sort_key tree_sortkey
	} else {
		ns_log Error "We have neither an oracle nor a postgresql database. I don't know what to do."
		set sort_key 1
	} 

	# root_w_child_exists_p, unique_category_types
}

# sort results by the sort-key
set tbl [template::util::multirow_to_list category_tree_view]
if {[llength $tbl] > 1} {
	set row [lindex $tbl 0]
	set sort_index [expr 1 + [lsearch -exact $row "sort_key"]]
	template::util::list_to_multirow category_tree_view [lsort -index $sort_index $tbl]
}

incr maxdepth

ad_set_cookie -replace 't' -path [ad_conn url] "expanded_categories" [join $expanded ":"]
ad_set_cookie -replace 't' -path [ad_conn url] "visible_expanded_categories" [join $visible_expanded ":"]
