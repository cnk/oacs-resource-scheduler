# -*- tab-width: 4 -*-
# /packages/institution/www/admin/title/arangement-reset.tcl
ad_page_contract {
	User interface for deleting arrangements of titles for a subsite.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-07-25 10:25 PDT
	@cvs-id			$Id: arrangement-reset.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
	{personnel_id:naturalnum}
	{chosen_subsite_id:naturalnum}
	{step:naturalnum,optional "3"}
	{return_url	""}
}

set context [list Reset]

# CHECK PERMISSIONS ############################################################
permission::require_permission -object_id $personnel_id -privilege delete

set party_detail_url	[subsite::party_admin_detail_url -party_id $personnel_id]
set main_subsite_id		[ctrl_procs::subsite::get_main_subsite_id]

if {[db_0or1row details {}] < 1} {
	ad_return_complaint 1 "The arrangement you are trying to reset does not exist."
	return
}

ad_form -name reset-arrangement -export {
	personnel_id
	chosen_subsite_id
} -form {
	{confirm:text(submit) {label "Reset Arrangement"}}
} -on_submit {
	db_transaction {
		db_dml delete_arrangements_for_chosen_subsite {}
	}
} -after_submit {
	if {[empty_string_p $return_url]} {
		set return_url "arrange-0?[export_url_vars step personnel_id]"
	}
	template::forward $return_url
}
