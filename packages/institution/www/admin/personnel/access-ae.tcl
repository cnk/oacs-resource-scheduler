# -*- tab-width: 4 -*-
# /packages/institution/www/admin/personnel/access-ae.tcl
ad_page_contract {
	Add / Edit UCLA ACCESS Personnel Information

	@author			helsleya@cs.ucr.edu
	@creation-date	2004/01/10
	@cvs-id			$Id: access-ae.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param personnel_id
} {
	{personnel_id:integer,notnull}
}

set user_id		[ad_conn user_id]
set package_id	[ad_conn package_id]
set subsite_url	[site_node_closest_ancestor_package_url]

set personnel_exists_p	[db_0or1row personnel_exist {
	select	first_names,
			middle_name,
			last_name
	  from	persons
	 where	person_id = :personnel_id
}]
if {!$personnel_exists_p} {
	ad_return_error "Error" "There is no personnel with this ID. Please contact your <a href=mailto:[ad_host_administrator]>system administrator</a> if you have any questions."
	return
}

# checking permissions in here
permission::require_permission -object_id $personnel_id -privilege "write"

# Make sure personnel is a ACCESS personnel
set access_group_id			[db_string access_group_id {select inst_group.lookup('//ACCESS') from dual} -default 0]
set access_group_member_p	[group::member_p -user_id $personnel_id -group_id $access_group_id -cascade]
if {!$access_group_member_p} {
	ad_return_error "Error" "The personnel you selected is not a ACCESS Personnel.  You have reached this page in error.
	Please contact your system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a> if you
	have any questions. Thank you."
	return
}

set party_detail_url [subsite::party_admin_detail_url -party_id $personnel_id]

# Setup options for affinity groups and publications
set none					[list {[<i>None</i>]}]
set access_affinity_groups	[linsert [db_list_of_lists access_affinity_groups {}] 0 $none]
set publications			[linsert [db_list_of_lists personnel_publications {}] 0 $none]

set reqd					{<b style="color: red">*</b>}

set access_personnel_exists_p [db_string access_personnel_exists {
	select	count(*)
	  from	access_personnel
	 where	personnel_id = :personnel_id
}]

# This is the key to getting ad_form to correctly distinguish between 'new' and
#	'edit' behavior
if {$access_personnel_exists_p} {
	set access_personnel_id $personnel_id
}

set context_bar [ad_context_bar_html [list [list [set subsite_url] "Main Site"] \
	[list [ad_conn package_url] "Faculty Editor"] \
	[list [set subsite_url]institution/personnel/ "Personnel Index"] \
	"Edit ACCESS Personnel Information"]]

set page_title "Edit ACCESS Personnel Information for $first_names $last_name"
set personnel_error 0

ad_form -name access_ae -export {personnel_id} -select_query_name access_personnel_details -form {
	access_personnel_id:key
	{affinity_group_id_1:integer(select)						{label "Primary Affinity:$reqd"}
		{options $access_affinity_groups}}
	{affinity_group_id_2:integer(select),optional				{label "Secondary Affinity (Optional):"}
		{options $access_affinity_groups}}
	{selected_pblctn_for_guide_id_1:integer(select),optional	{label "First"}
		{options $publications}
		{section "<br>Select as many as 3 publications to be published in the ACCESS brochure:"}}
	{selected_pblctn_for_guide_id_2:integer(select),optional	{label "Second"}
		{options $publications}}
	{selected_pblctn_for_guide_id_3:integer(select),optional	{label "Third"}
		{options $publications}}
	{submit:text(submit)										{label "Save Changes & Return"}}
} -new_request {
	# Get their ACCESS affinity_group membership (from acs_rels) and set it up
	#	as the default affinity_group_id_1
	set affinity_group_id_1 [db_string access_membership_group_id {
		select	parent_id
		  from	vw_group_member_map	gmm,
				acs_rels			rel
		 where	gmm.ancestor_id	= inst_group.lookup('//ACCESS//ACCESS Research Affinity Groups')
		   and	gmm.child_id	= :personnel_id
		   and	gmm.rel_id		= rel.rel_id
		   and	rel.object_id_one	= gmm.parent_id
		   and	rel.object_id_two	= :personnel_id
		   and	rel.rel_type		= 'membership_rel'
	} -default ""]

	# Get a list of their publications, use the 3 most recent as default selected
	db_multirow publications personnel_publications {} {
		set one_based_rownum [expr ${publications:rowcount} + 1]
		if {$one_based_rownum <= 3} {
			set selected_pblctn_for_guide_id_$one_based_rownum $publication_id
		} else {
			break
		}
	}
} -new_data {
	set personnel_error 0
	db_transaction {
		db_dml access_personnel_add {}

		# if membership doesn't match up, delete and/or insert a membership rel
		#	as necessary
		db_exec_plsql synchronize_access_affinity_group_membership {}
	} on_error {
		set personnel_error 1
		db_abort_transaction
	}

	if {$personnel_error} {
		ad_return_error "Error" "There was an error updating the ACCESS Personnel Information.<p> $errmsg"
		return
	}
} -edit_data {
	set personnel_error 0
	db_transaction {
		db_dml access_personnel_edit {}

		# if membership doesn't match up, delete and/or insert a membership rel
		#	as necessary
		db_exec_plsql synchronize_access_affinity_group_membership {}
	}
} -after_submit {
	template::forward "detail?[export_vars {personnel_id}]"
}

