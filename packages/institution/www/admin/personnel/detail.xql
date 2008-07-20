<?xml version="1.0"?>
<queryset>
	<fullquery name="personnel_info">
	 <querytext>
		select	prsn.person_id,
				prsn.first_names,
				prsn.middle_name,
				prsn.last_name,
				psnl.preferred_first_name,
				psnl.preferred_middle_name,
				psnl.preferred_last_name,
				decode(psnl.gender, 'm', 'Male', 'f', 'Female') as gender,
				psnl.bio,
				psnl.date_of_birth,
				psnl.start_date,
				psnl.end_date,
				cs.name as status,
				psnl.notes,
				decode(phys.physician_id, null, 0, 1)	as physician_p,
				decode(fclt.faculty_id, null, 0, 1)		as faculty_p,
				decode(usr.user_id, null, 0, 1)			as user_p,
				prty.email								as user_login,
				to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(o.creation_date, 'hh:miam')		as created_at,
				person.name(o.creation_user)			as created_by,
				o.creation_ip							as created_from,
				to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(o.last_modified, 'hh:miam')		as modified_at,
				person.name(o.modifying_user)			as modified_by,
				o.modifying_ip							as modified_from
		  from	inst_personnel	psnl,
				inst_physicians	phys,
				inst_faculty	fclt,
				persons			prsn,
				parties			prty,
				users			usr,
				categories		cs,
				acs_objects		o
		 where	psnl.personnel_id	= :personnel_id
		   and	psnl.personnel_id	= prsn.person_id
		   and	psnl.personnel_id	= prty.party_id
		   and	psnl.status_id		= cs.category_id
		   and	psnl.personnel_id	= phys.physician_id (+)
		   and	psnl.personnel_id	= fclt.faculty_id (+)
		   and	psnl.personnel_id	= usr.user_id (+)
		   and	o.object_id			= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="titles">
	 <querytext>
		select	igpm.gpm_title_id,
				igpm.acs_rel_id,
				igpm.title_id,
				igpm.title_priority_number,
				igpm.pretty_title,
				ig.group_id,
				ig.group_type_id,
				ig.short_name						as group_name,
				gt.name								as group_type,
				acs_object.name(ar.object_id_two)	as personnel_name,
				t.name								as title,
				decode(o.context_id,
						inst_group.lookup('//UCLA//David Geffen School of Medicine at UCLA//Medical Group'),
						1, 0)						as from_morrissey_p,
				decode(acs_permission.permission_p(acs_rel_id, :user_id, 'write'),
						't', 1, 0)			write_p,
				decode(acs_permission.permission_p(acs_rel_id, :user_id, 'delete'),
						't', 1, 0)			delete_p,
				decode(acs_permission.permission_p(acs_rel_id, :user_id, 'admin'),
						't', 1, 0)			admin_p
		  from	inst_group_personnel_map	igpm,
				inst_groups					ig,
				acs_rels					ar,
				categories					t,
				categories					gt,
				acs_objects					o
		 where	ar.object_id_one	= ig.group_id
		   and	ar.object_id_two	= :personnel_id
		   and	ar.rel_id			= igpm.acs_rel_id
		   and	t.category_id		= igpm.title_id
		   and	gt.category_id		= ig.group_type_id
		   and	igpm.gpm_title_id	= o.object_id
		 order	by igpm.title_priority_number
	 </querytext>
	</fullquery>

	<fullquery name="morrissey_admin_p">
	 <querytext>
		select decode(
				acs_permission.permission_p(
				inst_group.lookup('//UCLA//David Geffen School of Medicine at UCLA//Medical Group'),
				:user_id,
				'admin'
				),
				't', 1, 0) as morrissey_admin_p
		  from	dual
	 </querytext>
	</fullquery>

	<fullquery name="personnel_languages">
	 <querytext>
		select	lc.name
		  from	inst_personnel_language_map	iplm,
				language_codes				lc
		 where	lc.language_id		= iplm.language_id
		   and	iplm.personnel_id	= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_addresses">
	 <querytext>
		select	pa.address_id
		  from	inst_party_addresses pa
		 where	pa.party_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_emails">
	 <querytext>
		select	pe.email_id
		  from	inst_party_emails pe
		 where	pe.party_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_urls">
	 <querytext>
		select	pu.url_id
		  from	inst_party_urls pu
		 where	pu.party_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_phones">
	 <querytext>
		select	pp.phone_id
		  from	inst_party_phones pp
		 where	pp.party_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_certifications">
	 <querytext>
		select	pc.certification_id
		  from	inst_certifications pc
		 where	pc.party_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_resumes">
	 <querytext>
		select	pr.resume_id
		  from	inst_personnel_resumes pr
		 where	pr.personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel_images">
	 <querytext>
		select	pi.image_id
		  from	inst_party_images pi
		 where	pi.party_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="sttp_info">
	  <querytext>
		select	description as sttp_description, request_id, expiration_date, sysdate as todays_date
		  from	inst_short_term_trnng_progs
		 where	personnel_id = :personnel_id
		 order by request_id
      </querytext>
   </fullquery>

	<fullquery name="sttp_ct_expire_date">
	  <querytext>
		select	count(*) as renew_flag
		  from	inst_short_term_trnng_progs
		 where	personnel_id = :personnel_id
		 and	expiration_date > sysdate
      </querytext>
   </fullquery>

	<fullquery name="personnel_publications">
	 <querytext>
		select	ip.authors || ', ' || 
				ip.title || ', <i>' || 
				ip.publication_name || '</i>' || 
				decode(ip.year,null,'',', ' ||ip.year) || 
				decode(ip.volume,null,'',', ' || ip.volume) || 
				decode(ip.issue,null,'',' (' || ip.issue || ')') || 
				decode(ip.page_ranges,null,'',', ' || ip.page_ranges) || '.' as publication,
				ip.publication_id,
				ip.url
		  from	inst_publications				ip,
				inst_personnel_publication_map	ippm
		 where	ippm.publication_id	= ip.publication_id
		   and	ippm.personnel_id	= :personnel_id
		 order	by publish_date desc, year desc, title
	 </querytext>
	</fullquery>

	<fullquery name="personnel_group_admin_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	acs_rels					ar
				  where	ar.object_id_two	= :personnel_id
					and	(acs_permission.permission_p(ar.object_id_one, :user_id, 'write') = 't'
						or acs_permission.permission_p(ar.object_id_one, :user_id, 'admin') = 't')
				)
	 </querytext>
	</fullquery>

	<fullquery name="user_is_group_admin_over_personnel_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	vw_group_member_map		gmm
				  where	gmm.child_id		= :personnel_id
					and	gmm.ancestor_id		= inst_group.lookup(:group_path)
					and	(acs_permission.permission_p(gmm.parent_id, :user_id, 'write') = 't'
						or acs_permission.permission_p(gmm.parent_id, :user_id, 'admin') = 't')
				)
	 </querytext>
	</fullquery>

	<fullquery name="external_physician_id">
	 <querytext>
		select	ucla_physician_id	as ext_physician_id
		  from	ext_physician_id_map
		 where	inst_physician_id	= :personnel_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
