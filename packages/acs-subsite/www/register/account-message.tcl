ad_page_contract {
    Inform the user of an account status message.
    
    @cvs-id $Id: account-message.tcl,v 1.1 2003-09-10 16:45:49 lars Exp $
} {
    {message:allhtml ""}
    {return_url ""}
}

set page_title "Logged in"
set context [list $page_title]

set system_name [ad_system_name]

