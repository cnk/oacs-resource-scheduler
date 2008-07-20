# -*- tab-width: 4 -*-
ad_page_contract {
	Displays Personnel Information

	@author			avni@avni.net (AK)
	@author			helsleya@cs.ucr.edu (AH)
	@creation-date	2003/07/30
	@cvs-id			$Id: personnel-template.tcl,v 1.1.1.1 2006/09/13 01:29:59 nsadmin Exp $

	@param personnel_id	person to view
} {
	personnel_id:integer,notnull
}

# TODO
# Make sure personnel exists

# BASIC INFO ###################################################################
db_1row inst_personnel_info {
	select	p.first_names as first_name,
			p.last_name   as last_name,
			trunc(months_between(sysdate,ip.date_of_birth) / 12) as age,
			decode(ip.gender,'m','Male','f','Female','') as gender,
			photo_width width,
			photo_height height,
			ip.bio
	from	inst_personnel ip,
			persons p
	where	ip.personnel_id = :personnel_id
	and		p.person_id	 = ip.personnel_id
}

set physician_p [db_string physician_p {
	select count(physician_id)
	  from inst_physicians
	 where physician_id = :personnel_id
}]

# LANGUAGES ####################################################################
set language_info [join [db_list inst_personnel_language_info {
	select	lc.name
	from	language_codes lc,
			inst_personnel_language_map iplm
	where	lc.language_id = iplm.language_id
	and		iplm.personnel_id = :personnel_id
	order	by lc.name
}] ", "]

# WORK/TITLES ##################################################################
db_multirow position_info inst_personnel_position_info {
	select	g.group_id,
			pc.name as position,
			g.short_name as department,
			igpm.primary_title_p,
			igpm.leader_p,
	        decode(gc.category_id,category.lookup('//Group Type//Hospital'),'Hospital Affiliations: ','Department / Division Affiliations: ') as group_affiliation_type,
	        decode(gc.category_id,category.lookup('//Group Type//Hospital'),1,0) as hospital_p
	from	acs_rels ar,
			inst_group_personnel_map igpm,
			categories pc,
			categories gc,
			inst_groups g
	where	ar.object_id_two = :personnel_id
	and		ar.object_id_one = g.group_id
	and		ar.rel_id		= igpm.acs_rel_id
	and		igpm.title_id	= pc.category_id
	and		g.group_type_id	= gc.category_id
	order	by gc.profiling_weight asc, igpm.primary_title_p desc, pc.name, g.short_name
}

# EDUCATION/CERTIFICATIONS #####################################################
db_multirow cert_info inst_personnel_certification_info {
	select	c.name || ', ' || ic.certifying_party || ', ' || to_char(ic.certification_date,'yyyy') as certification,
			pc.name as parent,
			pc.profiling_weight,
			ic.certifying_party,
			ic.certification_date,
	        decode(pc.category_id,category.lookup('//Certification Type//Medical Board Certification'),'Certifications: ',category.lookup('//Certification Type//License'),'Certifications: ',category.lookup('//Certification Type//Award'),'Certifications: ','Education: ') as certification_affiliation_type
	from	inst_certifications ic,
			categories c,
			categories pc
	where	ic.party_id = :personnel_id
	and		ic.certification_type_id	= c.category_id
	and		c.parent_category_id		= pc.category_id
	and		c.enabled_p					= 't'
	and		pc.enabled_p				= 't'
	order	by  pc.profiling_weight desc,
	            ic.certification_date desc
}

set medical_degree_titles [join [db_list medical_degree_titles {
	select	cats.name
	  from	categories cats, inst_certifications crts
	 where	cats.category_id		= crts.certification_type_id
	   and	cats.parent_category_id	= category.lookup('//Certification Type//Education//Medical Degree')
	   and	crts.party_id			= :personnel_id
	 order	by cats.profiling_weight, cats.name
}] " "]

# CONTACT INFO #################################################################
db_multirow email_addrs inst_personnel_email_info {
	select	e.email,
			c.name as type
	from	inst_party_emails e,
			categories c
	where	e.party_id = :personnel_id
	and		e.email_type_id = c.category_id
	and		:physician_p = 0
	order	by c.name,e.email
}

if {$physician_p == 0} {
	db_multirow phones inst_personnel_phone_info {
		select	substr(p.phone_number, 1, 1) country_code,
				substr(p.phone_number, 2, 3) area_code,
				substr(p.phone_number, 5, 3) prefix,
				substr(p.phone_number, 8, 4) suffix,
				c.name as type
		from	inst_party_phones p,
				categories c
		where	p.party_id = :personnel_id
		and		p.phone_type_id = c.category_id
		order  by c.name,p.phone_number
	}
} else {
	db_multirow phones inst_personnel_phone_info {
		select	substr(phn.phone_number, 1, 1) country_code,
				substr(phn.phone_number, 2, 3) area_code,
				substr(phn.phone_number, 5, 3) prefix,
				substr(phn.phone_number, 8, 4) suffix,
				g.short_name as type
		from	inst_party_phones			phn,
				acs_rels					rel,
				categories					phnc,
				inst_groups					g
		where	rel.rel_type		= 'membership_rel'
		  and	rel.object_id_one	= g.group_id
		  and	rel.object_id_one	= phn.party_id
		  and	rel.object_id_two	= :personnel_id
		  and	phn.phone_type_id	= phnc.category_id
		order  by phnc.name, phn.phone_number
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
			co.default_name as country,
			c.name as type
	from	inst_party_addresses a,
			categories c,
			us_states s,
			us_zipcodes z,
			countries co
	where	a.party_id = :personnel_id
	and		a.fips_state_code = s.fips_state_code
	and		a.zipcode = z.zipcode
	and		a.fips_country_code = co.iso
	and		a.address_type_id = c.category_id
	and		(a.address_type_id = category.lookup('//Contact Information//Medical Practice')
			 or :physician_p = 0)
	order  by c.name
}

db_multirow url_info inst_personnel_url_info {
	select	u.url,
			c.name as type
	from	inst_party_urls u,
			categories c
	where	u.party_id = :personnel_id
	and		u.url_type_id = c.category_id
	and		(u.url_type_id = category.lookup('//Contact Information//Medical Practice')
			 or :physician_p = 0)
}

set contact_info_exists_p [expr ${email_addrs:rowcount} + ${phones:rowcount} + ${addresses:rowcount} + $physician_p]

