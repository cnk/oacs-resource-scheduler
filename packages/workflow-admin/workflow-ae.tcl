ad_page_contract {

    Actio Add/Edit

    @author        Jeff Wang (jeff@ctrl.ucla.edu)
    @creation-date 3/17/2005

    @cvs-id  $Id: workflow-ae.tcl,v 1.2 2005/05/03 20:14:09 jwang1 Exp $
} {
    {return_url [get_referrer]}
    {workflow_id:optional}
}

set title "Edit"
set context [list [list $return_url "Workflow Edit"] "Edit Metadata"]


ctrl_procs::tree::sorter::create -multirow "package_options" -sort_by sort_key

db_multirow -extend {sort_key} package_options get_packages  {} {
    set sort_key [ctrl_procs::tree::sorter::make_full_key_for -multirow "package_options" -partial_key $rawname -id  $object_id -level $level]
}

ctrl_procs::tree::sorter::sort -multirow "package_options"
set unprocessed_list [template::util::multirow_to_list  "package_options"]

# Replace leading spaces with '&nbsp;'
foreach item $unprocessed_list {
    set name	[lindex $item 7]
    set new_lines	""

    for {set i 0} {$i < [string length $name]} {incr i} {
	if {[string index $name $i] == " "} {
	    append new_lines "&nbsp;"
	} else {
	    break;
	}
    }

    set name "$new_lines $name"

    set value [lindex $item 11]
    lappend package_options [list $name $name]
}

set package_options [db_list_of_lists get_package_options {}]



set the_form {
    workflow_id:key
    {package:text(select) {label {Package:}} {options $package_options}}
    {short_name:text(text) {label {Short Name:}}}
    {pretty_name:text(text) {label {Pretty Name:}}}
    {callbacks:text(textarea),nospell,optional {label {Insert or remove callbacks. Put a new callback on a seperate line:}} {html {rows 6 cols 35}}}
}



ad_form -name "add-edit" -form $the_form -new_data {
    
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }

    
    set error_p 0
    db_transaction {
	workflow::new \
		-pretty_name $pretty_name \
		-short_name $short_name \
		-package_key $package \
		-callbacks $callback_list
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was an error creating the workflow: <br><br><br> $errmsg"
	ad_script_abort
    }


} -edit_data {
    set update_array(short_name) $short_name
    set update_array(pretty_name) $pretty_name
    set update_array(package_key) $package
    set callback_list [list]
    foreach callback_name [split $callbacks "\n"] {
	set callback_name [string trim $callback_name]
	if {![empty_string_p $callback_name]} {
	    lappend callback_list $callback_name
	}
    }


    set update_array(callbacks) $callback_list
    
    set error_p 0
    db_transaction {
	workflow::edit \
		-workflow_id $workflow_id \
		-array update_array
    } on_error {
	set error_p 1
    }

    if {$error_p} {
	ad_return_complaint 1 "There was an error updating the workflow: <br><br><br> $errmsg"
	ad_script_abort
    }

} -edit_request {
    workflow::get -workflow_id $workflow_id -array "wf_info"
    set short_name $wf_info(short_name)
    set pretty_name $wf_info(pretty_name)
    set package $wf_info(package_key)
    set callbacks $wf_info(callbacks)
    set callbacks [join $callbacks "\n"]
} -after_submit {
    ad_returnredirect $return_url
} -export {return_url}
