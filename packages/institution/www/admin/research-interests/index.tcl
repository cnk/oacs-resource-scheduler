# /packages/institution/www/admin/research-interests/index.tcl

ad_page_contract {
    
    This page displays the research interests for the personnel_id
    passed in.
    
    @param personnel_id
    @param subsite_id

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/11/12
    @cvs-id $Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:naturalnum,notnull}
    {subsite_id:naturalnum "[ad_conn subsite_id]"}
} 

set user_id [ad_verify_and_get_user_id]
set subsite_url	[site_node_closest_ancestor_package_url]

### Personnel Info
set person_check [db_0or1row person_info {}]
if {!$person_check} {
    ad_return_error "Error" "The personnel id passed to this page is invalid.  Please contact your <a href=\"mailto:[ad_host_administrator]\">system administrator</a> if you
    have any questions. Thank you."
    return
}
### End Personnel Info

set title "Update Research Interests for $first_names $last_name"
set context_bar	[ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
	[list [ad_conn package_url] "Faculty Editor"] \
	[list [ad_conn package_url]admin/personnel/ "Personnel Index"] \
	[list [ad_conn package_url]admin/personnel/detail?[export_url_vars personnel_id] "Detail for $first_names $last_name"] \
	$title]]

set main_subsite_id [ctrl_procs::subsite::get_main_subsite_id]
if {![string compare $main_subsite_id $subsite_id]} {
    set subsite_name "Default"    
} else {
    set subsite_name [db_string ri_subsite_name {} -default ""]
}

if {[empty_string_p $subsite_name]} {
    ad_return_error "Error" "An invalid web site id has been passed to this page. Please contact your <a href=\"mailto:[ad_host_administrator]\">system administrator</a> if you
    have any questions. Thank you."
    return
}

if {![string compare [string tolower $subsite_name] "access"]} {
    set lay_label "Web Research"
    set lay_help "This is a description of research interests which will be displayed on your web profile page."
    set technical_label "Print Research"
    set technical_help "This is how your research interests will be displayed in the ACCESS brochure. This field must contain less than 2400 characters."
} else {
    set lay_label "Lay"
    set lay_help "This is a description of research interests appropriate for general non-technical readers."
    set technical_label "Technical"
    set technical_help "This should be a detailed description of your research interests."
}

ad_form -name ri_edit -form {
    {subsite_id:text(hidden)     {value $subsite_id}}
    {subsite:text(inform) {label "Web Site:"} {value $subsite_name}}
    {lay_title:text(text),optional              {label "$lay_label Title:"} {html {size 50 maxlength 4000}}}
    {lay_interest:text(textarea),optional       {label "$lay_label Interest:"} {html {rows 12 cols 50}}
    
         {help_text {$lay_help}}
	 
     }

    {technical_title:text(text),optional        {label "$technical_label Title:"} {html {size 50 maxlength 4000}}}
    {technical_interest:text(textarea),optional {label "$technical_label Interest:"} {html {rows 12 cols 50}}
    
         {help_text {$technical_help}}
	 
     }

    {submit:text(submit)                        {label "Update Research Interest"}}
} -export {
    personnel_id
} -on_request {

    set research_interest [db_0or1row ri_select {}]
    if {!$research_interest} {
	set lay_title ""
	set lay_interest ""
	set technical_title ""
	set technical_interest ""
    } 

} -on_submit {
    set technical_interest [string trim $technical_interest]
    if {![string compare [string tolower $subsite_name] "access"]} {
	if {[string length $technical_interest] > 2400} {
	    ad_return_complaint 1 "The print research interest (for the ACCESS brochure) must be less than 2400 characters. 
	    The research interest you entered is currently [string length $technical_interest] characters. Please go back and 
	    shorten the research interest. Thank you."
	    ad_script_abort
	}
    }

    set ri_exists_p [db_string ri_exists_p {}]
    if {$ri_exists_p} {
	# Update Research Interest
	set update_p [inst::subsite_personnel_research_interests::personnel_research_interest_update -subsite_id $subsite_id \
		-personnel_id $personnel_id -lay_title $lay_title -lay_interest $lay_interest \
		-technical_title $technical_title -technical_interest $technical_interest]
	if {!$update_p} {
	    ad_return_error "Error Updating Research Interest" "There was an error updating the personnel's research interest."
	    ad_script_abort
	}
    } else {
	# Insert Research Interest
	set insert_p [inst::subsite_personnel_research_interests::personnel_research_interest_insert -subsite_id $subsite_id \
		-personnel_id $personnel_id -lay_title $lay_title -lay_interest $lay_interest \
		-technical_title $technical_title -technical_interest $technical_interest]
	if {!$insert_p} {
	    ad_return_error "Error Inserting Research Interest" "There was an error inserting the personnel's research interest."
	    ad_script_abort
	}
    }
} -after_submit {
    ad_returnredirect  "../personnel/detail?[export_url_vars personnel_id]"
}
