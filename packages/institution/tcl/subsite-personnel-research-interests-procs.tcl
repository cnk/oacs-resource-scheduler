# /packages/institution/tcl/subsite-personnel-research-interests-procs.tcl

ad_library {

    Procs for subsite to research interest mappings

    @author            avni@ctrl.ucla.edu (AK)
    @creation-date     2004/09/16
    @cvs-id $Id: subsite-personnel-research-interests-procs.tcl,v 1.4 2006/09/19 22:32:38 avni Exp $
}

namespace eval inst::subsite_personnel_research_interests {}

ad_proc -public inst::subsite_personnel_research_interests::research_interest_exists_p {
    {-subsite_id:required}
    {-personnel_id:required}
} {
    Returns 1 if the personnel has a research interest for this subsite
    Returns 0 otherwise
} {
    return [db_string subsite_personnel_ri_exists_p {} -default 0]
}

ad_proc -public inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default {
    {-subsite_id:required}
    {-personnel_id:required}
    {-research_interest_type "lay"}
    {-default_p "1"}
} {
    Returns the research interest for the personnel & subsite passed. Uses the research_interest_type 
    to determine which type to return. If research interest doesn't exist and default_p is set to 1, returns the default research interest if it exists.
    If research interest doesn't exist and default_p is set to 0, returns a list with 2 empty strings.
} {
    if {![string compare $research_interest_type "technical"]} {
	set ri_column "technical_interest"
	set ri_title_column "technical_title"
    } else {
	set ri_column "lay_interest"
	set ri_title_column "lay_title"
    }

    set subsite_research_interests [db_0or1row subsite_ri_get_ri {}]

    if {$subsite_research_interests && ![empty_string_p [string trim [set $ri_column]]] } {
	return [list "[set $ri_title_column]" "[set $ri_column]"]
    } else {
	if {$default_p} {
	    # Get default subsite research_interests
	    set subsite_id [ctrl_procs::subsite::get_main_subsite_id]
	    set default_subsite_research_interests [db_0or1row subsite_ri_get_ri {}]
	    if {$default_subsite_research_interests} {
		return [list "[set $ri_title_column]" "[set $ri_column]"]
	    }
	}
    }
    return [list "" ""]
}

    
ad_proc -public inst::subsite_personnel_research_interests::personnel_research_interest_insert {
    {-subsite_id:required}
    {-personnel_id:required}
    {-lay_title ""}
    {-lay_interest ""}
    {-technical_title ""}
    {-technical_interest ""}
} {
    Inserts a record into the research interest table
} {
    set success_p 1
    db_transaction {
	db_dml ri_insert {}
    } on_error {
	set success_p 0
	db_abort_transaction
    }

    return $success_p
}


ad_proc -public inst::subsite_personnel_research_interests::personnel_research_interest_update {
    {-subsite_id:required}
    {-personnel_id:required}
    {-lay_title ""}
    {-lay_interest ""}
    {-technical_title ""}
    {-technical_interest ""}
} {
    Updates a record into the research interest table 
} {
    set success_p 1
    db_transaction {
	db_dml ri_update {}
    } on_error {
	set success_p 0
	db_abort_transaction
    }

    return $success_p
}
    

ad_proc -public inst::subsite_personnel_research_interests::personnel_research_interest_delete {
    {-personnel_id:required}
} {
    Deletes personnels research interesets from the db
} {
    db_dml ri_delete {}
    return
}
