ad_page_contract {
    Prompt the user for email and password.
    @cvs-id $Id: index.tcl,v 1.13 2007-11-30 18:16:43 daveb Exp $
} {
    {authority_id ""}
    {username ""}
    {email ""}
    {return_url ""}
}

set subsite_id [ad_conn subsite_id]
set login_template [parameter::get -parameter "LoginTemplate" -package_id $subsite_id]

if {$login_template eq ""} {
    set login_template "/packages/acs-subsite/lib/login"
}

