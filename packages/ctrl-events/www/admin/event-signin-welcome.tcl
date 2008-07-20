ad_page_contract {
    @aurthor kellie@ctrl.ucla.edu
    @creation-date 08/31/05
    @cvs-id $Id
} {
    {event_id:naturalnum,notnull}
    {first_name:optional}
    {last_name:optional}
    {event_title:optional}
}

set package_url "[ad_conn package_url]admin/event-signin?event_id=$event_id"


