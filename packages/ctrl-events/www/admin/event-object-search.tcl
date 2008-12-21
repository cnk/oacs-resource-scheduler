# /packages/ctrl-events/www/admin/event-object-search.tcl

ad_page_contract {
    Display all event objects

    @author kellie@ctrl.ucla.edu
    @creation-date 11/14/2006
    @cvs-id $Id
} {
} 

set package_id [ad_conn package_id]

regsub -all {\{} $search_object_type "" search_object_type
regsub -all {\}} $search_object_type "" search_object_type
    
# Event Objects
set object_type_options "[ctrl_event::category::option_list -path "CTRL Events Objects" -package_id $package_id]"
    
ad_form -name "event_object_search" -method post -html {enctype multipart/form-date} -form {
    {search_name:text(text),optional {label "Name: "} {value $search_name}}
    {search_description:text(text),optional {label "Description: "} {value $search_description}}
    {search_object_type:integer(checkbox),optional,multiple {label "Object Type: "} {options $object_type_options} {values $search_object_type}}    
    {url:text(hidden) {value $url}}
    {event_id:text(hidden) {label "Event ID:"} {value $event_id}}
    {search:text(submit) {label "Search"}}
} -on_submit {
    ad_returnredirect "[ad_conn package_url]admin/$url?[export_url_vars event_id search_name search_description search_object_type]"
}
