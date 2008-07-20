ad_library {
    Set of methods to supplement form generation

    @author KH (khy@ucla.edu)
    @cvs-id $Id: form-builder-procs.tcl,v 1.1 2005/05/11 19:58:24 khy Exp $
    @creation-date 2005-05-10
} 


namespace eval svys::form_builder::generate {}

ad_proc -public svys::form_builder::author {
    {user_id ""}
} {
    if [empty_string_p $user_id] {
	set user_id [ad_conn user_id]
    }
    return [db_string author_info {select first_names ||' '|| last_name || ' ('||email||')' as author from cc_users where user_id = :user_id}]

}

ad_proc -public svys::form_builder::generate::proc_call {
    -proc_name
    -variable_list 
    {-spacing  ""}
    {-start_spacing_count 0}
} {
    Generate the proc call with the passed in proc name and variable name

    @param proc_name the proc name
    @param variable_list the variable list
} {
    set start_spaces ""
    for {set i 0} {$i < $start_spacing_count} {incr i} {
	append start_spaces $spacing
    }

    set proc_call "${start_spaces}$proc_name "
    set index 0
    set size [llength $variable_list]
    foreach name_pair $variable_list {
	incr index
	set name [lindex $name_pair 0]
	set other_name [lindex $name_pair 1]
	if [empty_string_p $other_name] {
	    set other_name $name 
	}
	if {$index != 1} {
	    append proc_call "${start_spaces}${spacing}"
	}
	append proc_call "-$other_name \$$name "
	if {$index != $size} {
	    append proc_call " \\"
	}
	append proc_call "\n"
    }
    return $proc_call
}


ad_proc -public svys::form_builder::generate::unwrap_array {
    -array_name
    -variable_list 
    {-spacing  ""}
    {-start_spacing_count 0}
} {
    Generate the proc call with the passed in proc name and variable name

    @param proc_name the proc name
    @param variable_list the variable list
} {
    set start_spaces ""
    for {set i 0} {$i < $start_spacing_count} {incr i} {
	append start_spaces $spacing
    }

    set unwrap_array_code ""
    set index 0
    set size [llength $variable_list]
    foreach name_pair $variable_list {
	incr index
	set name [lindex $name_pair 0]
	set other_name [lindex $name_pair 1]
	if [empty_string_p $other_name] {
	    set other_name $name 
	}
	append unwrap_array_code "\n${start_spaces}set $name \$${array_name}($other_name)"
    }
    return $unwrap_array_code
}
