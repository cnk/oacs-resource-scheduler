# /packages/institution/www/admin/publication/pubmed/search.tcl

ad_page_contract {

    Page for importing pubmed publications XML and Pubmed ID into FDB
    See http://pubmed.gov/ for instructions on how to submit queries

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2005/08/30
    @cvs-id $Id: search.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {publication_id:naturalnum ""}
}

set user_id [ad_maybe_redirect_for_registration]
set subsite_url [site_node_closest_ancestor_package_url]

set search_result [publication::pubmed::search -publication_id $publication_id]

if {[empty_string_p $publication_id]} {
    ad_returnredirect "${subsite_url}institution/admin/publication/"
} else {
    ad_returnredirect "${subsite_url}institution/admin/publication/pubmed?[export_url_vars publication_id]"
}




