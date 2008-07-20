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
				r.description,
				dbms_lob.getlength(content)		as content_length,
				acs_object.name(r.personnel_id) as owner_name,
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
		  from	inst_personnel_resumes r
		 where	r.resume_id = :resume_id
	 </querytext>
	</fullquery>

	<fullquery name="resume_name">
	 <querytext>
		select description
		  from inst_personnel_resumes
		 where resume_id = :resume_id
	 </querytext>
	</fullquery>

	<fullquery name="resume_new">
	 <querytext>
		begin
			:1 := inst_personnel_resume.new(
				owner_id			=> :personnel_id,
				type_id				=> :resume_type_id,
				description			=> :description,
				creation_user		=> :user_id,
				creation_ip			=> :peer_ip,
				context_id			=> :personnel_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="resume_edit">
	 <querytext>
			update	inst_personnel_resumes
			   set	personnel_id		= :personnel_id,
					resume_type_id		= :resume_type_id,
					description			= :description
			 where	resume_id			= :resume_id
	 </querytext>
	</fullquery>

	<fullquery name="resume_upload_blob">
	 <querytext>
			update	inst_personnel_resumes
			   set	content		= empty_blob(),
					format		= :format
			 where	resume_id	= :resume_id
			returning content into :1
	 </querytext>
	</fullquery>

	<fullquery name="modified">
	 <querytext>
			update	acs_objects
			   set	last_modified	= sysdate,
					modifying_user	= :user_id,
					modifying_ip	= :peer_ip
			 where	object_id		= :resume_id
	 </querytext>
	</fullquery>

	<fullquery name="resume_types">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id
		  from	categories
		 start	with parent_category_id = category.lookup('//Resume Type')
		connect	by	 prior category_id = parent_category_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
