ad_page_contract {
    Leave the group
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date 2003-08-07
    @cvs-id $Id: group-leave.tcl,v 1.2 2004-01-30 15:17:31 lars Exp $
} {
    {group_id:integer {[application_group::group_id_from_package_id]}}
    return_url:optional
}

set user_id [auth::require_login]

group::get -group_id $group_id -array group_info

set member_p [group::member_p -group_id $group_id -user_id $user_id]

if { $member_p } {

    set rel_id [relation::get_id \
                    -object_id_one $group_id \
                    -object_id_two $user_id]

    db_transaction {
	relation_remove $rel_id
    } on_error {
	ad_return_error "Error creating the relation" "We got the following error while trying to remove the relation: <pre>$errmsg</pre>"
	ad_script_abort
    }

}

if { ![exists_and_not_null return_url] } {
    set return_url "../"
}

ad_returnredirect -message "You have left the group \"$group_info(group_name)\"." $return_url
