ad_library {
    Procedures for tcl lists

    @author CTRL
    @cvs-id $Id: list-procs.tcl,v 1.2 2005/02/18 21:42:56 jwang1 Exp $
    @creation-date 
}

namespace eval ctrl::list {}

ad_proc ctrl::list::lists_minus {listA listB} {

    @author KH
    @param listA - the first list
    @param listB - the second list
    
    Returns a list of two elements. The first element is listA-listB and the second is listB-listA
} {
    set listA_listB [list]
    set listB_listA [list]

    foreach item $listA {
        if {[lsearch -exact $listB $item]  < 0} {
            lappend listA_listB $item
        }
    }
    foreach item $listB {
        if {[lsearch -exact $listA $item]  < 0} {
            lappend listB_listA $item
        }
    }

    return [list $listA_listB $listB_listA]
}
