ad_page_contract {

    @cvs-id $Id: unsubscribe.tcl,v 1.5 2003-09-25 16:31:24 lars Exp $
}

set user_id [auth::get_user_id -account_status closed]

set system_name [ad_system_name]

set page_title "Confirm Closing Your Account"
set context [list [list [ad_pvt_home] [ad_pvt_home_name]] $page_title]

set pvt_home [ad_pvt_home]
set pvt_home_name [ad_pvt_home_name]
