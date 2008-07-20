ad_page_contract {
    This include expects "message" to be set as html
    and if no title is present uses "Message".  Used to inform of actions
    in registration etc.

    @cvs-id $Id: message.tcl,v 1.1 2005-03-25 23:59:10 jeffd Exp $
}
if {![exists_and_not_null title]} {
    set page_title Message
}
set context [list $title]
