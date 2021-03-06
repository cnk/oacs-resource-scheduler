ad_library {

    CTRL Address Wrapper Category Procs
    (copied over from OCT)

    @cvs-id $Id$
    @creation-date 2005-12-14
}

namespace eval ctrl::address::category {}

ad_proc -public ctrl::address::category::create_root {
} {
    Creates the Root Node of the category tree
} {
    return [ctrl::category::new -parent_category_id "" \
		-name "CTRL Address" \
		-plural "CTRL Address" \
		-description "CTRL Address Categories" \
		-enabled_p t \
		-profiling_weight 1 \
		-context_id [ad_conn package_id]]
}

ad_proc -public ctrl::address::category::create_for_package { 
    {-package_id:required}
} {
    Creates a category tree for package
    @param package_id the package id
} {
    set parent_category_id [ctrl::category::find -path [list "CTRL Address"]]
    return [ctrl::category::new -parent_category_id "$parent_category_id" \
		-name package_$package_id \
		-plural package_$package_id \
		-description package_$package_id \
		-enabled_p t \
		-profiling_weight 1 \
		-context_id $package_id]
    return [ctrl::address::category::new -name package_$package_id -package_id $package_id -context_id $package_id]
}

ad_proc -public ctrl::address::category::root_info { 
    {-info id}
    {-package_id ""}
} {
    Returns the root category id or path depending on whether info is 'id' or 'path'
    @param info id or path
    @param package_id the package id
} {
    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    set path "CTRL Address//package_$package_id"
    if {[string equal $info path]} {
	return $path
    }
    return [ctrl::category::find -path [list "CTRL Address" "package_$package_id"]]
}

ad_proc -public ctrl::address::category::new {
    {-parent_category_id	""}
    {-name:required}
    {-plural				""}
    {-description			""}
    {-enabled_p				"t"}
    {-profiling_weight		1}
    {-package_id            ""}
    {-context_id			""}
} {
    Adds a new category to the database
} {
    if {[empty_string_p $plural]} {
	set plural $name
    }

    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    if {[empty_string_p $parent_category_id]} {
	set parent_category_id [ctrl::address::category::root_info -info id -package_id $package_id]
    }

    if {[empty_string_p $context_id]} {
	if {![empty_string_p $parent_category_id]} {
	    set context_id $parent_category_id
	} else {
	    set context_id [ad_conn package_id]
	}
    }

    return [ctrl::category::new -parent_category_id $parent_category_id \
		-name $name \
		-plural $plural \
		-description $description \
		-enabled_p $enabled_p \
		-profiling_weight $profiling_weight \
		-context_id $context_id]
}

ad_proc -public ctrl::address::category::option_list {
    {-path:required}
    {-package_id ""}
    {-top_label}
    {-top_value}
} {
    Return an optionlist of all categories underneath the path given

    <p><code><pre>Example:
    //Certification Type//Education//Medical Degree//MD
    </pre></code>
    </p>

    @return optionlist of all subcategories (recursive)
} {
    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    set root_path [ctrl::address::category::root_info -info path -package_id $package_id]
    if [empty_string_p $path] {
	set path ""
    } else {
	set path "//$path"
    }
    if {[info exists top_label] && [info exists top_value]} {
	return [ctrl::category::option_list -path "${root_path}${path}" -top_label $top_label -top_value $top_value -disable_spacing 1]
    } else {
	return [ctrl::category::option_list -path "${root_path}${path}" ]
    }
}

ad_proc -public ctrl::address::category::find {
    {-path:required}
    {-package_id ""}
} {
    Returns the id of the category path given.
    If path doesn't exist returns 0
} {
    if {[empty_string_p $package_id]} {
	set package_id [ad_conn package_id]
    }

    set root_path [ctrl::address::category::root_info -info path -package_id $package_id]
    set path [split "$root_path//$path" "//"]

    return [ctrl::category::find -path $path]
}

