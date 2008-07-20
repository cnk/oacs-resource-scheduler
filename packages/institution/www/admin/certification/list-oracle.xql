<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="certifications">
	 <querytext>
		select	distinct crt.certification_id,
				crt.party_id,
				cat.name as certification_type_name,
				crt.certifying_party,
				crt.certification_credential,
				crt.start_date,
				crt.certification_date,
				crt.expiration_date,
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
		  from	inst_certifications crt,
				categories			cat
		 where	crt.certification_id		in ($items)
		   and	crt.certification_type_id	= cat.category_id
		   and	acs_permission.permission_p(crt.certification_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
