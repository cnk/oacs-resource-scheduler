<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="resumes">
	 <querytext>
		select	distinct r.resume_id,
				nvl(r.description, '<i>(None)</i>')	as description,
				dbms_lob.getlength(content)	as content_length,
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
		 where	resume_id			in ($items)
		   and	acs_permission.permission_p(r.resume_id, :user_id, 'read') = 't'
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
