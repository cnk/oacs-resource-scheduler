ad_page_contract {
    Page for deleting a selected event

    @author whao@ctrl.ucla.edu
    @creation-date 04/14/2005
    @cvs-id $Id
} {
    {event_id:optional}
}

set return_url "index?[export_url_vars event_id role_id]"
set parent_category_id [db_string get_role_categories {}]

ad_form -name event_rsvp1 -form {
    {category_id:key}
    {parent_category_id:text(hidden) {value $parent_category_id}}
    {name:text(text) {label "role Name:"} {html {maxlength 300}}}
    {plural:text(text) {label "Plural:"} {html {maxlength 300}}}
    {description:text(text),optional {label "Description:"} {html {maxlength 4000}}}
    {enabled_p:text(select),optional {label "Enable:"} {options {{"Yes" t} {"No" f}}}}
    {profiling_weight:text(text),optional {label "Profiling_weight:"}}
    {event_id:text(hidden) {value $event_id}}
} -new_data {
    set error_p 0
    db_transaction {
	db_dml insert_role_type {}
    } on_error {
	set error_p 1
	db_abort_transaction
    }
    if {$error_p} {
	ad_return_error "Error" "Error:<p>$errmsg"
	ad_script_abort
    }
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -select_query_name get_role_categories


set page_title "RSVP - New Role Type"
set context_bar [ad_context_bar $page_title]

