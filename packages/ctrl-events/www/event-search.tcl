ad_page_contract {
    @creationg_date 07/25/2005
    @authro kellie@ctrl.ucla.edu
    @cvs-id $Id
} {

}

ad_form -name search_event -form {
    {search_object:text(text) {label "Object: "}}
    {submit:text(submit) {label "Search"}}
} -on_submit {
    
    set search_object "1014"

    if {![empty_string_p $search_object]} {

	#ad_return_complaint 1 $search_object
	#ad_script_abort
	
    }

    db_multirow -extend {view_link edit_link delete_link} search_result search_result {} {
	    set view_link ""
	    set edit_link ""
	    set delete_link ""
	}
}

set title "Event Search"
lappend context $title
