ad_page_contract {

    returns a list of all the deprecated procedures present 
    in server memory


    @author Todd Nightingale
    @creation-date 2000-7-14
    @cvs-id $Id: deprecated.tcl,v 1.3 2002-09-10 22:22:04 jeffd Exp $

} {
} -properties {
    title:onevalue
    context:onevalue
    deprecated:multirow
}

set title "Deprecated Procedure Search"
set context [list "Deprecated Procedures"]

multirow create deprecated proc args

foreach proc [nsv_array names api_proc_doc] { 
    array set doc_elements [nsv_get api_proc_doc $proc]
 
    if {$doc_elements(deprecated_p) == 1} {
        multirow append deprecated $proc $doc_elements(positionals)
    } 
}

