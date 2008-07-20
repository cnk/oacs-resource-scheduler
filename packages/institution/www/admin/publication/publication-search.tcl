ad_page_contract {
	@author    nick@ucla.edu
	@creation-date	2004/02/01
	@cvs-id $Id: publication-search.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]
# used to determine if the searchee can search acs_objects fields
set publication_search_p [permission::permission_p -object_id $package_id -privilege "admin"]

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [ad_conn package_url]admin/personnel/ "Personnel Index"] "Publication Search"]]

set title "Publication Search"

################################################################################
# the search form
################################################################################
set ltr_index [list]
foreach ltr {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z} {
    lappend ltr_index "<a href='search-result?letter=$ltr'>$ltr</a>"
}
set letter_index [join $ltr_index "&nbsp;"]

ad_form -name search_publication -action {search-result} -method {post} -form {
    {combine_method:integer(select),optional	{label ""}	         {options {{"All" 0} {"Any" 1}}} {value 0}}
    {title:text,optional		{label "title"}}
    {publication_name:text,optional     {label "Publication Name"}}
    {url:text,optional                  {label "URL"}}
    {authors:text,optional              {label "Author"}}
    {volume:text,optional               {label "Volume"}}
    {issue:text,optional                {label "Issue"}}
    {page_ranges:text,optional          {label "Page Range(s)"}}
    {year:integer,optional              {label "Year"}}
    {publish_date:date,optional         {label "Publish Date"} {format {Mon YYYY}}}
    {creation_date:date,optional        {label "Creation Date"} {format "Month YYYY"}}
    {last_modified:date,optional        {label "Date Last Modified"} {format "Month YYYY"}}
    {search:text(submit)                {label "Search"}}    
} 
