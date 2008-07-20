# -*- tab-width: 4 -*-
ad_page_contract {
	Determines if Physician is Marketable or Not

	@author			avni@avni.net (AK)
	@author			helsleya@cs.ucr.edu (AH)

	@creation-date	2003/07/30
	@cvs-id			$Id: physician.tcl,v 1.2 2006/12/07 22:00:15 avni Exp $

	@param			personnel_id	person to view
} {
	personnel_id:integer,notnull
}

set subsite_url [site_node_closest_ancestor_package_url]

# //TODO// Add in validation of physician

# NOTE, Redirect when a physician is not active:
# The physician is no longer a member of the UCLA Medical Group,
# thus, for more information, have the person call UCLA.  This logic
# shows up in the query below.

# Make sure personnel exists and personnel is a physician
if {![db_0or1row physician {
	select	first_names,
			last_name,
			decode(gender, 'f', 'her', 'him')				gender,
			decode(status_id, category.lookup('//Personnel Status//Active'), 0, category.lookup('//Personnel Status//Accepting Patients'), 0,1) as redirect_p,
			decode(marketable_p, 'f', 0, 1)					marketable_p,
			decode(degree_titles,
					null, '',
					', ' || degree_titles)					as degree_titles
	  from	inst_physicians	phys,
			inst_personnel	psnl,
			persons			psns
	 where	physician_id	= :personnel_id
	   and	personnel_id	= physician_id
	   and	person_id		= physician_id
}]} {
	ad_return_complaint 1 "There is no physician with the requested ID."
	ad_script_abort
}
