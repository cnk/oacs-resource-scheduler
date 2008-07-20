# -*- tab-width: 4 -*-
# /packages/institution/www/admin/publication/arrangement-reset.tcl
ad_page_contract {
	User interface for deleting arrangements of titles for a subsite.

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2005-07-25 15:16 PDT
	@cvs-id			$Id: arrangement-reset.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{personnel_id:naturalnum}
	{chosen_subsite_id:naturalnum}
	{step:naturalnum,optional}
	{return_url	[get_referrer]}
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
	return_url
} -form {
	{confirm:text(submit) {label "Reset Arrangement"}}
} -on_submit {
	db_transaction {
		db_dml delete_arrangements_for_chosen_subsite {}
	}
} -after_submit {
	template::forward $return_url
}