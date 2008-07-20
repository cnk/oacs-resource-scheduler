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
				cat.name								as certification_type_name,
				cat.name								as description,
				crt.certifying_party,
				crt.certification_credential,
				crt.start_date,
				crt.certification_date,
				crt.expiration_date,
				acs_object.name(crt.party_id)			as owner_name,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'read'),
						't', 1, 0)					as read_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'write'),
						't', 1, 0)					as write_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'create'),
						't', 1, 0)					as create_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'delete'),
						't', 1, 0)					as delete_p,
				decode(acs_permission.permission_p(crt.certification_id, :user_id, 'admin'),
						't', 1, 0)					as admin_p,
				to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
				to_char(o.creation_date, 'hh:miam')		as created_at,
				person.name(o.creation_user)			as created_by,
				o.creation_ip							as created_from,
				to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
				to_char(o.last_modified, 'hh:miam')		as modified_at,
				person.name(o.modifying_user)			as modified_by,
				o.modifying_ip							as modified_from
		  from	inst_certifications	crt,
				categories			cat,
				acs_objects			o
		 where	crt.certification_id		= :certification_id
		   and	crt.certification_type_id	= cat.category_id
		   and	crt.certification_id		= o.object_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
