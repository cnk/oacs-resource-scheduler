<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="group_detail">
	 <querytext>
		select	i.group_id,
				i.parent_group_id,
				g.group_name		as name,
				i.short_name,
				i.description,
				i.keywords,
				p.short_name		as parent_name,
				pt.name				as parent_group_type,
				c.name				as group_type,
				c.description		as group_type_description
		  from	inst_groups	i,
				inst_groups	p,
				groups		g,
				categories	c,
				categories	pt
		 where	i.group_id			= g.group_id
		   and	i.group_type_id		= c.category_id
		   and	i.parent_group_id	= p.group_id (+)
		   and	p.group_type_id		= pt.category_id(+)
		   and	i.group_id			= :group_id
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
				ipa.zipcode_ext,
				fips_country_code
		  from	inst_party_addresses	ipa,
				categories				c,
				us_states				uss
		 where	party_id			= :group_id
		   and	ipa.address_type_id	= c.category_id
		   and	ipa.fips_state_code	= uss.fips_state_code (+)
		   and	enabled_p			= 't'
		 order	by
				fips_country_code,
				zipcode,
				zipcode_ext,
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

	<partialquery name="group_phones_filter">
	 <querytext>
		   and	(instr(lower(ipp.description), 'info') > 0			or
				 instr(lower(ipp.description), 'refer') > 0			or
				 instr(lower(ipp.description), 'appointment') > 0	)
	 </querytext>
	</partialquery>

	<fullquery name="group_leaders">
	 <querytext>
		-- only show directly employed personnel by querying against acs_rels
		select	psnl.personnel_id,
				p.first_names,
				p.last_name,
				c.name title,
				decode(gpm.leader_p, 't', 1, 0) leader_p
		  from	inst_group_personnel_map	gpm,
				persons						p,
				inst_personnel				psnl,
				categories					c,
				acs_rels					rel
		 where	gpm.acs_rel_id		= rel.rel_id
		   and	rel.rel_type		= 'membership_rel'
		   and	rel.object_id_one	= :group_id
		   and	rel.object_id_two	= p.person_id
		   and	p.person_id			= psnl.personnel_id
		   and	gpm.title_id		= c.category_id
		   and	gpm.leader_p		= 't'
		   and	$subsite_personnel_p
		order	by title, last_name, first_names
	 </querytext>
	</fullquery>

	<fullquery name="group_personnel">
	 <querytext>
		-- Only show directly employed personnel by querying against acs_rels.
		-- Second half is almost exactly the same as the first, except it retrieves
		-- physicians who have no specialty data but are otherwise marketable and
		-- active.
		select	personnel_id,
				first_names,
				last_name,
				medical_specialty,
				leader_p,
				pcp_p,
				accepting_new_hmo_p,
				accepting_p,
				title_id,
				title_singular,
				title_plural
		  from (select	p.person_id										personnel_id,
						p.first_names									first_names,
						p.last_name										last_name,
						md_spclts.category_id							specialty_id,
						md_spclts.name									medical_specialty,
						decode(igpm.leader_p, 't', 1, 0)				leader_p,
						decode(iphys.primary_care_physician_p, 't', 1, 0)		pcp_p,
						decode(iphys.accepting_patients_p, 't', 1, 0)	accepting_new_hmo_p,
						decode(igpm.status_id, null, 0, 1)				accepting_p,
						titles.category_id								title_id,
						titles.name										title_singular,
						titles.plural									title_plural,
						titles.profiling_weight							title_ordering
				  from	inst_group_personnel_map	igpm,
						persons						p,
						inst_personnel				ip,
						inst_physicians				iphys,
						inst_party_category_map		ipcm,
						categories					md_spclts,
						categories					titles,
						acs_rels					r,
						inst_groups					g --,
				--		ext_physician_group_map		epgm
				 where	titles.category_id				= igpm.title_id
				   and	igpm.acs_rel_id					= r.rel_id
				   and	r.rel_type						= 'membership_rel'
				   and	r.object_id_one					= :group_id
				   and	r.object_id_two					= p.person_id
				   and	p.person_id						= iphys.physician_id
				   and	p.person_id						= ip.personnel_id
				   and	p.person_id						= ipcm.party_id
				   and	ipcm.category_id				= md_spclts.category_id
				   and	md_spclts.parent_category_id	= category.lookup('//Specialty')
				   and	$physician_filter
				   and	$subsite_personnel_p
				   and	ip.status_id					= category.lookup('//Personnel Status//Active')
				   --and	igpm.gpm_title_id				= epgm.inst_gpm_title_id
				   --and	r.rel_id						= epgm.acs_rel_id $epgm_join_type
				   --and	nvl(epgm.acs_rel_id, -1)	=
					--		decode(	g.group_type_id,
					--				category.lookup('//Group Type//Primary Care Network Office'),
					--				-1,
					--				epgm.acs_rel_id)
				   and	r.object_id_one					= g.group_id
				   and	(instr(lower(titles.name), 'physician')		> 0
						or instr(lower(titles.name), 'surgeon')		> 0
						or (instr(lower(titles.name), 'chair')		> 0
							and g.group_type_id in (41446, 819, 44914))	-- Group is a Department
						or ((instr(lower(titles.name), 'chief')		> 0
							or instr(lower(titles.name), 'director')	> 0)
							and g.group_type_id = 820)					-- Group is a Division
						or (instr(lower(titles.name), 'director')	> 0
							and g.group_type_id = 821)					-- Group is a Program
						)
				union
				select	p.person_id										personnel_id,
						p.first_names									first_names,
						p.last_name										last_name,
						-1												specialty_id,
						''												medical_specialty,
						decode(igpm.leader_p, 't', 1, 0)	leader_p,
						decode(iphys.primary_care_physician_p, 't', 1, 0)		pcp_p,
						decode(iphys.accepting_patients_p, 't', 1, 0)	accepting_new_hmo_p,
						decode(igpm.status_id, null, 0, 1)				accepting_p,
						titles.category_id								title_id,
						titles.name										title_singular,
						titles.plural									title_plural,
						titles.profiling_weight							title_ordering
				  from	inst_group_personnel_map	igpm,
						persons						p,
						inst_personnel				ip,
						inst_physicians				iphys,
						categories					titles,
						acs_rels					r,
						inst_groups					g --,
				--		ext_physician_group_map		epgm
				 where	titles.category_id				= igpm.title_id
				   and	igpm.acs_rel_id					= r.rel_id
				   and	r.rel_type						= 'membership_rel'
				   and	r.object_id_one					= :group_id
				   and	r.object_id_two					= p.person_id
				   and	p.person_id						= ip.personnel_id
				   and	p.person_id						= iphys.physician_id
				   and	ip.status_id					= category.lookup('//Personnel Status//Active')
				   and	not exists
						(select	1
						   from	inst_party_category_map	ipcm,
								categories				mds
						  where	ipcm.category_id		= mds.category_id
							and	ipcm.party_id			= personnel_id
							and	mds.parent_category_id	= category.lookup('//Specialty'))
				   and	$physician_filter
				   and	$subsite_personnel_p
				   and	r.object_id_one				= g.group_id
				   --and	igpm.gpm_title_id				= epgm.inst_gpm_title_id
				   --and	r.rel_id					= epgm.acs_rel_id $epgm_join_type
				   --and	nvl(epgm.acs_rel_id, -1)	=
					--		decode(	g.group_type_id,
					--				category.lookup('//Group Type//Primary Care Network Office'),
					--				-1,
					--				epgm.acs_rel_id)
				   and	(instr(lower(titles.name), 'physician')		> 0
						or instr(lower(titles.name), 'surgeon')		> 0
						or (instr(lower(titles.name), 'chair')		> 0
							and g.group_type_id in (41446, 819, 44914))	-- Group is a Department
						or ((instr(lower(titles.name), 'chief')		> 0
							or instr(lower(titles.name), 'director')	> 0)
							and g.group_type_id = 820)					-- Group is a Division
						or (instr(lower(titles.name), 'director')	> 0
							and g.group_type_id = 821)					-- Group is a Program
						)
				)
		order	by	title_ordering, title_singular, last_name, first_names, personnel_id, medical_specialty
	 </querytext>
	</fullquery>

	<fullquery name="group_vital_signs_articles">
	 <querytext>
		select	distinct vsa.title			as article_title,
				vsa.release_date,
				vsa.article_id
		  from	inst_party_category_map		ipcm,
				categories					pc,
				categories					c,
				vital_signs_medical_service	vsms,
				vital_signs_topic_mapping	vstm,
				vital_signs_articles		vsa
		 where	ipcm.category_id			= c.category_id
		   and	c.parent_category_id		= pc.category_id
		   and	ipcm.party_id				= :group_id
		   and	lower(pc.name)				= 'specialty'
		   and	vsms.specialty_id			= c.category_id
		   and	vsms.topic_id				= vstm.topic_id
		   and	vstm.article_id				= vsa.article_id
		 order	by	vsa.release_date desc,
					vsa.title
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
