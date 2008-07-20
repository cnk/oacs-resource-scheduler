# /packages/institution/publication/publication-results.tcl

ad_page_contract {

    Display Publications returned from sql_query

    @author nick@ucla.edu
    @creation-date 2004/02/16
    @cvs-id $Id: publication-results.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
} 

# no need to check permissions here because this is just an include

if [template::util::is_nil sql_query] {set sql_query ""}
# need error if no link passed in
if [template::util::is_nil link] {set link ""}
# needed for pag.
if [template::util::is_nil first_number] {set first_number 1}
if [template::util::is_nil last_number] {set last_number 25}
if [template::util::is_nil nav_bar] {set nav_bar ""}
# if pag_bool = 0, then first_number, last_number, and nav_bar don't need to be set
if [template::util::is_nil pag_bool] {set pag_bool 1}
# page title - used only for pages that are not searches
if [template::util::is_nil title] {set title "Search Results"}
if [template::util::is_nil publication_edit] {set publication_edit 0}

if {[empty_string_p $sql_query]} {
    #return error since we can't do anything without a query
    ad_return_error "Error" "No Query Was Supplied"
} elseif {[empty_string_p $link]} {
    ad_return_error "Error" "No Link Was Supplied"
} elseif {$pag_bool ==1} {    
    set counter 0
    db_multirow -extend {row_counter} results results {$sql_query} { 
	set row_counter [expr $counter+1]
	incr counter
    }    
} else {
    db_multirow -extend {row_counter} results2 results {$sql_query} {} 
}
