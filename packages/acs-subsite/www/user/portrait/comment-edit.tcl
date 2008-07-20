ad_page_contract {
    screen to edit the comment associated with a user's portrait

    @author mbryzek@arsdigita.com
    @creation-date 22 Jun 2000
    @cvs-id $Id: comment-edit.tcl,v 1.7 2007-11-27 19:29:27 emmar Exp $
} {
    {return_url "" }
    {user_id ""}
} -properties {
    context:onevalue
    export_vars:onevalue
    description:onevalue
    first_names:onevalue
    last_name:onevalue
}

set current_user_id [ad_conn user_id]

if {$user_id eq ""} {
    set user_id $current_user_id
}

ad_require_permission $user_id "write"

if {![db_0or1row user_info {}]} {
    ad_return_error "Account Unavailable" "We can't find you (user #$user_id) in the users table.  Probably your account was deleted for some reason."
    return
}

if {![db_0or1row portrait_info {}]} {
    ad_return_complaint 1 "<li>You shouldn't have gotten here; we don't have a portrait on file for you."
    return
}

set context [list [list "./" [_ acs-subsite.Your_Portrait]] [_ acs-subsite.edit_comment]]

if { $return_url eq "" } {
    set return_url [ad_pvt_home]
}

ad_form -name comment_edit -export {user_id return_url} -form {
    {description:text(textarea),optional
        {label "#acs-subsite.Story_behind_photo#"}
        {value $description}
        {html {rows "6" cols "50"}}
    }
} -on_submit {

    if { [string length $description] > 4000 } {
        ad_return_complaint 1 "Your portrait comment can only be 4000 characters long."
        return
    }

    db_dml comment_update {}

    ad_returnredirect $return_url
}

ad_return_template
