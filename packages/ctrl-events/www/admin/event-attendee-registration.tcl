ad_page_contract {
    @author kellie@ctrl.ucla.edu
    @creation-date 08/16/05
    @cvs-id $Id
} {
    {entry:optional}
} 

ad_form -name "attendee_registration" -method {-post} -form {

    {entry:text(text) {label "Entry"} optional}

} -on_submit {
    ad_return_complaint 1 "test input: $entry"
    ad_script_abort
    #ad_returnredirect "/events/event-attendee-registration/"
}
