ad_page_contract {
    Will redirect you to aolserver.com if documentation can be found
    @cvs-id $Id: tcl-proc-view.tcl,v 1.5 2003-05-17 09:38:28 jeffd Exp $
} {
    tcl_proc
} -properties {
    title:onevalue
    context:onevalue
    tcl_proc:onevalue
}

set tcl_api_root "http://www.aolserver.com/docs/devel/tcl/api/"

set tcl_api_index_page [util_memoize "ns_httpget $tcl_api_root"]

set tcl_proc [lindex $tcl_proc 0]

set len [string length $tcl_proc]

for { set i [expr { $len-1 }] } { $i >= 0 } { incr i -1 } {
    set search_for [string range $tcl_proc 0 $i]
    if { [regexp "<a href=(\[^>\]+#\[^>\]+)>$search_for</a>" $tcl_api_index_page match relative_url] } {
        ad_returnredirect "$tcl_api_root$relative_url"
        ad_script_abort
    } 
}

set title "AOLserver Tcl API Search for: \"$tcl_proc\""
set context [list "TCL API Search: $tcl_proc"]
