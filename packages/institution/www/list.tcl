# -*- tab-width: 4 -*-
#
# @author			helsleya@cs.ucr.edu (AH)
# @creation-date	2004-06-16
# @cvs-id			$Id: list.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
#
# TEMPLATE INPUTS: roots [root_group_id] [base_url] [type]

set subsite_url	[site_node_closest_ancestor_package_url]
set subsite_id	[ad_conn subsite_id]

if {![info exists type]} {
	set typefilter "1 = 1"
} else {
	set typefilter "c.name = :type"
}

if {![info exists name]} {
	set namefilter "1 = 1"
} else {
	set namefilter "g.short_name = :name"
}

# if no group_list was passed into this page
if {![info exists group_list]} {
	set group_list "
		select	short_name as name,
				group_id,
				parent_group_id
		  from	inst_groups	g,
				categories	c
		 where	g.group_type_id	= c.category_id
		   and	$namefilter
		   and	$typefilter
		   and	[subsite::parties_sql -only -trunk -groups -party_id {g.group_id}]
		 order	by name
	"
}

# if the base_url is missing a trailing '/', put it in
if {![info exists base_url]} {
	set base_url ""
} else {
	if {[string index $base_url end] != "/"} {
		append base_url "/"
	}
}

set package_id	[ad_conn package_id]
set user_id		[ad_conn user_id]

db_multirow -extend {detail_url} group_list_view grl "$group_list" {
	# url for showing details about a particular group
	set detail_url	"${base_url}groups-detail?[export_vars group_id]"
}

