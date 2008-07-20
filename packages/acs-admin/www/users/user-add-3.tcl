ad_page_contract {
    Sends email confirmation to user after they've been created

    @cvs-id $Id: user-add-3.tcl,v 1.5 2005-03-01 00:01:21 jeffd Exp $
} -query {
    email
    message
    first_names
    last_name
    user_id
    {referer "/acs-admin/users"}
} -properties {
    context:onevalue
    first_names:onevalue
    last_name:onevalue
    export_vars:onevalue
}
    
set admin_user_id [ad_conn user_id]

set context [list [list "./" "Users"] "New user notified"]
set export_vars [export_url_vars user_id]

set admin_email [db_string unused "select email from 
parties where party_id = :admin_user_id"]

if [catch {ns_sendmail "$email" "$admin_email" "You have been added as a user to [ad_system_name] at [ad_url]" "$message"} errmsg] {
    ad_return_error "Mail Failed" "The system was unable to send email.  Please notify the user personally.  This problem is probably caused by a misconfiguration of your email system.  Here is the error:
<blockquote><pre>
[ad_quotehtml $errmsg]
</pre></blockquote>"
    return
}
