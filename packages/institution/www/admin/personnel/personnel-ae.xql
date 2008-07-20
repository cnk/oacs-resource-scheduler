<?xml version="1.0"?>
<queryset>
	<fullquery name="institution_admin_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
				(select	1
				   from	inst_groups
				  where	acs_permission.permission_p(group_id, :user_id, 'admin') = 't')
	 </querytext>
	</fullquery>

	<fullquery name="personnel_info">
	 <querytext>
		select	psn.first_names,
				psn.middle_name,
				psn.last_name,
				acs_object.name(psnl.personnel_id) as personnel_name,
				psnl.preferred_first_name,
				psnl.preferred_middle_name,
				psnl.preferred_last_name,
				psnl.gender,
				psnl.bio,
				to_char(psnl.date_of_birth, 'YYYY MM DD')	as date_of_birth,
				psnl.employee_number,
				psnl.status_id,
				to_char(psnl.start_date, 'YYYY MM DD')		as start_date,
				to_char(psnl.end_date, 'YYYY MM DD')		as end_date,
				psnl.notes,
				psnl.meta_keywords,
				psnl.degree_titles,
				sign(dbms_lob.getlength(psnl.photo))		as photo_p,
				decode(fac.faculty_id, null, 'f', 't')		as faculty_p,
				decode(phys.physician_id, null, 0, 1)		as personnel_is_physician_p,
				decode(acs_permission.permission_p(psnl.personnel_id, :user_id, 'read'),
						't', 1, 0) read_p,
				decode(acs_permission.permission_p(psnl.personnel_id, :user_id, 'write'),
						't', 1, 0) write_p,
				decode(acs_permission.permission_p(psnl.personnel_id, :user_id, 'create'),
						't', 1, 0) create_p,
				decode(acs_permission.permission_p(psnl.personnel_id, :user_id, 'delete'),
						't', 1, 0) delete_p,
				decode(acs_permission.permission_p(psnl.personnel_id, :user_id, 'admin'),
						't', 1, 0) admin_p
		  from	inst_personnel	psnl,
				persons			psn,
				inst_faculty	fac,
				inst_physicians	phys
		 where	psnl.personnel_id	= psn.person_id
		   and	psnl.personnel_id	= :personnel_id
		   and	psnl.personnel_id	= fac.faculty_id(+)
		   and  psnl.personnel_id	= phys.physician_id(+)
	 </querytext>
	</fullquery>

	<fullquery name="get_group_name">
	 <querytext>
		select	short_name
		  from	inst_groups
		 where	group_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="all_languages">
	 <querytext>
		select	name,
				language_id
		  from	language_codes
		 order	by name
	 </querytext>
	</fullquery>

	<fullquery name="get_languages">
	 <querytext>
		select	iplm.language_id
		  from	inst_personnel_language_map	iplm,
				language_codes				lc
		 where	lc.language_id		= iplm.language_id
		   and	iplm.personnel_id	= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="start_date_after_p">
	 <querytext>
		select	1
		  from	dual
		 where	to_date(:start_date,'yyyy-mm-dd') > to_date(:end_date,'yyyy-mm-dd')
	 </querytext>
	</fullquery>

	<fullquery name="employee_number_unique_p">
	 <querytext>
		select	0
		  from	inst_personnel
		 where	employee_number	= :employee_number
		   and	personnel_id	<> :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="other_person_with_employee_number">
	 <querytext>
		select	personnel_id,
				acs_object.name(personnel_id) as other_person
		  from	inst_personnel
		 where	employee_number	= :employee_number
		   and	rownum			< 2
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
