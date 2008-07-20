# /packages/institution/www/admin/research-interests/delete.tcl

ad_page_contract {
    
    Moves a bio into the lay research interest field.
    
    @param personnel_id
    @param subsite_id

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/12/08
    @cvs-id $Id: bio-to-lay-interest.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:naturalnum,notnull}
} 
set subsite_url	[site_node_closest_ancestor_package_url]

# Make sure user has permission to edit personnel

# Get personnel's bio
set bio [db_string personnel_bio {
    select bio from inst_personnel where personnel_id = :personnel_id
} -default ""]

if {[empty_string_p $bio]} {
    ad_return_error "Error" "The bio field is null. You can not move a null bio into the lay research interest field."
    return
}

# Get main subsite_id
set subsite_id [ctrl_procs::subsite::get_main_subsite_id]

set lay_title ""
set lay_interest "$bio"

set ri_exists_p [inst::subsite_personnel_research_interests::research_interest_exists_p -subsite_id $subsite_id -personnel_id $personnel_id]

if {$ri_exists_p} {
    set current_lay_info [inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default -subsite_id $subsite_id  -personnel_id $personnel_id \
	    -research_interest_type "lay" -default_p 0]
    set current_lay_interest [lindex $current_lay_info 1]
    if {![empty_string_p [string trim $current_lay_interest]]} {
	ad_return_error "Research Interest Exists" "There is already a default lay research interest. You must clear the default lay research interest field
	in Step 2 before moving the bio. Please contact the system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you
	have any questions. Thank you."
	return
    }

    set technical_info [inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default -subsite_id $subsite_id  -personnel_id $personnel_id \
	    -research_interest_type "technical" -default_p 0]
    set technical_title [lindex $technical_info 0]
    set technical_interest [lindex $technical_info 1]
    set update_p [inst::subsite_personnel_research_interests::personnel_research_interest_update -subsite_id $subsite_id \
	    -personnel_id $personnel_id -lay_title $lay_title -lay_interest $lay_interest \
	    -technical_title $technical_title -technical_interest $technical_interest]

    if {!$update_p} {
	ad_return_error "Error Updating Research Interest" "There was an error updating the research interest."
	return
    }

} else {
    set insert_p [inst::subsite_personnel_research_interests::personnel_research_interest_insert -subsite_id $subsite_id \
	    -personnel_id $personnel_id -lay_title $lay_title -lay_interest $lay_interest \
	    -technical_title "" -technical_interest ""]

    if {!$insert_p} {
	ad_return_error "Error Updating Research Interest" "There was an error updating the research interest."
	return
    }
}

# Set personnel bio to be null
set error_p 0
db_transaction {
    db_dml personnel_bio_to_null {
	update inst_personnel
	set bio = null
	where personnel_id = :personnel_id
    }
} on_error {
    set error_p 1
    db_abort_transaction
}

if {$error_p} {
    ad_return_error "Error Clearing Bio" "There was an error clearing the bio. Please contact the system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> 
    and notify him of this problem. Thank you."
    return
}

db_release_unused_handles
ad_returnredirect "${subsite_url}institution/admin/personnel/personnel-ae?[export_url_vars personnel_id]"
