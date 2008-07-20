# /packages/oli-dealers/www/zip_check.tcl
ad_page_contract {
    takes a zipcode and gives mapquest links to it
 
    @author Gilbert Wong (gwong@orchardlabs.com)
    @creation-date 2003-09-01
} {
    {ref_zipcode:optional ""}
} 


set package_id [ad_conn package_id]
set package_url [ad_conn package_url]
set package_admin_p [ad_permission_p $package_id admin]
ad_require_permission $package_id admin
set this_user_id [ad_conn user_id]

set system_name [ad_parameter -package_id [ad_acs_kernel_id] SystemName]

db_multirow zipcodes zipcode_select {
    select s.abbrev, z.zipcode, z.latitude, z.longitude
    from us_states s, us_zipcodes z
    where z.zipcode = :ref_zipcode
    and z.fips_state_code = s.fips_state_code
}

