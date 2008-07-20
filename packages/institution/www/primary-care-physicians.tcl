# -*- tab-width: 4 -*-
ad_page_contract {
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2004/03/30
	@cvsid			$Id: primary-care-physicians.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
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

db_multirow -extend {detail_url} pcps primary_care_physicians "
	select	physician_id,
			first_names,
			last_name,
			degree_titles,
			spc.name										as specialty,
			decode(phys.accepting_patients_p, 'f', 0, 1)	accepting_new_hmo_p
	  from	acs_objects				obj,
			persons					prsn,
			inst_personnel			psnl,
			inst_physicians			phys,
			inst_party_category_map	pcm,
			categories				spc
	 where	phys.physician_id				= obj.object_id
	   and	phys.physician_id				= prsn.person_id
	   and	phys.physician_id				= psnl.personnel_id
	   and	phys.physician_id				= pcm.party_id
	   and	pcm.category_id					= spc.category_id
	   and	spc.category_id			in (
				category.lookup('//Specialty//Family Practice'),
				category.lookup('//Specialty//Internal Medicine'),
				category.lookup('//Specialty//Pediatrics General')
			)
	   and	phys.marketable_p				= 't'
	   and	psnl.status_id					= :active
	   and	phys.primary_care_physician_p	= 't'
	   and	$physician_in_subsite_p
	 order	by spc.name, last_name, first_names, physician_id
" {
	# create a link to their profile-page
	set detail_url "physician?[export_vars -override {{personnel_id $physician_id}}]"
}

# calculate number at which to wrap rows into another column
set rowcount_div_2 [expr (${pcps:rowcount} >> 1) + (${pcps:rowcount} & 1) + 1]
