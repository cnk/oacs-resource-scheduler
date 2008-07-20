# /packages/institution/www/admin/research-interests/delete.tcl

ad_page_contract {
    
    Delete a Research Interest
    
    @param personnel_id
    @param subsite_id

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/12/08
    @cvs-id $Id: delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:naturalnum,notnull}
    {subsite_id:naturalnum,notnull}
    {type:trim,notnull}
} 

# Make sure user has permission to edit personnel


# Make sure type is either lay or technical
if {[string compare $type "lay"] && [string compare $type "technical"]} {
    ad_return_error "Error" "The research interest type passed to this page is invalid. It must be \"technical\" or \"lay\".
    Please contact your <a href=\"mailto:[ad_host_administrator]\">system administrator</a> if you
    have any questions. Thank you."
    return
}

if {![string compare $type "lay"]} {
    set lay_title ""
    set lay_interest ""
    set technical_info	[inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default -subsite_id $subsite_id  -personnel_id $personnel_id \
	    -research_interest_type "technical" -default_p 0]
    set technical_title	[lindex $technical_info 0]
    set technical_interest [lindex $technical_info 1]
} else {
    set lay_info	[inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default -subsite_id $subsite_id  -personnel_id $personnel_id \
	    -research_interest_type "lay" -default_p 0]
    set lay_title	[lindex $lay_info 0]
    set lay_interest [lindex $lay_info 1]
    set technical_title ""
    set technical_interest ""
}

set delete_p [inst::subsite_personnel_research_interests::personnel_research_interest_update -subsite_id $subsite_id \
	-personnel_id $personnel_id -lay_title $lay_title -lay_interest $lay_interest \
	-technical_title $technical_title -technical_interest $technical_interest]

if {!$delete_p} {
    ad_return_error "Error Deleting Research Interest" "There was an error deleting the research interest."
    return
}

db_release_unused_handles
ad_returnredirect "../personnel/detail?[export_url_vars personnel_id]"
