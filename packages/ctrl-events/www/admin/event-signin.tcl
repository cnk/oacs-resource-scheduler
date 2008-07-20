ad_page_contract {
    @author kellie@ctrl.ucla.edu
    @creation-date 08/26/05
    @cvs-id $Id
} {
    event_id:naturalnum,notnull
    {swiped_input:optional}
}

set title "Card registration sign-in"
set context [list "Card registration sign-in"]

#set selection [db_0or1row event_info {}]

ad_form -name "event_signin" -method post -html {enctype multipart/form-data} -form {

    event_id:key
    {event_title:text(inform) {label "Event Title: "}}
    {category_name:text(inform) {label "Category: "}}
    {start_date:text(inform) {label "Start Date: "}}
    {end_date:text(inform) {label "End Date: "}}
    {event_description:text(inform) {label "Description: "}}
    {swiped_input:text(text) optional}
    {submit:text(submit)}

} -on_submit {

    if {$swiped_input == ";E?" || [empty_string_p $swiped_input]} {
	ad_return_complaint 1 "There was an error in the reader, please go back to the previous page and try again"
	ad_script_abort
    }

    if {[string index $swiped_input 0] == ";" && [string index $swiped_input 16] == "?"} {
	set signin_id "[string range $swiped_input 6 14]"  
    } else {
	set signin_id $swiped_input
    }

    set fail_p [catch {
	
	if {[number_p $signin_id]} {

	    set attendees [db_list_of_lists find_attendee {}]

	    if {[llength $attendees] == 1} {
		set attendee [join $attendees " "]

		set signin_id [lindex $attendee 0]
		set first_name [lindex $attendees 1]
		set last_name [lindex $attendees 2]

		db_dml attendee_signin_update {}
    
		rp_form_put first_name $first_name
		rp_form_put last_name $last_name
		rp_form_put event_name $event_title
	    
		rp_internal_redirect event-signin-welcome
		ad_script_abort

	    } else {
		#ad_return_error "Error" "This employee number does not exist in the db"
		ad_return_complaint 1 "This id does not exist in the db"
		ad_script_abort
	    }

	} else {
	    #ad_return_complaint 1 "There is a problem in employee id, id should consist of 9 digits"
	    ad_script_abort
	}

    } errmsg]

    if {$fail_p != 0} {
	ad_return_error "Fail" $errmsg
	return
    }
} -select_query_name event_info
