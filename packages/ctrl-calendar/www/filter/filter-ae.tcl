# /packages/ctrl-calendar/www/admin/filter-ae.tcl

ad_page_contract {
    Add/Edit a calendar filter

    @author kellie@ctrl.ucla.edu (KL)
    @creation-date 07/24/2007
    @cvs-id $Id
} {
    cal_filter_id:naturalnum,optional
    cal_id:naturalnum,notnull   
}

set package_id [ad_conn package_id]
set subsite_id [ad_conn subsite_id]

if {[ad_form_new_p -key cal_filter_id]} {
    set page_title "Add Filter"
} else {
    set page_title "Edit Filter"
}

ad_form -name "filter_ae" -method post -html {enctype multipart/form-data} -form {
    cal_filter_id:key
    cal_id:text(hidden)
}

set filter_type_options [list [list "-" ""] [list "category" "category"] [list "resource" "resource"]]
set filter_list1 [db_list_of_lists get_room_list {}]
set filter_list2 [ctrl::category::option_list -path "[ctrl::cal::category::root_info -info path -package_id $package_id]//Event Categories" -disable_spacing 0]
set color_list_options {{{} {}} {{\#ccffcc} {\#ccffcc}} {{\#ccccff} {\#ccccff}} {{\#ffcccc} {\#ffcccc}} {{\#cc99ff} {\#cc99ff}} {{\#99cccc} {\#99cccc}} {{\#cc99cc} {\#cc99cc}} {{\#cccc99} {\#cccc99}} {{\#ffcc99} {\#ffcc99}} {{\#99ffcc} {\#99ffcc}} {{\#ffffcc} {\#ffffcc}}}

set filter_list {}
set color_list {}

# Add color text box
foreach l $filter_list1 {
    set name [lindex $l 1]
    ad_form -extend -name "filter_ae" -form "{color_$name:text(select),optional {label \"Color\"} {options {{{} {}} {{\#ccffcc} {\#ccffcc}} {{\#ccccff} {\#ccccff}} {{\#ffcccc} {\#ffcccc}} {{\#cc99ff} {\#cc99ff}} {{\#99cccc} {\#99cccc}} {{\#cc99cc} {\#cc99cc}} {{\#cccc99} {\#cccc99}} {{\#ffcc99} {\#ffcc99}} {{\#99ffcc} {\#99ffcc}} {{\#ffffcc} {\#ffffcc}}}}}"
    #ad_form -extend -name "filter_ae" -form "{color_$name:text(select),optional {label \"Color\"} {options $color_list_options}}"
}

# Add color text box 
foreach l $filter_list2 {
    set name [lindex $l 1]
    ad_form -extend -name "filter_ae" -form "{color_$name:text(select),optional {label \"Color\"} \
                          {options {{{} {}} {{\#ccffcc} {\#ccffcc}} {{\#ccccff} {\#ccccff}} {{\#ffcccc} {\#ffcccc}} {{\#cc99ff} {\#cc99ff}} {{\#99cccc} {\#99cccc}} {{\#cc99cc} {\#cc99cc}} {{\#cccc99} {\#cccc99}} {{\#ffcc99} {\#ffcc99}} {{\#99ffcc} {\#99ffcc}} {{\#ffffcc} {\#ffffcc}}}}}"
}

ad_form -extend -name "filter_ae" -form {
    {filter_name:text(text) {label "Filter Name"}}
    {description:text(text),optional {label "Description"}}
    {filter_type:text(select) {label "Filter Type"} {options $filter_type_options}}
    {room_id:integer(checkbox),multiple,optional {options $filter_list1}}
    {category_id:integer(checkbox),multiple,optional {options $filter_list2}}
    {submit:text(submit) {label $page_title}}
} -validate {
    {filter_name {[ctrl::cal::filter::name_unique_p -cal_id $cal_id -cal_filter_id $cal_filter_id -filter_name $filter_name]} "Filter name already exist for this calendar, please use another name"}
} -new_request {

} -edit_request {
    set error_p [catch {
        if {[info exists cal_filter_id]} {
	    set selection [db_0or1row get_filter_data {}]
	    
	    if {!$selection} {
		ad_return_error "Error" "An invalid filter_id has been passed to this page.  
                Please contact the system administrator at 
                <a href=\"mailto:[ad_host_administrator]\">[ad_host_administrator]</a>
                if you have any questions.  Thank you."
		ad_script_abort
	    }	    
	}

	# Set filter objects
	if {$filter_type=="category"} {
	    set category_id [ctrl::cal::filter::get_mapped_object_id -cal_filter_id $cal_filter_id]
	    set room_id {}
	} elseif {$filter_type=="resource"} {
	    set room_id [ctrl::cal::filter::get_mapped_object_id -cal_filter_id $cal_filter_id]
	    set category_id {}
	}

	# Set filter color 
	foreach item [ctrl::cal::filter::get_mapped_color -cal_filter_id $cal_filter_id] {
	    set color_[lindex $item 0] [lindex $item 1]
	}
    } errmsg ]
    
    if {$error_p} {
	ad_return_error "Error" "$errmsg"
	ad_script_abort
    }
    
} -new_data {
    set fail_p [catch {
	set cal_filter_id [ctrl::cal::filter::new -cal_filter_id $cal_filter_id -filter_name $filter_name -description $description -cal_id $cal_id -filter_type $filter_type]
	ctrl::cal::filter::map -cal_filter_id $cal_filter_id -filter_list $filter_list -color_list $color_list -update_p 0
    } errmsg]

    if {$fail_p != 0} {
        ad_return_error "Fail" $errmsg
        return
    }

} -edit_data {
    set fail_p [catch {
	ctrl::cal::filter::update -cal_filter_id $cal_filter_id -filter_name $filter_name -description $description -cal_id $cal_id -filter_type $filter_type
	ctrl::cal::filter::map -cal_filter_id $cal_filter_id -filter_list $filter_list -color_list $color_list -update_p 1
    } errmsg]

    if {$fail_p != 0} {
        ad_return_error "Fail" $errmsg
        return
    }
} -on_submit {

    if {($filter_type=="resource")} {
	set filter_list $room_id
    } elseif {($filter_type=="category")} {
	set filter_list $category_id
    }

    foreach id $filter_list {
	if {[empty_string_p [set color_$id]]} {
	    ad_return_complaint 1 "Please select a color for all your choices"
	    ad_script_abort
	} 
	lappend color_list [set color_$id]
    }

} -after_submit {
    ad_returnredirect "index?[export_url_vars cal_id]"
} 

