# /packages/ctrl-events/tcl/ce-category-procs.tcl

ad_library {

    CTRL EVENTS Wrapper Category Procs

    @author avni@ctrl.ucla.edu (AK)

    @creation-date 2005-12-14
    @update-date 2008-09-13 (ported to postgres by avni@avni.net (AK))
    @cvs-id $Id: ce-category-procs.tcl,v 1.2 2006/08/08 00:53:11 avni Exp $

}

namespace eval ctrl_event::category {}

ad_proc -public ctrl_event::category::create_root {
} {
    Creates the Root Node of the category tree
} {
    return [ctrl::category::new -parent_category_id "" \
		-name "CTRL Events" \
		-plural "CTRL Events" \
		-description "CTRL Events" \
		-enabled_p t \
		-profiling_weight 1 \
		-context_id [ad_conn package_id]]
}

ad_proc -public ctrl_event::category::create_for_package {
    {-package_id:required}
} {
    Creates a category tree for package
    @param package_id the package id
} {
    set parent_category_id [ctrl::category::find -path [list "CTRL Events"]]
    return [ctrl::category::new -parent_category_id "$parent_category_id" \
		-name package_$package_id \
		-plural package_$package_id \
		-description package_$package_id \
		-enabled_p t \
		-profiling_weight 1 \
		-context_id $package_id]
    return [ctrl_event::category::new -name package_$package_id -package_id $package_id -context_id $package_id]
}

ad_proc -public ctrl_event::category::root_info { 
    {-info id}
    {-package_id ""}
} {
    Returns the root category id or path depending on whether info is 'id' or 'path'
    @param info id or path
    @param package_id the package id
} {
    if {[empty_string_p $package_id]} {
	set package_id [site_node_apm_integration::get_child_package_id -package_id [ad_conn subsite_id] -package_key ctrl_event]
    }

    set path "CTRL Events//package_$package_id"
    if {[string equal $info path]} {
	return $path
    }
    
    return [ctrl::category::find -path [list "CTRL Events" "package_$package_id"]]
}

ad_proc -public ctrl_event::category::new {
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
	set parent_category_id [ctrl_event::category::root_info -info id -package_id $package_id]
    }

    return [ctrl::category::new -parent_category_id $parent_category_id \
		-name $name \
		-plural $plural \
		-description $description \
		-enabled_p $enabled_p \
		-profiling_weight $profiling_weight \
		-context_id $context_id]
}

ad_proc -public ctrl_event::category::option_list {
    {-path:required}
    {-package_id ""}
    {-top_label}
    {-top_value}
    {-constraint ""}
} {
    Return an optionlist of all categories underneath the path given

    <p><code><pre>Example:
    Certification Type Education Medical Degree MD
    </pre></code>
    </p>

    @return optionlist of all subcategories (recursive)
} {

    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    set root_path [ctrl_event::category::root_info -info path -package_id $package_id]
    if [empty_string_p $path] {
	set path ""
    } else {
	set path "//$path"
    }

    if {[info exists top_label] && [info exists top_value]} {
	return [ctrl::category::option_list -path "${root_path}${path}" -top_label $top_label -top_value $top_value -disable_spacing 1]
    } else {
	return [ctrl::category::option_list -path "${root_path}${path}" -disable_spacing 1]
    }
}

ad_proc -public ctrl_event::category::find {
    {-path:required}
    {-package_id ""}
} {
    Returns the id of the category path given.
    If path doesn't exist returns 0
} {
    if {[empty_string_p $package_id]} {
	set package_id [site_node_apm_integration::get_child_package_id -package_id [ad_conn subsite_id] -package_key ctrl-events]
    }

    set root_path [string trim [ctrl_event::category::root_info -info path -package_id $package_id]]
    set path [split "$root_path//$path" "//"]
    return [ctrl::category::find -path $path]
}

ad_proc ctrl_event::category::exists_p {
    category_id
} {
    Returns 1 if passed in category id exists
    Returns 0 if it doesn't
} {
    return [db_string events_category_exists_p {} -default 0]
}


ad_proc ctrl_event::category::get_category_options {
    {-context_id ""}
    {-top_level_category "All Events"}
} {
    Returns a select optionlist of the current event categories
} {
    set parent_category_name "CTRL Events"
    return "[list "\"$top_level_category\" \"\""] [db_list_of_lists events_category_options {}]"
}

ad_proc ctrl_event::category::get_info {
    {-unique_field "category_id"}
    unique_value
    column_name_to_retrieve
} {
    Returns the value of the column_name requested
    of the category_id passed in
} {
    return [db_string events_category_info {} -default ""]
}


