ad_page_contract {

    Viewable resources

} {
    resource_id:naturalnum,notnull
}

set return_url resv-resource?[export_url_vars resource_id]
set add_image_url "image-add?[export_url_vars resource_id return_url]"

crs::reservable_resource::get -resource_id $resource_id 
set context [list [list index Resources] [list resv-resource-list "Resource List"] "One resource"]


# -------------------------------------------------------
# -- Create the default policy if it does exit
# -------------------------------------------------------
set package_id [ad_conn package_id]
set default_policy_exist_p [crs::resv_resrc::policy::get -by name -resource_id $resource_id -policy_name default]
if !$default_policy_exist_p {
    crs::resv_resrc::policy::create_default -package_id $package_id -resource_id $resource_id
    crs::resv_resrc::policy::get -by name -resource_id $resource_id -policy_name default
}

set policy_id $policy_info(policy_id)
set policy_edit_url "policy-ae?[export_url_vars policy_id resource_id resource_type=reservable_resource]"



