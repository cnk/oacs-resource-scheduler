# -*- tab-width: 4 -*-
# /packages/institutions/www/admin/sttp/sttp-delete.tcl
ad_page_contract {
	Mentor add and edit

	@author			reye@mednet.ucla.edu
	@creation-date	2004-10-22
	@cvs-id			$Id: sttp-delete.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $
} {
	{request_id:naturalnum,optional		}
	{personnel_id:naturalnum,optional	}
	{title_p:optional					""}
	{return_url							{[get_referrer]}}
}

switch -- $title_p {
	1 {set title "Adding a Mentorship"}
	2 {set title "Editing a Mentorship"}
	3 {set title "Deleting a Mentorship"}
	default {set title ""}
}

set subsite_id	[ad_conn subsite_id]
set object_type	"inst_short_term_trnng_prog"
set user_id		[ad_conn user_id]
set peer_ip		[ad_conn peeraddr]
set package_id	[ad_conn package_id]

set research_experience	[list [list Yes "t"] [list No "No"]]
set skills_mandatory	[list [list Yes "t"] [list No "f"]]
set available_options	[list [list Yes "t"] [list No "f"]]
set judge_options		[list [list Yes "t"] [list No "f"]]
set position_options	[list [list Yes "t"] [list No "f"]]

# for Department/Division/...
set no_preference		[list "(No Preference)"]
set groups				[linsert [db_list_of_lists subsite_groups {}] 0 $no_preference]

ad_form -name "mentor_info" -export [list title_p return_url] -form {
	{request_id:key}
	{personnel_id:text(hidden)}
	{short_name:text(inform)					{label "Department/Division/..."}}
	{department_chair_name:text(inform)			{label "Department Chair Name:"}}
	{description:text(inform)					{label "One-sentence description of your project:"} {html {rows 5 cols 50}}}
	{n_grads_currently_employed:text(inform)	{label "Number of graduate students currently in your lab:"}}
	{last_md_candidate:text(inform)				{label "Name of the most recent medical student who has worked with you:"}}
	{last_md_year:text(inform)					{label "Year worked (if applicable):"}}
	{n_requested:text(inform)					{label "Number of positions available:"}}
	{n_received:text(inform)					{label "Number of positions filled:"}}
	{experience_required_p:text(inform)			{label "Is previous research experience required?"}}
	{skill:text(inform)							{label "Particular Skills preferred in applicants:"}}
	{skill_required_p:text(inform)				{label "Are these Skills mandatory?"}}
	{attend_poster_session_p:text(inform)		{label "Are you or your designate able to attend the STTP Student Poster Session on Thursday, August 26, 2004 1-4 p.m.?"}}
} -edit_request {
	db_1row sttp_selection {}

	if {[string equal $experience_required_p "t"]} {
		set experience_required_p "Yes"
	} else {
		set experience_required_p "No"
	}

	if {[string equal $skill_required_p "t"]} {
		set skill_required_p "Yes"
	} else {
		set skill_required_p "No"
	}

	if {[string equal $attend_poster_session_p "t"]} {
		set attend_poster_session_p "Yes"
	} else {
		set attend_poster_session_p "No"
	}
} -on_submit {
	db_transaction {
		db_exec_plsql sttp_delete {}
	} on_error {
		set error_p 1
		db_abort_transaction
	}

	if {[exists_and_not_null error_p]} {
		ad_return_complaint 1 "An error occurred while attempting to delete your STTP Mentorship.<p>$errmsg"
		ad_script_abort
	}
} -after_submit {
	if {![exists_and_not_null return_url] || [regexp {sttp-delete} $return_url]} {
		set return_url "../personnel/detail?[export_vars {personnel_id}]"
	}
	template::forward $return_url
}

