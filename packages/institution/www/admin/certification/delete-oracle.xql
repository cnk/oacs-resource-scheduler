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
				categories			cat
		 where	crt.certification_id		= :certification_id
		   and	crt.certification_type_id	= cat.category_id
	 </querytext>
	</fullquery>

	<fullquery name="certification_delete">
	 <querytext>
		begin
			inst_certification.delete(:certification_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
