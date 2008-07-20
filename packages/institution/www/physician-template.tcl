# -*- tab-width: 4 -*-
ad_page_contract {

	Displays Physician Specific Information

	@author             avni@avni.net (AK)
	@creation-date		2003/07/30
	@cvs-id	$Id: physician-template.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $

	@param	personnel_id	person to view
} {
	personnel_id:integer,notnull
}

set subsite_url [site_node_closest_ancestor_package_url]

# TODO Add in validation of physician
# Make sure personnel exists and personnel is a physician
db_1row inst_physician_info {
	select	acs_object.name(physician_id)				as physician_name,
			decode(accepting_patients_p,'t','Yes','No') as accepting_patients_p,
			decode(primary_care_physician_p, 't', 1, 0) as primary_care_physician_p,
			typical_patient
	  from	inst_physicians
	 where	physician_id = :personnel_id
}


