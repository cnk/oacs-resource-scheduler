
ad_page_contract {

    Remove a notification request

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-24
    @cvs-id $Id: request-delete.tcl,v 1.3 2003-01-16 13:53:40 jeffd Exp $
} {
    request_id:integer,notnull
    return_url
}

# Security Check
notification::security::require_admin_request -request_id $request_id

# Actually Delete
notification::request::delete -request_id $request_id

# Redirect
ad_returnredirect $return_url
