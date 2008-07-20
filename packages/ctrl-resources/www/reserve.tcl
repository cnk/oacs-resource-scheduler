ad_page_contract {
    Form to edit or update a reservation
    @param room_id
    @param start_date
    @param end_date - mutually exclusive
} {
    request_id:naturalnum
    resv_resource_id:naturalnum,notnull
    start_date:date
    end_date:date
    requested_by
    {return_url reservation}
}

set user_id [ad_conn user_id]

set package_id [ad_conn package_id]
if [info exists request_id] {
    permission::require_permission -object_id $request_id -permission write
} else {
    permission::require_permission -object_id $package_id -permission create
}

if ![info exists $requested_by] {
    set requested_by $user_id
}

set start_date_secs [clock scan "$start_date"]
set end_date_secs [clock scan "$end_date"]

if {$end_date_secs <= $start_date_secs} {
    ad_return_error "The end date must be after the start date"
    ad_script_abort
}

crs::room::get -room_id $room_id -column_array room_info

# Create a new request if not already created
if ![info exists $request_id] {
    set name "$room_info(name) for $start_date to $end_date"
    set request_id [crs::request::new -name $name \
			-description ""\
			-status pending \
			-package_id $package_id \
			-reserved_by $user_id \
			-requested_by $requested_by]
}

crs::request::add_resv -request_id $request_id \
	-status "pending" \
	-reserved_by $user_id \
	-resv_resource_id $room_id \
	-start_date $start_date \
	-end_date $end_date \

ad_returnredirect $return_url
ad_script_abort























