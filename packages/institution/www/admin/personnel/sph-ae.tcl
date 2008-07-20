# /packages/institution/www/admin/personnel/sph-ae.tcl

ad_page_contract {
    Add / Edit School of Public Health Personnel Information

    @author kellie@ctrl.ucla.edu
    @creation-date 09/27/2006
    @cvs-id $Id
} {
    {personnel_id:integer,notnull}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]

#set category ids
set research_interests_id [category::find -path [list "SPH" "Research Areas"]]
set methodological_skills_id [category::find -path [list "SPH" "Methodological Skills"]]
set research_interests_options [inst::sph::category_list -parent_category_id $research_interests_id]
set methodological_skills_options [inst::sph::category_list -parent_category_id $methodological_skills_id]

set personnel_exists_p	[db_0or1row personnel_exist "select first_names, middle_name, last_name from persons where person_id = :personnel_id"]
if {!$personnel_exists_p} {
    ad_return_error "Error" "There is no personnel with this ID. Please contact your <a href=mailto:[ad_host_administrator]>system administrator</a> if you have any questions."
    return
}

set sph_personnel_exists_p [db_string sph_personnel_exists {select count(*) from sph_personnel where personnel_id = :personnel_id}]
if {$sph_personnel_exists_p} {
    set sph_personnel_id $personnel_id
}

# checking permissions in here
permission::require_permission -object_id $personnel_id -privilege "write"

# Make sure personnel is a SPH personnel
set sph_member_p [inst::sph::member_p -personnel_id $personnel_id]
if {!$sph_member_p} {
    ad_return_error "Error" "The personnel you selected is not a SPH Personnel. You have reached this page in error.
    Please contact your system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you
    have any questions. Thank you."
    return
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
					  [list [ad_conn package_url] "Faculty Editor"] \
					  [list [set subsite_url]institution/personnel/ "Personnel Index"] \
					  "Edit SPH Personnel Information"]]

set title "Edit SPH Information for $first_names $last_name"

ad_form -name sph_ae -form {
    sph_personnel_id:key
    {courses:text(textarea),optional {label "Courses"} {html {cols 40 rows 10}}}
    {research_interests:text(multiselect),optional,multiple {label "Research Areas"} {options {$research_interests_options}} {html {size 10}}}
    {methodological_skills:text(multiselect),optional,multiple {label "Methodological Skills"} {options {$methodological_skills_options}} {html {size 10}}}
    {submit:text(submit) {label "Submit"}}
} -edit_request {
    set courses [db_string get_sph_data {}]
    set pc_id $research_interests_id
    set research_interests [join [db_list get_categories {}] " "]
    set pc_id $methodological_skills_id
    set methodological_skills [join [db_list get_categories {}] " "]
} -new_data {
    set personnel_error 0
    db_transaction {
        db_dml sph_personnel_add {}
	
	set pc_id $research_interests_id
	foreach c_id $research_interests {
	    db_dml sph_personnel_categories {}
	}

	set pc_id $methodological_skills_id
	foreach c_id $methodological_skills {
	    db_dml sph_personnel_categories {}
	}

    } on_error {
        set personnel_error 1
        db_abort_transaction
    }
    if {$personnel_error} {
        ad_return_error "Error" "$pc_id<br>$c_id<br>There was an error adding the SPH Personnel Information.<p> $errmsg"
        return
    }

} -edit_data {
    # edit all currently displayed information
    set personnel_error 0

    db_transaction {
	db_dml sph_personnel_edit {}
	
	#delete all personnel categories
	db_dml sph_personnel_categories_delete {}

	#add all research interests categories
	set pc_id $research_interests_id
	foreach c_id $research_interests {
	    db_dml sph_personnel_categories {}
	}

	#add all methodological skills categories
	set pc_id $methodological_skills_id
	foreach c_id $methodological_skills {
	    db_dml sph_personnel_categories {}
	}
    } on_error {
	set personnel_error 1
	db_abort_transaction
    }
    if {$personnel_error} {
	ad_return_error "Error" "There was an error editing the SPH Personnel Information.<p> $errmsg"
	return
    }
} -after_submit {
    ad_returnredirect "detail?[export_vars {personnel_id}]"
} -export {
    personnel_id
} 
