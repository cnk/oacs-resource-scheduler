# -*- tab-width: 4 -*-
# ad_page_contract {
# 	Displays Personnel Information
#
# 	@author			avni@avni.net (AK)
# 	@author			helsleya@cs.ucr.edu (AH)
# 	@creation-date	2003/07/30
# 	@cvs-id			$Id: personnel-template2.tcl,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
#
# 	@param personnel_id	person to view
# } {
# 	{personnel_id:integer,notnull}
# 	{display_page	personnel}
# }

if [template::util::is_nil display_page]  {set display_page "personnel"}

set user_id		[ad_conn user_id]
set subsite_id	[ad_conn subsite_id]
set subsite_url [site_node_closest_ancestor_package_url]

set patient_care_p	[regexp -- /healthsciences/healthcare/ [ad_conn url]]

# Make sure personnel exists
if {![personnel::personnel_exists_p -personnel_id $personnel_id]} {
	ad_return_error "Error" "Personnel does not exist. The personnel ID passed to this page is invalid.
	Please contact your system administrator at <a href=mailto:[ad_host_administrator]>[ad_host_administrator]</a>
	if you have any questions. Thank you."
	return
}

# BASIC INFO ###################################################################
db_1row inst_personnel_info {
	select	p.first_names	as first_name,
			p.last_name		as last_name,
			degree_titles,
			trunc(months_between(sysdate,ip.date_of_birth) / 12) as age,
			decode(ip.gender,'m','Male','f','Female','') as gender,
			photo_width width,
			photo_height height,
			ip.bio
	  from	inst_personnel ip,
			persons p
	 where	ip.personnel_id = :personnel_id
	   and	p.person_id	 = ip.personnel_id
}

set physician_p [db_string physician_p {
	select count(physician_id)
	  from inst_physicians
	 where physician_id = :personnel_id
}]

# factor out expensive operations from the queries below by only looking up these constants once
db_1row relevant_categories {
	select	category.lookup('//Group Type//Hospital')								as hospital_category_id,
			category.lookup('//Certification Type//Medical Board Certification')	as med_brd_crt_category_id,
			category.lookup('//Certification Type//License')						as license_category_id,
			category.lookup('//Certification Type//Award')							as award_category_id,
			category.lookup('//Certification Type//Education//Medical Degree')		as med_degree_category_id,
			category.lookup('//Contact Information//Medical Practice')				as med_pract_category_id,
			category.lookup('//Specialty')											as specialty_category_id,
			category.lookup('//Field of Interest//Clinical Interest')				as clinical_interest_category_id
	  from	dual
}

# LANGUAGES ####################################################################
set language_info [join [db_list inst_personnel_language_info {
	select	lc.name
	  from	language_codes lc,
			inst_personnel_language_map iplm
	 where	lc.language_id		= iplm.language_id
	   and	iplm.personnel_id	= :personnel_id
	 order	by lc.name
}] ", "]

# WORK/TITLES ##################################################################
set title_filter {
	group_type_id	<> category.lookup('//Group Type//Private Group')
}
# Don't show membership titles on Healthcare subsites
if {[regexp {^/healthsciences/healthcare} $subsite_url]} {
	append title_filter {
		and gpm.title_id	<> category.lookup('//Personnel Title//Member')
	}
}

# EDUCATION/TRAINING/CERTIFICATIONS ############################################
db_multirow cert_info inst_personnel_certification_info {
	select	distinct
			c.name									as type_of_certification,
			ic.certifying_party,
			to_char(ic.start_date,'yyyy') || decode(ic.start_date,null,'',' - ') || to_char(ic.certification_date,'yyyy')	as certification_years,
			pc.name									as parent_type,
			pc.profiling_weight,
			decode(pc.category_id,
				   :med_brd_crt_category_id,
				   'Certifications: ',
				   :license_category_id,
				   'Certifications: ',
				   :award_category_id,
				   'Certifications: ',
				   'Education: ') as certification_affiliation_type
	  from	inst_certifications ic,
			categories c,
			categories pc
	 where	ic.party_id					= :personnel_id
	   and	ic.certification_type_id	= c.category_id
	   and	c.parent_category_id		= pc.category_id
	   and	c.enabled_p					= 't'
	   and	pc.enabled_p				= 't'
	 order	by	pc.profiling_weight,
				trim(to_char(ic.start_date,'yyyy') || decode(ic.start_date,null,'',' - ') || to_char(ic.certification_date,'yyyy')) desc
}

# CONTACT INFO #################################################################
db_multirow email_addrs inst_personnel_email_info {
	select	e.email,
			c.name as type
	  from	inst_party_emails e,
			categories c
	 where	e.party_id = :personnel_id
	   and	e.email_type_id = c.category_id
	   and	:physician_p = 0
	 order	by c.name,e.email
}

if {$physician_p == 0} {
	set accept_new_hmo_patients_p [db_string accepting_patients_p {
		select	accepting_patients_p
		  from	inst_physicians
		 where	physician_id = :personnel_id
	} -default "f"]
}

db_multirow -extend {format_phone_p} phones inst_personnel_phone_info {
	select	substr(p.phone_number, 1, 1)	country_code,
			substr(p.phone_number, 2, 3)	area_code,
			substr(p.phone_number, 5, 3)	prefix,
			substr(p.phone_number, 8, 4)	suffix,
			p.phone_number,
			c.name							as type,
			p.description,
			p.phone_priority_number,
			c.name as category_name
	  from	inst_party_phones	p,
			categories			c
	 where	p.party_id		= :personnel_id
	   and	p.phone_type_id	= c.category_id
	   and	acs_permission.permission_p(phone_id, :user_id, 'read') = 't'
	 order	by c.name, p.phone_number
} {
	set format_phone_p [regexp -- {^[0-9]+$} $phone_number]
	if {$format_phone_p && [string length $phone_number] < 11} {
		set format_phone_p 0
	}
}

db_multirow -extend {format_phone_p} indirect_phones inst_personnel_phone_info {
	select	distinct phn.phone_number,
			substr(phn.phone_number, 1, 1)	country_code,
			substr(phn.phone_number, 2, 3)	area_code,
			substr(phn.phone_number, 5, 3)	prefix,
			substr(phn.phone_number, 8, 4)	suffix,
			phn.phone_number,
			g.short_name					as type,
			phn.description,
			phn.phone_priority_number,
			phnc.name as category_name,
			gt.profiling_weight
	  from	inst_party_phones			phn,
			acs_rels					rel,
			categories					phnc,
			inst_groups					g,
			categories					gt
	 where	rel.rel_type		= 'membership_rel'
	   and	rel.object_id_one	= g.group_id
	   and	rel.object_id_one	= phn.party_id
	   and	rel.object_id_two	= :personnel_id
	   and	phn.phone_type_id	= phnc.category_id
	   and	g.group_type_id		= gt.category_id
	 order	by gt.profiling_weight,
			g.short_name,
			phn.phone_priority_number,
			phn.description,
			phn.phone_number
} {
	set format_phone_p [regexp -- {^[0-9]+$} $phone_number]
	if {$format_phone_p && [string length $phone_number] < 11} {
		set format_phone_p 0
	}
}

db_multirow addresses inst_personnel_address_info {
	select	a.description,
			a.address_line_1,
			a.address_line_2,
			a.address_line_3,
			a.address_line_4,
			a.address_line_5,
			decode(a.city,'','',a.city || ',') || ' ' || s.abbrev || ' ' || z.zipcode as citystate,
			co.default_name			as country,
			c.name					as type
	  from	inst_party_addresses	a,
			categories				c,
			us_states				s,
			us_zipcodes				z,
			countries				co
	 where	a.party_id			= :personnel_id
	   and	a.address_type_id	= c.category_id		(+)
	   and	a.fips_state_code	= s.fips_state_code	(+)
	   and	a.zipcode			= z.zipcode			(+)
	   and	a.fips_country_code	= co.iso			(+)
	   and	acs_permission.permission_p(address_id, :user_id, 'read') = 't'
	   and	(a.address_type_id = :med_pract_category_id
			 or :physician_p = 0)
	 order	by c.name
}

db_multirow url_info inst_personnel_url_info {
	select	u.url,
			c.name as type
	from	inst_party_urls u,
			categories c
	where	u.party_id		= :personnel_id
	and		u.url_type_id	= c.category_id
} {
	regsub -- {^(http(s)?://)?(.*)$} $url {http\2://\3} url
}

set contact_info_exists_p			[expr ${email_addrs:rowcount} + ${indirect_phones:rowcount} + ${addresses:rowcount} + $physician_p]
set direct_contact_info_exists_p	[expr ${phones:rowcount}]

# SPECIALTY INFO ###############################################################
db_multirow specialty inst_physician_specialty_info {
	select	c.name,
			pc.name					as parent
	  from	categories				c,
			categories				pc,
			inst_party_category_map	ipcm
	 where	c.category_id			= ipcm.category_id
	   and	ipcm.party_id			= :personnel_id
	   and	c.parent_category_id	= pc.category_id
	   and	pc.category_id			= :specialty_category_id
	 order	by pc.name, c.name
}

# AREA OF INTEREST #############################################################
db_multirow area_of_interest inst_physician_aoi_info {
	select	c.name,
			pc.name					as parent
	  from	categories				c,
			categories				pc,
			inst_party_category_map	ipcm
	 where	c.category_id			= ipcm.category_id
	   and	ipcm.party_id			= :personnel_id
	   and	c.parent_category_id	= pc.category_id
	   and	pc.category_id			= :clinical_interest_category_id
	 order	by pc.name, c.name
}

if {[ad_conn user_id] > 0 &&
	[permission::permission_p -object_id $personnel_id -privilege write] &&
	![permission::permission_p -object_id [acs_magic_object "security_context_root"] -privilege admin]} {
		set edit_url "admin/personnel/detail?[export_vars {personnel_id}]"
}

# RESEARCH INTEREST INFO #######################################################
set research_interest_info [inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default -subsite_id $subsite_id \
		-personnel_id $personnel_id -research_interest_type "lay"]
set research_interest_title [lindex $research_interest_info 0]
set research_interest [lindex $research_interest_info 1]

set technical_research_interest_info [inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default -subsite_id $subsite_id \
		-personnel_id $personnel_id -research_interest_type "technical"]
set technical_research_interest_title [lindex $technical_research_interest_info 0]
set technical_research_interest [lindex $technical_research_interest_info 1]

# END RESEARCH INTEREST INFO ###################################################
