# /packages/institution/tcl/publication-pubmed-procs.tcl

ad_library {

    Publication Procedures having to do with Pubmed
    @author avni@ctrl.ucla.edu (AK)
    @creation-date 1/24/2006
    @cvs-id $Id: publication-pubmed-procs.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

    @publication::pubmed::search
    @publication::pubmed::get_xml_data
    @publication::pubmed::import
}
namespace eval publication::pubmed {}

ad_proc publication::pubmed::search {
    {-publication_id ""}
} {
    Procedure which searches for the publication(s) in Pubmed and
    get the pubmed_id and pubmed_XML
    for FDB Publications from PubMed

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 9/2/2004
} {

    ### START VARIABLES TO MODIFY #############################################################################################
    ### Set up Search Variables
    set pubmed_search_url "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
    set pubmed_db "pubmed"
    set pubmed_usehistory "y"

    ### Set up Fetch Variables
    set pubmed_fetch_url "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    set pubmed_rettype "xml"
    set pubmed_retmode "text"
    set pubmed_retstart "0"

    # Maximum number of publications to return from Search and Fetch
    set pubmed_retmax "10"
    ### END VARIABLES TO MODIFY ###############################################################################################

    ### For each publication in the FDB see if there is a pubmed publication that matches
    if {[empty_string_p $publication_id]} {
	set publication_constraint " where not exists (select 1 from inst_external_pub_id_map iepim where ip.publication_id=iepim.inst_publication_id)"
    } else {
	set publication_constraint " where ip.publication_id = :publication_id"
    }

    set error_count 0
    db_foreach get_publications {} {

	### See if publication is in pubmed
	set pubmed_term [string trim $title]
	regexp -nocase "<.*?>(.*)</.*>" $pubmed_term match pubmed_term
	regsub -all " " $pubmed_term "+" pubmed_term
	#regsub -all "\"" $pubmed_term "" pubmed_term

	set pubmed_search_formvars "db=$pubmed_db&retmax=$pubmed_retmax&usehistory=$pubmed_usehistory&term=$pubmed_term"

	catch {
	    # DELETE CURRENT RECORDS IN inst_external_pub_id_map FOR THIS PUBLICATION
	    publication::pubmed::delete -publication_id $publication_id

	    set pubmed_result [util_httppost "$pubmed_search_url" "$pubmed_search_formvars"]

	    ### Get PubMed Result Count
	    set pubmed_result_count 0
	    catch {
		regexp -nocase "<count>.*?</count>+" $pubmed_result pubmed_result_count
	    } errormsg
	    regsub -nocase -all "</count>" $pubmed_result_count "<count>" pubmed_result_count
	    regsub -nocase -all "<count>" $pubmed_result_count "" pubmed_result_count
	    ### End Getting PubMed Result Count
	
	    ns_log notice "INSTITUTION PUBMED --> Publication ID: $publication_id Pubmed Result Count: $pubmed_result_count"

	    if {$pubmed_result_count >= 1} {

		### Get PubMed Query Key
		set pubmed_result_querykey ""
		catch {
		    regexp -nocase "<querykey>.*?</querykey>+" $pubmed_result pubmed_result_querykey
		} errormsg
		regsub -nocase -all "</querykey>" $pubmed_result_querykey "<querykey>" pubmed_result_querykey
	        regsub -nocase -all "<querykey>" $pubmed_result_querykey "" pubmed_result_querykey
		### End Getting PubMed Query Key

	        ### Get PubMed Web Env
	        set pubmed_result_webenv ""
	        catch {
		    regexp -nocase "<webenv>.*?</webenv>+" $pubmed_result pubmed_result_webenv
		} errormsg
		regsub -nocase -all "</webenv>" $pubmed_result_webenv "<webenv>" pubmed_result_webenv
	        regsub -nocase -all "<webenv>" $pubmed_result_webenv "" pubmed_result_webenv
	        ### End Getting PubMed Web Env

	        ### Fetch Publication Data
		set pubmed_fetch_formvars "rettype=$pubmed_rettype&retmode=$pubmed_retmode&retstart=$pubmed_retstart&retmax=$pubmed_retmax&db=$pubmed_db&query_key=$pubmed_result_querykey&WebEnv=$pubmed_result_webenv"
		set pubmed_fetch [util_httppost $pubmed_fetch_url $pubmed_fetch_formvars]
		### End Fetching Publication Data

		### START PROCESSING THE XML RETURNED ############################################################################################################
		set xml_content [dom parse -simple $pubmed_fetch]
		set publication_root [ctrl_procs::tdom_get_node_pointer $xml_content "PubmedArticleSet" "pubmedarticleset"]
		if {[empty_string_p $publication_root]} {
		    ad_return_error "Error" "Error: Invalid XML return from Pubmed."
		    return
		}

		set publication_list [ctrl_procs::tdom_get_node_pointer $publication_root "PubmedArticle" "pubmedarticle"]

		if {[empty_string_p $publication_list]} {
		    ad_return_error "Error" "ERROR: No publications returned."
		    return
		}

		foreach publication $publication_list {
		    ### Get PubMed XML
		    set pubmed_xml [ctrl_procs::tdom_get_node_xml $publication]
		    ### End Getting PubMed XML

		    ### Get PubMed ID
		    set pubmed_id ""
		    catch {
			regexp -nocase "<pmid>.*?</pmid>+" $pubmed_xml pubmed_id
		    } errormsg
		    regsub -nocase -all "</pmid>" $pubmed_id "<pmid>" pubmed_id
		    regsub -nocase -all "<pmid>" $pubmed_id "" pubmed_id
		    ### END Getting Pubmed ID

		    ### Insert Data
		    db_transaction {
			if {![empty_string_p $pubmed_id] && ![empty_string_p $pubmed_xml]} {
			    # Insert PubMed XML
			    db_dml publication_pubmed_insert {} -clobs [list $pubmed_xml]
			    ns_log notice "INSTITUTION PUBMED --> Inserted Publication: $publication_id - PubMed ID: $pubmed_id"

			} else {
			    ns_log notice "INSTITUTION PUBMED --> Publication NOT Inserted: $publication_id - PubMed ID: $pubmed_id"
			}


		    } on_error {
			incr error_count
			ns_log notice "PUBMED --> Error: $errmsg"
			db_abort_transaction
		    }
		    ### End Inserting Data
		}
		### END PROCESSING THE XML RETURNED ##############################################################################################################
	    }
	} errormsg
    }
    if {$error_count} {
	return 0
    }
    return 1
}

ad_proc publication::pubmed::get_xml_data {
    -xml
    {-return_type "html"}
    {-publication_id 0}
    {-update_p 0}
} {
    Procedure which returns XML data
    format for a Pubmed Publication

    Return type can be sql or html

} {
    ### START INITIAL VARIABLES 
    set pubmed_id ""
    set title ""
    set publication_name ""
    set volume ""
    set issue ""
    set year ""
    set publish_date ""
    set authors ""
    set page_range ""
    set url ""
    ### END INITIAL VARIABLES

    set error_p [catch {
	set xml [dom parse -simple $xml]
	set record_root [ctrl_procs::tdom_get_node_pointer $xml "MedlineCitation" "medlinecitation"]
	if {[empty_string_p $record_root]} {
		return "-1"
	}

	### START PUBMED ID
	set pubmed_id [ctrl_procs::tdom_get_tag_value $record_root "PMID" "pmid"]
	### END PUBMED ID

	### START ARTICLE ELEMENTS
	set article_root [ctrl_procs::tdom_get_node_pointer $record_root "Article" "article"]
	if {![empty_string_p $article_root]} {

	    # TITLE
	    set title [ctrl_procs::tdom_get_tag_value $article_root "ArticleTitle" "articletitle"]

	    ### START JOURNAL ELEMENTS
	    set journal_root [ctrl_procs::tdom_get_node_pointer $article_root "Journal" "journal"]
	    if {![empty_string_p $journal_root]} {
		# PUBLICATION NAME
		set publication_name [ctrl_procs::tdom_get_tag_value $journal_root "Title" "title"]

		### START JOURNALISSUE ELEMENTS
		set journalissue_root [ctrl_procs::tdom_get_node_pointer $journal_root "JournalIssue" "journalissue"]
		if {![empty_string_p $journalissue_root]} {
		    # VOLUME
		    set volume [ctrl_procs::tdom_get_tag_value $journalissue_root "Volume" "volume"]
		    # ISSUE
		    set issue [ctrl_procs::tdom_get_tag_value $journalissue_root "Issue" "issue"]

		    ### START PUBDATE ELEMENTS
		    set pubdate_root [ctrl_procs::tdom_get_node_pointer $journalissue_root "PubDate" "pubdate"]
		    if {![empty_string_p $pubdate_root]} {
			# YEAR
			set year [ctrl_procs::tdom_get_tag_value $pubdate_root "Year" "year"]
			set month [ctrl_procs::tdom_get_tag_value $pubdate_root "Month" "month"]
			set day [ctrl_procs::tdom_get_tag_value $pubdate_root "Day" "day"]
			# PUBLISH DATE
			if {![empty_string_p $year] && ![empty_string_p $month]} {
			    if {![empty_string_p $day]} {
				set publish_date "$month $day, $year"
				set publish_date_format "Mon DD, YYYY"
			    } else {
				set publish_date "$month $year"
				set publish_date_format "Mon YYYY"
			    }
			}
		    }
		    ### END PUBDATE ELEMENTS
		}
		### END JOURNALISSUE ELEMENTS
	    }
	    ### END JOURNAL ELEMENTS

	    ### START AUTHORLIST ELEMENTS
	    set authorlist_root [ctrl_procs::tdom_get_node_pointer $article_root "AuthorList" "authorlist"]
	    if {![empty_string_p $authorlist_root]} {
		# START AUTHORS ELEMENTS
		set authors [list]
		set author_list [ctrl_procs::tdom_get_node_pointer $authorlist_root "Author" "author"]
		foreach author $author_list {
		    # AUTHOR
		    lappend authors "[ctrl_procs::tdom_get_tag_value $author "LastName" "lastname"], [ctrl_procs::tdom_get_tag_value $author "Initials" "initials"]"
		}
		set authors [join $authors " "]
		### END AUTHORS ELEMENTS
	    }
	    ### END AUTHORLIST ELEMENTS

	    ### START PAGINATION ELEMENTS
	    set pagination_root [ctrl_procs::tdom_get_node_pointer $article_root "Pagination" "pagination"]
	    if {![empty_string_p $pagination_root]} {
		# PAGE RANGE
		set page_range [ctrl_procs::tdom_get_tag_value $pagination_root "MedlinePgn" "medlinepgn"]
	    }
	    ### END PAGINATION ELEMENTS
	}
	### END ARTICLE ELEMENTS
    } errormsg]

    ### CHECK IF THERE WAS AN ERROR IN THE XML PROCESSING
    if {$error_p} {
	return "END $errormsg"
    }

    ### START SET URL
    set url "http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&db=pubmed&dopt=Abstract&list_uids=$pubmed_id&query_hl=14"
    ### END SET URL

    ### START RETURN DATA IN REQUESTED FORMAT
    set html_data "<table cellpadding=\"2\" cellspacing=\"0\" border=\"0\">"
    set sql_data [list]

    if {![empty_string_p $title]} {
	append html_data "<tr><th align=\"right\" valign=\"top\">Title:</th><td>$title</td></tr>"
	lappend sql_data "title=:title"
    } 

    if {![empty_string_p $publication_name]} {
	append html_data "<tr><th align=\"right\">Publication:</th><td>$publication_name</td></tr>"
	lappend sql_data "publication_name=:publication_name"
    }

    if {![empty_string_p $authors]} {
	append html_data "<tr><th align=\"right\">Authors:</th><td>$authors</td></tr>"
	lappend sql_data "authors=:authors"
    }

    if {![empty_string_p $volume]} {
	append html_data "<tr><th align=\"right\">Volume:</th><td>$volume</td></tr>"
	lappend sql_data "volume=:volume"
    }

    if {![empty_string_p $issue]} {
	append html_data "<tr><th align=\"right\">Issue:</th><td>$issue</td></tr>"
	lappend sql_data "issue=:issue"
    }
    if {![empty_string_p $year]} {
	append html_data "<tr><th align=\"right\">Year:</th><td>$year</td></tr>"
	lappend sql_data "year=:year"
    }

    if {![empty_string_p $publish_date]} {
	append html_data "<tr><th align=\"right\">Publish Date:</th><td>$publish_date</td></tr>"
	lappend sql_data "publish_date=to_date(:publish_date,:publish_date_format)"
    }

    if {![empty_string_p $page_range]} {
	append html_data "<tr><th align=\"right\">Pages:</th><td>$page_range</td></tr>"
	lappend sql_data "page_ranges=:page_range"
    }

    if {![empty_string_p $url]} {
	lappend sql_data "url=:url"
    }

    append html_data "</table>"
    if {[string equal $return_type "html"]} {
	return $html_data
    } else {
	if {![empty_string_p $sql_data]} {
	    set sql_data "set [join $sql_data ","]"
	    if {$update_p} {
		set success_p 1
		db_transaction {
		    db_dml publication_update {}
		} on_error {
		    set success_p 0
		    db_abort_transaction
		}
		return $success_p
	    } else {
		return $sql_data
	    }
	} else {
	    return 0
	}
    }
    ### END RETURN DATA IN REQUESTED FORMAT
}

ad_proc publication::pubmed::import {
    -publication_id
    -pubmed_id
} {
    Updates publication columns with pubmed data
} {
    set xml [db_string pubmed_xml {} -default ""]

    set success_status "Success"
    if {![empty_string_p $xml]} {
	set success_p 1
	db_transaction {
	    set audit_p [publication::audit -publication_id $publication_id]
	    if {$audit_p} {
		set data_import [publication::pubmed::get_xml_data -xml $xml -return_type "sql" -publication_id $publication_id -update_p 1]
		db_dml import_status_update {}
	    }
	} on_error {
	    set success_p 0
	    db_abort_transaction
	}
    } else {
	set success_p 0
	set errmsg "XML string is empty."
    }

    if {!$success_p} {
	set success_status "Error: $errmsg"
    }
    return $success_status
}

ad_proc publication::pubmed::delete {
    -publication_id 
    {-exclude_pubmed_id ""}
    {-single_pubmed_id ""}
} {
    Procedure which deletes existing pubmed records for a publication
} {
    set pubmed_id_constraint ""
    if {![empty_string_p $exclude_pubmed_id]} {
	append pubmed_id_constraint " and pubmed_id != :exclude_pubmed_id "
    }
    if {![empty_string_p $single_pubmed_id]} {
	append pubmed_id_constraint " and pubmed_id = :single_pubmed_id "
    }

    set success_p 1
    db_transaction {
	db_dml pubmed_delete {}
    } on_error {
	set success_p 0
	db_abort_transaction
    }

    return $success_p
}


