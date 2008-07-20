ad_page_contract {
    Page for adding/editing a selected event's attendee

    @author kellie@ctrl.ucla.edu, modified by whao@ctrl.ucla.edu
    @creation-date 05/18/2005, modified-date:03/06/2006 
    @cvs-id $Id
} {
    {event_attendee_id:optional}
    {event_id:optional}
    {response_status:optional}
    {approval_status:optional}
    {user_info:optional}
    {user_info:optional}
    {filter_by:optional "1=1"}
    {attendee_role:optional}
    {delete_role:optional 0}
    {role_id:optional 0}
}


set user_id [ad_verify_and_get_user_id]
set package_id [ad_conn package_id]
ad_require_permission $package_id read
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

set return_url "index"
set return_url1 "event-rsvp-attendee-ae?[export_url_vars event_attendee_id event_id role_id user_info filter_by]"
set return_url2 "event-rsvp-attendee-list?[export_url_vars event_id filter_by]"
set selection [db_0or1row get_event_data {}]

if {$selection} {
    if {[db_string get_repeat_template_p {}] == "t"} {
	ad_return_complaint 1 "You have passed an event_id for a template event.  <br>This event can not be deleted from this page."
	return
    }
} else {
    ad_return_complaint 1 "You have passed an event_id that no longer exists in the database"
    return
}

set repeat_template_id [db_string get_repeat_template_id {}]

if {[exists_and_not_null event_id]} {
    set event_image_display [ctrl_event::event_image_display -event_id $event_id]
} else {
    set event_image_display "<i>no image</i>"
}

ad_form -name event_rsvp -method {"post"} -form {
    {event_id:key {value $event_id}}
    {title:text(inform) {value $title} {label "Event Title:"} optional}
    {event_object_id:text(inform) {label "Event Object:"} optional}
    {category_id:text(inform) {label "Category:"} optional}
    {event_start_date:text(inform) {label "Start Date:"} optional}
    {event_end_date:text(inform) {label "End Date: "} optional}
    {location:text(inform) {label "Location: "} optional}
    {notes:text(inform) {label "Notes: "} optional}
    {capacity:text(inform) {label "Capacity: "} optional}
    {event_image:text(inform) {label "Image: "} {value "$event_image_display"}}
} -select_query_name get_event_data

if {![exists_and_not_null event_attendee_id]} {
    set rsvp_attendee_exists_p_by_userid [db_string rsvp_attendee_exists_p_by_userid {} -default 0]
    if {$user_id > 0 && $rsvp_attendee_exists_p_by_userid} {
	set event_attendee_id [db_string get_attendee_by_userid {}]
    } 
} 

if {$user_id == 0} {
    set by_email "email = :email"
    set by_event_attendee_id "1=1"
} else {
    set by_email "1=1"
    set by_event_attendee_id "event_attendee_id = :event_attendee_id"
}

set response_options [list [list Attending attending] [list Decline decline]]
set approval_options [list [list Pending pending] [list Attending attending] [list Denied denied]]
set delete_rsvp_link "event-rsvp-attendee-delete?[export_url_vars event_attendee_id event_id user_info filter_by]"
set new_rsvp_role_link "event-rsvp-new-role?[export_url_vars event_attendee_id event_id user_info filter_by]"

ad_form -name event_rsvp1 -form {
    {event_attendee_id:key}
    {rsvp_event_id:text(hidden) {value $event_id}}
    {email:text(text) {label "E-mail:"} {html {maxlength 100}}}
    {first_name:text(text) {label "First Name:"} {html {maxlength 100}}}
    {last_name:text(text) {label "Last Name:"} {html {maxlength 100}}}
    {event_id:text(hidden) {value $event_id}}
    {Submit:text(submit)}
    {DeleteYourRSVP:text(submit)}
    {CreateRole:text(submit)}
} -on_submit {
    set failed_p 0
    db_transaction {
     set rsvp_attendee_exists_p [db_string rsvp_attendee_exists_p {} -default 0]
     if {$Submit == "Submit"} {
	 if {!$rsvp_attendee_exists_p} {
		set response_status attending
		set approval_status pending
 		db_dml rsvp_attendee_insert {}
	 } else {
		db_dml rsvp_attendee_update {}
	 }
	if {$admin_p && $attendee_role > 0} {
		db_dml insert_attendee_role {}
	}
     }
    } on_error {
	set failed_p 1
	db_abort_transaction
    }
    if $failed_p {
	ad_return_error "Unable to Add/Update RSVP for Event" "Unable to Add/Update RSVP for Event due to <p> <pre> $errmsg </pre>"
	ad_script_abort
    }
} -after_submit {
  if {$admin_p} {
    ad_returnredirect $return_url2
  } else {
    ad_returnredirect $return_url
  }
    ad_script_abort
} -select_query_name get_attendee

if {$admin_p} {
   db_multirow get_role get_role {} {
      set x [list $name $category_id]
      lappend role_options $x
   }
   set role_options [linsert $role_options 0 [list -------- 0]]
   ad_form -extend -name event_rsvp1 -form {
       {response_status:text(select) {label "Response :"} {options $response_options}}
       {approval_status:text(select) {label "Approval:"} {options $approval_options}}
       {attendee_role:text(select) {label "Assign Role:"} {options $role_options}}
	} -select_query_name get_attendee
} else {
   ad_form -extend -name event_rsvp1 -form {
       {response_status:text(hidden)}
       {approval_status:text(hidden)}
       {attendee_role:text(hidden)}
	} -select_query_name get_attendee
}
set attendee_role_exists_p 0
if {[exists_and_not_null event_attendee_id]} {
    set attendee_role_exists_p [db_string attendee_role_exists_p {} -default 0]
}
if {$attendee_role_exists_p > 0} {

  if {$delete_role == 1} {
   db_dml delete_attendee_role {}
  }
  db_0or1row get_attendee {}
  db_multirow -extend {delete_link} get_attendee_role_name get_attendee_role_name {} {
    set delete_role_link "event-rsvp-attendee-ae?[export_url_vars event_attendee_id event_id role_id delete_role=1 user_info filter_by]"
  }
}

if {[exists_and_not_null event_attendee_id]} {
  set page_title "Edit Event Rsvp Attendee"
  set context_bar [ad_context_bar $page_title]
} else {
  set page_title "New Event Rsvp Attendee"
  set context_bar [ad_context_bar $page_title]
}


