# -*- tab-width: 4 -*-
# /packages/institutions/www/admin/sttp/sttp-mentor-ae.tcl
ad_page_contract {
	Mentor add and edit

	@author			reye@mednet.ucla.edu
	@creation-date	2004-10-22
	@cvs-id			$Id: sttp-mentor-ae-copy.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

} {
	{user_id:naturalnum,optional}
	{personnel_id:integer 0}
	{return_url		{[get_referrer]}}
	{request_id:naturalnum,optional}
}

set subsite_id	[ad_conn subsite_id]
set object_type	"inst_short_term_trnng_prog"
set peer_ip		[ad_conn peeraddr]
set package_id	[ad_conn package_id]
set user_id		[ad_conn user_id]
set subsite_url [site_node_closest_ancestor_package_url]

set no_preference	{{<i>No Preference</i>} \"\"}
set reqd			{<b style=\"color: red\">*</b>}

if {[exists_and_not_null request_id]} {
    set sql_request "and request_id = :request_id"
} else {
    set sql_request ""
}

set sttp_exists_p [db_0or1row sttp_selection {}]

# determining to display personnel element #######################
if {$personnel_id} {
    set title "Renew Mentorship"
    set personnel_element     "{personnel_id:integer(hidden)  {value \$personnel_id}}"
} else {
	set title "Add Mentorship"
	set personnel_options [db_list_of_lists personnel_info {
		select	p.first_names || ' ' || p.last_name as name,
				i.personnel_id
		  from	persons p,
				inst_personnel i
		 where	p.person_id = i.personnel_id
		   and	not exists
				(select	1
				   from	inst_short_term_trnng_progs inst
				  where	i.personnel_id = inst.personnel_id)
		   and	acs_permission.permission_p(personnel_id, :user_id, 'create') = 't'
		 order	by p.last_name
	}]

    set personnel_element "{personnel_id:integer(multiselect),multiple,optional   {label \"Select the personnel to associate STTP Mentorship\"} {options \$personnel_options}}"
}


# Setup Select Widget Possible Values ##########################################
set research_experience	{{Yes t} {No f}}
set skills_mandatory	{{Yes t} {No f}}
set available_options	{{Yes t} {No f}}
set judge_options		{{Yes t} {No f}}
set position_options	{{Yes t} {No f}}

# for Department/Division/...
set groups				[db_list_of_lists subsite_groups {}]
set groups				[tree::sorter::sort_list_of_lists -list $groups]
set groups				[linsert $groups 0 $no_preference]

# getting parameter poster date from server #####################
set poster_session_date [ad_parameter "sttp_poster_session_date"]
set expiration_date [sttp::util::sysdate -frequency 270]
#set expiration_date [template::util::date::today]

ad_form -name "mentor_info" -export [list title_p return_url] -form "
	{request_id:key}
	$personnel_element
	{group_id:integer(select),optional			{label \"Department/Division/...\"} {options \"$groups\"}}
	{department_chair_name:text,optional		{label \"Department Chair Name:\"}}
	{description:text(textarea) 				{label \"One-sentence description of your project:$reqd\"}		{html {rows 5 cols 60 maxlength 4000}}}
	{n_grads_currently_employed:text,optional 	{label \"Number of graduate students currently in your lab:\"}	{html {size 5}}}
	{last_md_candidate:text,optional 			{label \"Name of the most recent medical student who has worked with you:\"}}
	{last_md_year:text,optional 				{label \"Year worked (if applicable):\"}							{html {size 4}}}
	{n_requested:text,optional 					{label \"Number of positions available:\"}						{html {size 5}}}
	{n_received:text,optional					{label \"Number of positions filled:\"}							{html {size 5}}
		{after_html {
			<br><font color=\"red\"><b>*Total number must equal <q>Number of
			postions available,</q> to close position</b></font><br><br>
		}}
	}
	{experience_required_p:text(radio) 			{label \"Is previous research experience required?$reqd\"} {options \"$research_experience\"}}
	{skill:text(textarea),optional				{label \"Particular Skills preferred in applicants:\"}			{html {rows 4 cols 60 maxlength 250}}}
	{skill_required_p:text(radio) 				{label \"Are these Skills mandatory?$reqd\"} {options \"$skills_mandatory\"}}
	{attend_poster_session_p:text(radio) 		{label \"Are you or your designate able to attend the STTP Student Poster Session on $poster_session_date?$reqd\"} {options \"$judge_options\"}}
	{expiration_date:text(hidden) {values $expiration_date}}
" -on_submit {
    set experience_required_p	"f"
    set skill_required_p	"f"
    set attend_poster_session_p	"t"
    db_transaction {
	set request_id [db_exec_plsql sttp_new {}]
    } on_error {
	set error_p 1
	db_abort_transaction
    }
    
    if {[exists_and_not_null error_p]} {
	ad_return_complaint 1 "<p>An error occurred while attempting to create the STTP Mentorship.</p><pre>$errmsg</pre>"
	ad_script_abort
    }
} -after_submit {
	if {![exists_and_not_null return_url]} {
		set return_url "sttp-mentor-detail?[export_vars {personnel_id request_id}]"
	}
	template::forward $return_url
} -select_query_name sttp_selection
