ad_page_contract {
    Interface for specifying a list of users to sign up as a batch
    @cvs-id $Id: user-batch-add-2.tcl,v 1.5 2007-01-10 21:22:00 gustafn Exp $
} -query {
    userlist
    from
    subject
    message:allhtml
} -properties {
    title:onevalue
    success_text:onevalue
    exception_text:onevalue
}

# parse the notify_ids arguments 
# ...

set exception_text ""
set success_text ""
set title "Adding new users in bulk"

# parse the userlist input a row at a time
# most errors stop the processing of the line but keep going on the
# bigger block
while {[regexp {(.[^\n]+)} $userlist match_fodder row] } {
    # remove each row as it's handled
    set remove_count [string length $row]
    set userlist [string range $userlist [expr {$remove_count + 1}] end]
    set row [split $row ,]
    set email [string trim [lindex $row 0]]
    set first_names [string trim [lindex $row 1]]
    set last_name [string trim [lindex $row 2]]
    
    if {![info exists email] || ![util_email_valid_p $email]} {
	append exception_text "<li>Couldn't find a valid email address in ($row).</li>\n"
	continue
    } else {
	set email_count [db_string unused "select count(email)
from parties where email = lower(:email)"]
	
	if {$email_count > 0} {
	    append exception_text "<li> $email was already in the database.</li>\n"
	    continue
	}
    }
    
    if {![info exists first_names] || $first_names eq ""} {
	append exception_text "<li> No first name in ($row)</li>\n"
	continue
    }
    
    if {![info exists last_name] || $last_name eq ""} {
	append exception_text "<li> No last name in ($row)</li>\n"
	continue
    }
    
    # We've checked everything.
    
    set password [ad_generate_random_string]
    
    array set auth_status_array [auth::create_user -email $email -first_names $first_names -last_name $last_name -password $password]

    set user_id $auth_status_array(user_id)
    
    append success_text "Created user $user_id for ($row)<br\>"
    
    # if anything goes wrong here, stop the whole process
    if { !$user_id } {
	ad_return_error "Insert Failed" "We were unable to create a user record for ($row)."
	ad_script_abort
    }
    
    # send email

    set key_list [list first_names last_name email password]
    set value_list [list $first_names $last_name $email $password]
    
    set sub_message $message
    foreach key $key_list value $value_list {
	regsub -all "<$key>" $sub_message $value sub_message
    }
    
    if {[catch {ns_sendmail "$email" "$from" "$subject" "$sub_message"} errmsg]} {
	ad_return_error "Mail Failed" "The system was unable to send email.  Please notify the user personally.  This problem is probably caused by a misconfiguration of your email system.  Here is the error: 
<blockquote><pre>
[ad_quotehtml $errmsg]
</pre></blockquote>"
        return
    }

}

ad_return_template


