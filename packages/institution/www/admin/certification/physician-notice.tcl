# -*- tab-width: 4 -*-
# /web/ucla/packages/institution/www/admin/certification/physician-notice.tcl
ad_page_contract {
	(Documentation not provided)

	@author			Andrew Helsley (helsleya@cs.ucr.edu)
	@creation-date	2004-12-12 23:12 PST
} -query {
	{physician_id}
	{return_url [get_referrer]}
}

if {$physician_id == [ad_conn user_id]} {
	set user_is_this_physician_p 1
} else {
	set user_is_this_physician_p 0
}