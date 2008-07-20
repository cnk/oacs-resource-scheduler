# /packages/ctrl-calendar/tcl/ctrl-cal-category-procs.tcl

ad_library {
    
    Calendar Event Procedures
    Uses tables from CTRL CALENDAR
    
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 12/19/05
    @cvs_id $id$
}

namespace eval ctrl::cal::category {}

ad_proc -public ctrl::cal::category::create_root {
} {
    Creates the Root Node of the category tree
} {
    return [ctrl::category::new -parent_category_id "" \
		-name "CTRL Calendar" \
		-plural "CTRL Calendars" \
		-description "CTRL Calendars" \
		-enabled_p t \
		-profiling_weight 1 \
		-context_id [ad_conn package_id]]
}

ad_proc -public ctrl::cal::category::root_info { 
    {-info id}
    {-package_id ""}
} {
    Returns the root category id or path depending on whether info is 'id' or 'path'
    @param info id or path
    @param package_id the package id
} {
    if {[empty_string_p $package_id]} {
	set package_id [site_node_apm_integration::get_child_package_id -package_id [ad_conn subsite_id] -package_key ctrl_calendar]
    }

    set path "CTRL Calendar//package_$package_id"
    if {[string equal $info path]} {
	return $path
    }
    return [ctrl::category::find -path [list "CTRL Calendar" "package_$package_id"]]
}

ad_proc -public ctrl::cal::category::create_for_package {
    {-package_id:required}
} {
    Creates a category tree for package
    @param package_id the package id
} {
    set parent_category_id [ctrl::category::find -path [list "CTRL Calendar"]]
    return [ctrl::category::new -parent_category_id "$parent_category_id" \
		-name package_$package_id \
		-plural package_$package_id \
		-description package_$package_id \
		-enabled_p t \
		-profiling_weight 1 \
		-context_id $package_id]
    return [ctrl::cal::category::new -name package_$package_id -package_id $package_id -context_id $package_id]
}


ad_proc -public ctrl::cal::category::new {
    {-parent_category_id	""}
    {-name:required}
    {-plural			""}
    {-description		""}
    {-enabled_p			"t"}
    {-profiling_weight		1}
    {-package_id                ""}
    {-context_id		""}
} {
    Adds a new category to the database
} {
    if {[empty_string_p $plural]} {
	set plural $name
    }

    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    if {[empty_string_p $context_id]} {
	set context_id [ad_conn package_id]
    }

    if {[empty_string_p $parent_category_id]} {
	set parent_category_id [ctrl::cal::category::root_info -info id -package_id $package_id]
    }

    return [ctrl::category::new -parent_category_id $parent_category_id \
		-name $name \
		-plural $plural \
		-description $description \
		-enabled_p $enabled_p \
		-profiling_weight $profiling_weight \
		-context_id $context_id]
}
