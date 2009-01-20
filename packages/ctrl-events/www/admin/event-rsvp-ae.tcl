# /packages/ctrl-events/admin/event-esvp-ae

ad_page_contract {

    Allow admins to setup RSVP for events 

    @author: Weider Hao
    @creation-date: 01/18/2006
    @cvs-id $Id
} {
    rsvp_event_id:naturalnum
}


set package_id [ad_conn package_id]
set package_url [ad_conn package_url]
set user_id [ad_conn user_id]
set page_title "Set Up RSVP"

ad_form -name event_rsvp_ae -form {
    {rsvp_event_id:key}
    {title:text(inform) {label {Title:}}}
    {category:text(inform) {label {Category:}}}
    {start_date:text(inform) {label {Start Date:}} }
    {end_date:text(inform) {label {End Date:}}}
    {location:text(inform) {label {Location:}}}
    {approval_required_p:text(radio),optional {options {{Yes t} {No f}}} {label {Approval Required? :}}}
    {registration_start:date,to_sql(sql_date) {label {From Date :}} {format "MONTH DD YYYY"}}
    {registration_end:date,to_sql(sql_date) {label {To Date :}} {format "MONTH DD YYYY"}}
    {capacity_consideration_p:text(radio) {label ""} {options {{Yes t} {No f}}} {optional}}
    {capacity:integer(text) {label {Capacity :}} {html {size 4} {maxlength 7}}}
    {Submit:text(submit)}
    {Delete:text(submit)}
} -edit_request {
    set event_info [db_0or1row get_event_info {}]
    if {!$event_info} {
	ad_return_error "Error" "The event you have selected no longer exists in our database. Please go back
        and try again."
	ad_script_abort
    }
    if {$rsvp_exists_p} {
	set page_title "Edit RSVP Setup"
    }
    set context_bar [ad_context_bar $page_title]
} -on_submit {

    set failed_p 0
    db_transaction {
     set rsvp_exists_p [db_string rsvp_exists_p {} -default 0]
     if {$Submit == "Submit"} {
	 db_dml event_capacity_update {}
	 if {!$rsvp_exists_p} {
	    db_dml rsvp_insert {}
	 } else {
	    db_dml rsvp_update {}
	 }
      } elseif {$Delete == "Delete" && $rsvp_exists_p} {
	    set capacity 0
	    db_dml event_capacity_update {}
	    db_dml rsvp_delete  {}
      }
    } on_error {
	set failed_p 1
	db_abort_transaction
    }

    if $failed_p {
	ad_return_error "Unable to add RSVP for Event" "System was unable to add event RSVP due to <p> <pre> $errmsg </pre>"
	ad_script_abort
    }

} -after_submit {
    ad_returnredirect "${package_url}admin/"
    ad_script_abort
} 
db_multirow -extend {} event_rsvp_attendees event_rsvp_attendees {} {
}

