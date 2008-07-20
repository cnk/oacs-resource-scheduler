ad_page_contract {
} {
	{personnel_id:naturalnum}
}

# 'Strict' Permissions check (must be site-wide admin)
ad_maybe_redirect_for_registration
permission::require_permission -object_id [acs_magic_object "security_context_root"] -privilege admin

db_dml order_subsets_by_date {
	update	inst_psnl_publ_ordered_subsets
	   set	relative_order = null
	 where	personnel_id = :personnel_id
}

ns_returnnotice 200 ok ok
