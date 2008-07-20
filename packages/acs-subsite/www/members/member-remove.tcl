ad_page_contract {
    Remove member(s).
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-06-02
    @cvs-id $Id: member-remove.tcl,v 1.3 2004-01-26 15:39:46 jeffd Exp $
} {
    user_id:integer,multiple
}

set group_id [application_group::group_id_from_package_id]

permission::require_permission -object_id $group_id -privilege "admin"

foreach id $user_id {
    group::remove_member \
        -group_id $group_id \
        -user_id $user_id
}

ad_returnredirect .
