<?xml version="1.0"?>
<queryset>
	<fullquery name="group_detail">
	 <querytext>
		select	i.group_id,
				i.parent_group_id,
				g.group_name		name,
				i.short_name,
				i.description,
				i.keywords,
				p.short_name		parent_name,
				c.name				group_type,
				c.description		group_type_description
		  from	inst_groups	i,
				inst_groups	p,
				groups		g,
				categories	c
		 where	i.group_id			= g.group_id
		   and	i.group_type_id		= category_id
		   and	i.parent_group_id	= p.group_id (+)
		   and	i.group_id			= :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_children">
	 <querytext>
		select	group_id
		  from	inst_groups
		 where	parent_group_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="group_children_count">
	 <querytext>
		select	count(*)
		  from	inst_groups
		 where	parent_group_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="subgroup_types">
	 <querytext>
		select distinct name group_type
		  from categories
		 where category_id in
				(select group_type_id
				   from inst_groups
				 where parent_group_id = :group_id)
	 </querytext>
	</fullquery>

	<fullquery name="group_cat_info">
	 <querytext>
		select	pc.name parent_name, c.name name
		  from	inst_party_category_map ipcm, categories pc, categories c
		 where	ipcm.category_id		= c.category_id
		   and	c.parent_category_id	= pc.category_id
		   and	ipcm.party_id			= :group_id
		 order	by pc.category_id, c.name
	 </querytext>
	</fullquery>

	<fullquery name="group_addresses">
	 <querytext>
		select	distinct
				ipa.description,
				ipa.room_number,
				ipa.building_name,
				ipa.address_line_1,
				ipa.address_line_2,
				ipa.address_line_3,
				ipa.address_line_4,
				ipa.address_line_5,
				ipa.city,
				uss.abbrev,
				ipa.zipcode,
				fips_country_code
		  from	inst_party_addresses ipa, categories c, us_states uss
		 where	party_id = :group_id
		   and	ipa.address_type_id	= c.category_id
		   and	ipa.fips_state_code	= uss.fips_state_code (+)
		   and	enabled_p = 't'
		 order	by
				fips_country_code,
				zipcode,
				abbrev,
				city,
				address_line_5,
				address_line_4,
				address_line_3,
				address_line_2,
				address_line_1,
				building_name,
				room_number
	 </querytext>
	</fullquery>

	<fullquery name="group_phone">
	 <querytext>
		select	ipp.phone_number,
				c.name,
				ipp.description					descript,
				ipp.phone_number as num
		  from	inst_party_phones	ipp,
				categories			c
		 where	party_id		= :group_id
		   and	phone_type_id	= category_id
		   and	enabled_p		= 't'
		 order	by phone_type_id,
				profiling_weight,
				phone_number
	 </querytext>
	</fullquery>

	<fullquery name="group_urls">
	 <querytext>
		select	u.*, c.*,
				nvl(u.description, u.url) as name
		  from	inst_party_urls	u,
				categories		c
		 where	party_id	= :group_id
		   and	url_type_id	= category_id
		   and	enabled_p	= 't'
		 order	by url_type_id,
				profiling_weight,
				url
	 </querytext>
	</fullquery>

	<fullquery name="group_emails">
	 <querytext>
		select	*
		  from	inst_party_emails, categories
		 where	party_id = :group_id
		   and	email_type_id = category_id
		   and	enabled_p = 't'
		 order	by email_type_id,
				profiling_weight,
				email
	 </querytext>
	</fullquery>

	<fullquery name="group_certifications">
	 <querytext>
		select	*
		  from	inst_certifications, categories
		 where	party_id = :group_id
		   and	certification_type_id = category_id
		   and	enabled_p = 't'
		 order	by certification_type_id,
				profiling_weight,
				certifying_party,
				certification_credential
	 </querytext>
	</fullquery>

	<fullquery name="subsite_roots_exist_p">
	 <querytext>
		select	count(object_id_two)
		  from	acs_rels
		 where	rel_type = 'subsite_for_party_rel'
		   and	object_id_one = :subsite_id
	 </querytext>
	</fullquery>

	<fullquery name="subsite_personnel">
	 <querytext>
		select	distinct object_id_two
		  from	acs_rels
		 where	rel_type = 'membership_rel'
		   and	object_id_one in (
					select	distinct object_id_two
					  from	acs_rels
					 where	rel_type = 'subsite_for_party_rel'
					   and	object_id_one = :subsite_id
				)
	 </querytext>
	</fullquery>

	<fullquery name="all_personnel">
	 <querytext>
		select	distinct personnel_id
		  from	inst_personnel
		 where	status_id = :active
	 </querytext>
	</fullquery>

	<fullquery name="group_leaders">
	 <querytext>
		-- only show directly employed personnel by querying against acs_rels
		select	ip.personnel_id,
				p.first_names,
				p.last_name,
				c.name title,
				--decode(primary_title_p, 't', 1, 0) primary_p,
				decode(leader_p, 't', 1, 0) leader_p
		  from	inst_group_personnel_map	igpm,
				persons						p,
				inst_personnel				ip,
				categories					c,
				acs_rels					ar
		 where	acs_rel_id		= rel_id
		   and	rel_type		= 'membership_rel'
		   and	object_id_one	= :group_id
		   and	object_id_two	= person_id
		   and	person_id		= personnel_id
		   and	leader_p		= 't'
		   and	person_id		in ($subsite_personnel)
		order	by title, last_name, first_names
	 </querytext>
	</fullquery>

	<fullquery name="group_personnel">
	 <querytext>
		-- Only show directly employed personnel by querying against acs_rels.
		-- Second half is almost exactly the same as the first, except it retrieves
		-- physicians who have no specialty data but are otherwise marketable and
		-- active.
		select	p.person_id					personnel_id,
				p.first_names				first_names,
				p.last_name					last_name,
				titles.name					personnel_title,
				md_spclts.name				medical_specialty,
				decode(leader_p, 't', 1, 0)	leader_p,
				decode(primary_care_physician_p, 'f', 0, 1)		pcp_p,
				decode((sysdate - igpm.end_date) -
						abs(sysdate - igpm.end_date), 0, 0, 1)	accepting_p
		  from	inst_group_personnel_map	igpm,
				persons						p,
				inst_personnel				ip,
				inst_physicians				iphys,
				inst_party_category_map		ipcm,
				categories					md_spclts,
				categories					titles,
				acs_rels					rels
		 where	titles.category_id				= igpm.title_id
		   and	igpm.acs_rel_id					= rel_id
		   and	rels.rel_type					= 'membership_rel'
		   and	rels.object_id_one				= :group_id
		   and	rels.object_id_two				= p.person_id
		   and	p.person_id						= iphys.physician_id
		   and	p.person_id						= ip.personnel_id
		   and	p.person_id						= ipcm.party_id
		   and	ipcm.category_id				= md_spclts.category_id
		   and	md_spclts.parent_category_id	= category.lookup('//Specialty')
		   and	p.person_id						in ($subsite_personnel)
		union
		select	p.person_id					personnel_id,
				p.first_names				first_names,
				p.last_name					last_name,
				titles.name					personnel_title,
				''							medical_specialty,
				decode(leader_p, 't', 1, 0)	leader_p,
				decode(primary_care_physician_p, 'f', 0, 1)		pcp_p,
				decode((sysdate - igpm.end_date) -
						abs(sysdate - igpm.end_date), 0, 0, 1)	accepting_p
		  from	inst_group_personnel_map	igpm,
				persons						p,
				inst_personnel				ip,
				inst_physicians				iphys,
				categories					titles,
				acs_rels					rels
		 where	titles.category_id				= igpm.title_id
		   and	igpm.acs_rel_id					= rel_id
		   and	rels.rel_type					= 'membership_rel'
		   and	rels.object_id_one				= :group_id
		   and	rels.object_id_two				= p.person_id
		   and	p.person_id						= ip.personnel_id
		   and	p.person_id						= iphys.physician_id
		   and	not exists
				(select	1
				   from	inst_party_category_map	ipcm,
						categories				mds
				  where	ipcm.category_id		= mds.category_id
					and	ipcm.party_id			= personnel_id
					and	mds.parent_category_id	= category.lookup('//Specialty'))
		   and	p.person_id						in ($subsite_personnel)
		order	by medical_specialty, last_name, first_names, personnel_id, personnel_title
	 </querytext>
	</fullquery>


</queryset>

