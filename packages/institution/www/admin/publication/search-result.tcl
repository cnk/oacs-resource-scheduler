ad_page_contract {
	@author    nick@ucla.edu
	@creation-date	2004/02/01
	@cvs-id $Id: search-result.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
    {combine_method:integer 0}
    {letter:trim,optional ""}
    {title:trim,optional ""}
    {publication_name:trim,optional ""}
    {url:trim,optional ""}
    {authors:trim,optional ""}
    {volume:trim,optional ""}
    {issue:trim,optional ""}
    {page_ranges:trim,optional ""}
    {year:integer,optional ""}
    {publish_date:array,optional ""}
    {creation_date:array,optional ""}
    {last_modified:array,optional ""}
    {current_page:naturalnum 0}
    {row_num:naturalnum 10}
}

# used to determine if the searchee can search acs_objects fields
# anyone can view the basic search results though
set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set subsite_url [site_node_closest_ancestor_package_url]
set publication_search_p [permission::permission_p -object_id $package_id -privilege "admin"]

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] [list [set subsite_url]institution "Faculty Editor"] [list [set subsite_url]institution/personnel/ "Personnel Index"] "Search Results"]]

set link "detail?"

# if combine method equals 0, do all, if equals 1 do any.
if {$combine_method == 0} {
    set where_conjuction "and"
} else {
    set where_conjuction "or"
}

# basic where clause for joins to work
set where_clause ""

# used to determine if entered any of the if's or not
set where_bool 0

if {![empty_string_p $letter]} {
    set filter "'[string tolower $letter]%'"
    append where_clause "where lower(title) like $filter"
} else {
    if {![empty_string_p $title]} {
	if {!$where_bool} {
	    append where_clause "where (lower(title) = lower(:title)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction title = lower(:title)"
	}
    }
    if {![empty_string_p $publication_name]} {
	if {!$where_bool} {
	    append where_clause "where (lower(publication_name) = lower(:publication_name)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(publication_name) = lower(:publication_name)"
	}
    }
    if {![empty_string_p $url]} {
	if {!$where_bool} {
	    append where_clause "where (lower(url) = lower(:url)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(url) = lower(:url)"
	}
    }
    if {![empty_string_p $authors]} {
	if {!$where_bool} {
	    append where_clause "where (lower(authors) = lower(:authors)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(authors) = lower(:authors)"
	}
    }
    if {![empty_string_p $volume]} {
	if {!$where_bool} {
	    append where_clause "where (lower(volume) = lower(:volume)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(volume) = lower(:volume)"
	}
    }
    if {![empty_string_p $issue]} {
	if {!$where_bool} {
	    append where_clause "where (lower(issue) = lower(:issue)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(issue) = lower(:issue)"
	}
    }
    if {![empty_string_p $page_ranges]} {
	if {!$where_bool} {
	    append where_clause "where (lower(page_ranges) = lower(:page_ranges)"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction lower(page_ranges) = lower(:page_ranges)"
	}
    }
    if {![empty_string_p $year]} {
	if {!$where_bool} {
	    append where_clause "where (year = :year"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction year = :year"
	}
    }
    if {[exists_and_not_null publish_date(year)]} {
	set publish_year $publish_date(year)
	set publish_month $publish_date(month)
	if {$publish_month < 10} {
	    set publish_month "0$publish_month"
	}
	if {!$where_bool} {
	    append where_clause "where (to_char(publish_date, 'YYYY-MM') = '$publish_year-$publish_month'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(publish_date, 'YYYY-MM') = '$publish_year-$publish_month'"

	}
    }

        # creation_date year and month filled in
    if {[exists_and_not_null creation_date(year)] && [exists_and_not_null creation_date(month)]} {
	set creation_year $creation_date(year)
	set creation_month $creation_date(month)
	if {$creation_month < 10} {
	    set creation_month "0$creation_month"
	}
	if {!$where_bool} {
	    append where_clause "where (to_char(ao.creation_date, 'YYYY-MM') = '$creation_year-$creation_month'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(ao.creation_date, 'YYYY-MM') = '$creaton_year-$creation_month'"
	}
    } elseif {[exists_and_not_null creation_date(year)]} {
	# creation_date year filled in
	set creation_year $creation_date(year)
	if {!$where_bool} {
	    append where_clause "where (to_char(ao.creation_date, 'YYYY') = '$creation_year'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(ao.creation_date, 'YYYY') = '$creaton_year'"
	}
    } elseif {[exists_and_not_null creation_date(month)]} {
	# creation_date month filled in
	set creation_month $creation_date(month)
	if {$creation_month < 10} {
	    set creation_month "0$creation_month"
	}
	if {!$where_bool} {
	    append where_clause "where (to_char(ao.creation_date, 'MM') = '$creation_month'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(ao.creation_date, 'MM') = '$creation_month'"
	}
    }

    # last_modified year and month filled in
    if {[exists_and_not_null last_modified(year)] && [exists_and_not_null last_modified(month)]} {
	set modified_year $last_modified(year)
	set modified_month $last_modified(month)
	if {$modified_month < 10} {
	    set modified_month "0$modified_month"
	}
	if {!$where_bool} {
	    append where_clause "where (to_char(ao.last_modified, 'YYYY-MM') = '$modified_year-$modified_month'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(ao.last_modified, 'YYYY-MM') = '$modified_year-$modified_month'"
	}
    } elseif {[exists_and_not_null last_modified(year)]} {
	# last_modified just year
	set modified_year $last_modified(year)
	if {!$where_bool} {
	    append where_clause "where (to_char(ao.last_modified, 'YYYY') = '$modified_year'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(ao.last_modified, 'YYYY') = '$modified_year'"
	}
    } elseif {[exists_and_not_null last_modified(month)]} {
	# last_modified just month
	set modified_month $last_modified(month)
	if {$modified_month < 10} {
	    set modified_month "0$modified_month"
	}
	if {!$where_bool} {
	    append where_clause "where (to_char(ao.last_modified, 'MM') = '$modified_month'"
	    set where_bool 1
	} else {
	    append where_clause " $where_conjuction to_char(ao.last_modified, 'MM') = '$modified_month'"

	}
    }
}

if {$where_bool} {
    append where_clause ")"
}

if {!$publication_search_p} {
    # creating bounds for page select function
    set correction [db_string number_of_rows "select count(distinct publication_id) from inst_publications $where_clause order by publication_id"]
    set sql_query "select 	distinct qb.publication_id, qb.pub_title, qb.pub_authors
	           from 	(select	qa.publication_id, qa.pub_title, qa.pub_authors, rownum row_real
		         	from	(select distinct publication_id, title as pub_title, authors as pub_authors
				         from inst_publications
				         $where_clause
				         order by publication_id) qa) qb"
} else {
   # creating bounds for page select function
    set correction [db_string number_of_rows "select count(distinct publication_id) from inst_publications, acs_objects ao $where_clause order by publication_id"]
    set sql_query "select 	distinct qb.publication_id, qb.pub_title, qb.pub_authors
	           from 	(select	qa.publication_id, qa.pub_title, qa.pub_authors, rownum row_real
		         	from	(select distinct publication_id, title as pub_title, authors as pub_authors
				         from inst_publications, acs_objects ao
				         $where_clause
				         order by publication_id) qa) qb"
}

# passed no preference
set my_vars {combine_method letter title publication_name url authors volume issue page_ranges year publish_date}
set url "[set subsite_url]institution/publication/search-result?[export_vars $my_vars]"
set pag_results [ctrl_procs::pagination -total_items $correction -current_page $current_page -row_num $row_num -path $url]

set first_number [lindex $pag_results 0]
set last_number [lindex $pag_results 1]
set navigation_display [lindex $pag_results 2]
