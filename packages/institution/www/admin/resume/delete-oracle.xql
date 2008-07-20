<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="resume">
	 <querytext>
		select	r.resume_id,
				r.personnel_id,
				r.resume_type_id,
				c.name							as resume_type_name,
				r.description,
				r.format,
				acs_object.name(r.personnel_id)	as owner_name,
				decode(acs_permission.permission_p(r.resume_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(r.resume_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(r.resume_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(r.resume_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(r.resume_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_personnel_resumes	r,
				categories				c
		 where	r.resume_id		= :resume_id
		   and	r.resume_type_id	= c.category_id
	 </querytext>
	</fullquery>

	<fullquery name="resume_delete">
	 <querytext>
		begin
			inst_personnel_resume.delete(:resume_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
