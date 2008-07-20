# /packages/institution/www/admin/publication/pubmed/flag.tcl

ad_page_contract {

    Page for flgging pubmed XML data for a publication

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2005/08/30
    @cvs-id $Id: flag.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    publication_id:naturalnum,notnull
    pubmed_id:naturalnum,notnull
    {admin_url "[ad_conn package_url]admin/publication/"}
}

set user_id [ad_maybe_redirect_for_registration]
set subsite_url [site_node_closest_ancestor_package_url]

publication::pubmed::delete -publication_id $publication_id -exclude_pubmed_id $pubmed_id

ad_returnredirect "${subsite_url}institution/admin/publication/pubmed?[export_url_vars publication_id admin_url]"
