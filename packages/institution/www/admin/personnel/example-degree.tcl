# /packages/institution/www/admin/personnel/example-degree.tcl

ad_page_contract {

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2004/12/8
    @cvs-id $Id: example-degree.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {personnel_id:naturalnum 0}
}

set return_url "detail?[export_vars {personnel_id}]#research-info"
