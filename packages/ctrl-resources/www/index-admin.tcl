ad_page_contract {
    List of options for resources
}

set package_id [ad_conn package_id]
set admin_p [permission::require_permission -object_id $package_id  -privilege admin]


