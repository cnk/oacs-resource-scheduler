<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="certification">
	 <querytext>
		select	crt.certification_id,
				crt.party_id,
				crt.certification_type_id,
				cat.name						as certification_type_name,
				cat.name						as description,
				crt.certifying_party,
				crt.certification_credential,
				crt.start_date,
				crt.certification_date,
				crt.expiration_date,
				decode(phys.physician_id, null, 0, 1)	as physician_p,
				acs_object.name(crt.party_id)	as owner_name,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_certifications	crt,
				categories			cat,
				inst_physicians		phys
		 where	crt.certification_id		= :certification_id
		   and	crt.certification_type_id	= cat.category_id
		   and	crt.party_id				= phys.physician_id (+)
	 </querytext>
	</fullquery>

	<fullquery name="certification_name">
	 <querytext>
		select certification_credential
		  from inst_certifications
		 where certification_id = :certification_id
	 </querytext>
	</fullquery>

	<fullquery name="certification_new">
	 <querytext>
		begin
			:1 := inst_certification.new(
				owner_id			=> :party_id,
				type_id				=> :certification_type_id,
				party				=> :certifying_party,
				credential			=> :certification_credential,
				start_date			=> :start_date,
				certification_date	=> :certification_date,
				expiration_date		=> :expiration_date,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :party_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="certification_edit">
	 <querytext>
			update	inst_certifications
			   set	party_id			= :party_id,
					certification_type_id		= :certification_type_id,
					certifying_party			= :certifying_party,
					certification_credential	= :certification_credential,
					start_date					= :start_date,
					certification_date			= :certification_date,
					expiration_date				= :expiration_date
			 where	certification_id			= :certification_id
	 </querytext>
	</fullquery>


	<fullquery name="modified">
	 <querytext>
			update	acs_objects
			   set	last_modified	= sysdate,
					modifying_user	= :user_id,
					modifying_ip	= :peer_ip
			 where	object_id		= :certification_id
	 </querytext>
	</fullquery>

	<fullquery name="certification_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		start	with parent_category_id = category.lookup('//Certification Type')
		connect	by prior category_id = parent_category_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
