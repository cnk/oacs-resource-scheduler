ad_page_contract {
    Erases a portrait

    @cvs-id $Id: erase.tcl,v 1.6 2007-11-27 20:18:43 emmar Exp $
} {
    {return_url "" }
    {user_id ""}
} -properties {
    context:onevalue
    export_vars:onevalue
    admin_p:onevalue
}

set current_user_id [ad_conn user_id]

if {$user_id eq ""} {
    set user_id $current_user_id
    set admin_p 0
} else {
    set admin_p 1
}

ad_require_permission $user_id "write"

if {$admin_p} {
    set context [list [list "./?[export_vars user_id]" [_ acs-subsite.User_Portrait]] [_ acs-subsite.Erase]]
} else {
    set context [list [list "./" [_ acs-subsite.Your_Portrait]] [_ acs-subsite.Erase]]
}

if { $return_url eq "" } {
    set return_url [ad_pvt_home]
}

ad_form -name "portrait_erase" -export {user_id return_url} -form {} -on_submit {

    set item_id [db_string get_item_id {} -default ""]

    if {$item_id eq ""} {
        ad_returnredirect $return_url
        ad_script_abort
    }

    set resized_item_id [image::get_resized_item_id -item_id $item_id]

    # Delete the resized version
    if {$resized_item_id ne ""} {
        content::item::delete -item_id $resized_item_id
    }

    # Delete all previous images
    db_foreach get_images {} {
        package_exec_plsql -var_list [list [list delete__object_id $object_id]] acs_object delete
    }

    db_foreach old_item_id {} {
        content::item::delete -item_id $object_id
    }

    # Delete the relationship
    db_dml delete_rel {}

    # Delete the item
    content::item::delete -item_id $item_id

    # Flush the portrait cache
    util_memoize_flush [list acs_user::get_portrait_id_not_cached -user_id $user_id]

    ad_returnredirect $return_url
}

ad_return_template
