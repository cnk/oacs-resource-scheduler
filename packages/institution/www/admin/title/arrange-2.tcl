# -*- tab-width: 4 -*-
# /packages/institution/www/admin/title/arrange-2.tcl
ad_page_contract {
	Save the result of arranging a set of titles

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-03-09 13:28 PST
	@cvs-id			$Id: arrange-2.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} -query {
	{chosen_subsite_id:naturalnum,trim}
	{personnel_id:naturalnum,trim}
	{show_p:array,naturalnum,trim,optional}
	{order:array,naturalnum,trim}
	{return_url	[get_referrer]}
	{step:naturalnum,optional}
}

set user_id [ad_conn user_id]

if {[db_0or1row object_names {}] == 0} {
	ad_return_complaint 1 "The person or subsite you requested does not exist."
	ad_script_abort
}

# CHECK PERMISSIONS ############################################################
permission::require_permission -object_id $personnel_id -privilege admin

set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]

db_transaction {
	if {[empty_string_p [db_exec_plsql create_arranged_titles_if_not_exists {}]]} {
		db_dml sitewide_default_arranged_titles_insert {}
	}

	# The 'order' array will always have all arranged titles that the user could
	#	see at the time the form was requested.
	foreach gpm_title_id [array names order] {
		set relative_order $order($gpm_title_id)

		if {[info exists show_p($gpm_title_id)] &&
			$show_p($gpm_title_id) == 1} {
			set in_context_p "t"
		} else {
			set in_context_p "f"
		}

		# //TODO// aggregate this into a single query somehow?
		db_exec_plsql update_or_insert_relative_order_and_in_context_p {}
	}
}

if {![exists_and_not_null return_url]} {
	set return_url $party_detail_url
}
template::forward $return_url