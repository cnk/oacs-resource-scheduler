ad_page_contract {

    Prepare some datasources for the explain-persistent-cookies .adp

    @author Bryan Quinn (bquinn@arsdigita.com)
    @creation-date Mon Oct 16 09:27:34 2000
    @cvs-id $Id: explain-persistent-cookies.tcl,v 1.1.1.1 2001-03-13 22:59:26 ben Exp $
} {

} -properties {
    home_link:onevalue
}

set home_link [ad_site_home_link]
ad_return_template

