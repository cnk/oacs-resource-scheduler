# /packages/mbryzek-subsite/www/admin/rel-segments/constraints-redirect.tcl

ad_page_contract {

    Optionally redirects user to enter constraints

    @author mbryzek@arsdigita.com
    @creation-date Thu Jan  4 11:20:37 2001
    @cvs-id $Id: constraints-redirect.tcl,v 1.2 2007-01-10 21:22:07 gustafn Exp $

} {
    segment_id:naturalnum,notnull
    { operation "" }
    { return_url "" }
}

set operation [string trim [string tolower $operation]]

if {$operation eq "yes"} {
    ad_returnredirect "constraints/new?rel_segment=$segment_id&[ad_export_vars return_url]"
} else {
    if { $return_url eq "" } {
	set return_url "one?[ad_export_vars segment_id]"
    }
    ad_returnredirect $return_url
}

