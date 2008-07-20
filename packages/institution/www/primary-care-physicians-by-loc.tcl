# -*- tab-width: 4 -*-
ad_page_contract {
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2004/05/04
	@cvsid			$Id: primary-care-physicians-by-loc.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
} {
}

set subsite_url [site_node::get_url_from_object_id -object_id [ad_conn subsite_id]]
set title		"Primary Care Physicians"
set package_id	[ad_conn package_id]
set subsite_id	[ad_conn subsite_id]

set active		[personnel::get_status_id -name "Active"]
set physician_in_subsite_p	[subsite::parties_sql	-persons	\
													-party_id	\
														{phys.physician_id}]

db_1row categories {
	select	category.lookup('//Group Type//Primary Care Network Office')		as pco_group_type_category_id
	  from	dual
}

db_multirow -extend {detail_url} pcps primary_care_physicians "
	select	distinct physician_id,
			first_names,
			last_name,
			degree_titles,
			decode(gpm.status_id, null, 0, 1)				accepting_new_hmo_p,
			grp.short_name									group_name,
			grp.group_id,
			pgrp.group_id									location_id,
			pgrp.short_name									location_name
	  from	acs_objects					obj,
			persons						prsn,
			inst_personnel				psnl,
			inst_physicians				phys,
			inst_groups					grp,
			inst_groups					pgrp,
			inst_group_personnel_map	gpm,
			acs_rels					rels
	 where	phys.physician_id				= obj.object_id
	   and	phys.physician_id				= prsn.person_id
	   and	phys.physician_id				= psnl.personnel_id
	   and	phys.marketable_p				= 't'
	   and	phys.primary_care_physician_p	= 't'
	   and	psnl.status_id					= :active
	   and	rels.rel_id						= gpm.acs_rel_id
	   and	rels.object_id_one				= grp.group_id
	   and	rels.object_id_two				= phys.physician_id
	   and	rels.rel_type					= 'membership_rel'
	   and	grp.group_type_id				= :pco_group_type_category_id
	   and	grp.parent_group_id				= pgrp.group_id
	   and	$physician_in_subsite_p
	 order	by location_name, group_name, last_name, first_names
" {
	# create a link to their profile-page
	set detail_url "physician?[export_vars -override {{personnel_id $physician_id}}]"
}

# calculate number at which to wrap rows into another column
set rowcount_div_2 [expr (${pcps:rowcount} >> 1) + (${pcps:rowcount} & 1) + 1]
