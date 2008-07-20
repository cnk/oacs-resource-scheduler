# /packages/institution/www/admin/publication/pubmed/import.tcl

ad_page_contract {

    Page for importing pubmed publications XML and Pubmed ID into FDB
    See http://pubmed.gov/ for instructions on how to submit queries

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2005/08/30
    @cvs-id $Id: import.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    publication_id:naturalnum,notnull
    pubmed_id:naturalnum,notnull
    {admin_url "[ad_conn package_url]admin/publication/"}
}

set user_id [ad_maybe_redirect_for_registration]
set subsite_url [site_node_closest_ancestor_package_url]

set import_status [publication::pubmed::import -pubmed_id $pubmed_id -publication_id $publication_id]
if {![string equal $import_status "Success"]} {
    ad_return_error "Error" "Error Updating Publication.<p>$import_status"
    return
}
publication::pubmed::delete -publication_id $publication_id -exclude_pubmed_id $pubmed_id

ad_returnredirect "$admin_url"
