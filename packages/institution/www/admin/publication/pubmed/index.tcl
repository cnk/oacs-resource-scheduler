# /packages/institution/www/admin/publication/pubmed/index.tcl

ad_page_contract {

    Pubmed Detail for One Publication

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 1/25/2006
    @cvs-id $Id: index.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

} {
    publication_id:naturalnum,notnull
    {search_result:trim ""}
    {admin_url "[ad_conn package_url]admin/publication/"}
}

set user_id [ad_maybe_redirect_for_registration]
# AMK - ADD PERMISSION CHECK

set page_title "Pubmed Detail for One Publication"
set subsite_url [site_node_closest_ancestor_package_url]
set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
				     [list [set subsite_url]institution/ "Faculty Editor"] \
				     [list [set subsite_url]institution/admin/ "Faculty Editor Administration"] \
				     [list [set subsite_url]institution/admin/publication/ "Publication Administration"] \
				     "$page_title"]]


### START PUBLICATION INFORMATION ####################################################################################################
set selection [db_0or1row publication_information {}]
if {!$selection} {
    ad_return_error "Error" "An invalid publication_id has been passed to this page. Please contact the system administrator
    at <a href=\"mailto:[ad_host_administrator]\">[ad_host_administrator]</a> if you have any questions. Thank you."
    return
}

### END PUBLICATION INFORMATION ######################################################################################################

### START PUBLICATION PERSONNEL ######################################################################################################
db_multirow -extend {personnel_detail_url} publication_personnel publication_personnel {} {
    set personnel_detail_url "${subsite_url}institution/admin/personnel/detail?personnel_id=$person_id"
}
### END PUBLICATION PERSONNEL ########################################################################################################


### START PUBMED DATA ################################################################################################################
set pubmed_status [db_string pubmed_status {} -default ""]
switch $pubmed_status {
    0 {
	set pubmed_status "No Matches in Pubmed"
	set pubmed_action "search"
    }
    1 {
	set pubmed_status "Single Match in Pubmed"
	set pubmed_action "re-search"
    }
    default {
	set pubmed_status "Multiples Matches in Pubmed"
	set pubmed_action "re-search"
    }
}

# GET EXISTING DATA
db_multirow -extend {pubmed_data_html import_url flag_url delete_url} pubmed_data pubmed_data {} {
    set pubmed_data_html [publication::pubmed::get_xml_data -xml $pubmed_xml -return_type "html"]
    set import_url "import?[export_url_vars pubmed_id publication_id admin_url]"
    set flag_url "flag?[export_url_vars pubmed_id publication_id admin_url]"
    set delete_url "delete?[export_url_vars pubmed_id publication_id admin_url]"
}
### END PUBMED DATA ##################################################################################################################


