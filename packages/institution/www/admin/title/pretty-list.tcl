# -*- tab-width: 4 -*-
# /web/ucla/packages/institution/www/admin/title/pretty-list.tcl
# ad_page_contract {
# 	A list of a personnel's titles ordered in one of four ways:
# 		1 - As the user specified in a list specific to the current subsite
# 		2 - As the user specified in a default list
# 		3 - The default order specified by the subsite.
# 		4 - The sitewide default order.
#
# 	@author			Andrew Helsley (helsleya@cs.ucr.edu)
# 	@creation-date	2005-03-15 10:56 PST
# 	@cvs-id			$Id: pretty-list.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
# } -query {
# 	personnel_id:naturalnum,trim,notnull
#	subsite_id:naturalnum,optional
#	return_url
# }

if {![exists_and_not_null personnel_id]} {
	ad_return_error "Invalid Request" {
		This template may only be used as a component of another page.  If you
		arrived here as a result of clicking on a URL, please notify the
		webmaster.
	}
	ad_script_abort
}

set user_id			[ad_conn user_id]
if {![exists_and_not_null subsite_id]} {
	set subsite_id	[ad_conn subsite_id]
}

set other_aff_lbl	[ctrl::coalesce -default "Affiliations" other_aff_lbl]
set filter			[ctrl::coalesce -default "1=1" filter]

db_1row relevant_categories {
	select	category.lookup('//Group Type//Hospital')	as hospital_category_id
	  from	dual
}

set n_hidden 0
db_multirow -extend {group_url} titles spol_titles {} {
	if {$show_p != "t"} {
		incr n_hidden
		continue
	}
	set group_url "groups-detail?[export_vars {group_id return_url}]"
}

if {${titles:rowcount} <= 0 && $n_hidden <= 0} {
	set subsite_id	[ctrl_procs::subsite::get_main_subsite_id]
	db_multirow -extend {group_url} titles spol_titles {} {
		if {$show_p != "t"} {
			incr n_hidden
			continue
		}
		set group_url "groups-detail?[export_vars {group_id return_url}]"
	}
}

if {${titles:rowcount} <= 0 && $n_hidden <= 0} {
	db_multirow -extend {group_url} titles sitewide_default_titles {} {
		if {$show_p != "t"} {
			incr n_hidden
			continue
		}
		set group_url "groups-detail?[export_vars {group_id return_url}]"
	}
}
