<?xml version="1.0"?>
<queryset>
	<fullquery name="personnel::personnel_exists_p.get_personnel_check">
	 <querytext>
		select	1
		  from	inst_personnel
		 where	personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::faculty_exists_p.get_faculty_check">
	 <querytext>
		select	1
		  from	inst_faculty
		 where	faculty_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::physician_exists_p.get_physician_check">
	 <querytext>
		select	1
		  from	inst_physicians
		 where	physician_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::user_exists_p.get_user_check">
	 <querytext>
		select 1
		  from users
		 where user_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::get_status_id.get_status_id">
	 <querytext>
		select	category.lookup('//Personnel Status//' || :name)
		  from	dual
	 </querytext>
	</fullquery>

	<!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
			faster method of extracting the permissions info we need -->
	<fullquery name="personnel::ui::status_select_options.status_select_options">
	 <querytext>
		select	lpad(' ', (level-1)*4*6 + 1, '&nbsp;') || name as name,
				category_id,
				parent_category_id,
				name
		  from	categories
		 where	acs_permission.permission_p(category_id, :user_id, 'read') = 't'
		start	with parent_category_id	= category.lookup('//Personnel Status')
		connect	by prior category_id	= parent_category_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::physician_delete.physician_delete_proc">
	 <querytext>
		delete from	inst_physicians
		 where		physician_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::sttp_mentorship_delete.sttp_delete_proc">
	 <querytext>
		delete from	inst_short_term_trnng_progs
		 where		personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::faculty_delete.faculty_delete_proc">
	 <querytext>
		delete from	inst_faculty
		 where		faculty_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::unassociate.group_map_delete_with_title">
	 <querytext>
		declare
			n integer := -1;
		begin
			for t in (select	gpm.gpm_title_id
						from	inst_group_personnel_map	gpm
					   where	acs_rel_id	= :rel_id
						 and	title_id	= :title_id) loop
				inst_title.delete(t.gpm_title_id);
			end loop;

			select	count(*) into n
			  from	inst_group_personnel_map
			 where	acs_rel_id = :rel_id;

			if n <= 0 then
				membership_rel.delete(:rel_id);
			end if;
		end;
	 </querytext>
	</fullquery>

	<fullquery name="personnel::unassociate.group_map_delete">
	 <querytext>
		begin
			for t in (select	gpm.gpm_title_id
						from	inst_group_personnel_map	gpm
					   where	acs_rel_id	= :rel_id) loop
				inst_title.delete(t.gpm_title_id);
			end loop;
			membership_rel.delete(:rel_id);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_add.personnel_insertion">
	 <querytext>
		update	inst_personnel
		   set	preferred_first_name	= :preferred_first_name,
				preferred_middle_name	= :preferred_middle_name,
				preferred_last_name		= :preferred_last_name,
				bio						= empty_clob(),
				date_of_birth			= to_date(:real_date_of_birth, 'YYYY-MM-DD'),
				start_date				= to_date(:real_start_date, 'YYYY-MM-DD'),
				end_date				= to_date(:real_end_date, 'YYYY-MM-DD')
		 where	personnel_id			= :personnel_id
		returning bio into :1
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_add.update_photo">
	 <querytext>
		update	inst_personnel
		   set	photo			= empty_blob(),
				photo_type		= :file_type,
				photo_width		= :width,
				photo_height	= :height
		 where	personnel_id	= :personnel_id
		returning photo into :1
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_add.language_map">
	 <querytext>
		insert into inst_personnel_language_map(personnel_id, language_id) values (:personnel_id, :language)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_edit.update_photo">
	 <querytext>
		update	inst_personnel
		   set	photo		 = empty_blob(),
				photo_type	 = :file_type,
				photo_width	 = :width,
				photo_height = :height
		 where	personnel_id = :personnel_id
		returning photo into :1
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_edit.language_map">
	 <querytext>
		insert into inst_personnel_language_map(personnel_id, language_id) values (:personnel_id, :language)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_edit.person_object_modified">
	 <querytext>
		update	acs_objects
		   set	last_modified	= sysdate,
				modifying_user	= :user_id,
				modifying_ip	= :peer_ip
		 where	object_id		= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_edit.persons_edit">
	 <querytext>
		update	persons
		   set	first_names	= :first_names,
				middle_name	= :middle_name,
				last_name	= :last_name
		 where	person_id	= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_edit.personnel_update">
	 <querytext>
		update	inst_personnel
		   set	preferred_first_name	= :preferred_first_name,
				preferred_middle_name 	= :preferred_middle_name,
				preferred_last_name 	= :preferred_last_name,
				date_of_birth 			= to_date(:real_date_of_birth, 'YYYY-MM-DD'),
				start_date 				= to_date(:real_start_date, 'YYYY-MM-DD'),
				end_date 				= to_date(:real_end_date, 'YYYY-MM-DD'),
				bio 					= empty_clob(),
				status_id				= :status_id,
				employee_number 		= :employee_number,
				gender 					= :gender,
				notes 					= :notes,
				meta_keywords			= :meta_keywords
		 where	personnel_id 			= :personnel_id
		returning bio into :1
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_edit.language_delete">
	 <querytext>
		delete from inst_personnel_language_map
		 where personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::physician_add.physician_add">
	 <querytext>
		insert into inst_physicians (
				physician_id
				, years_of_practice
				, primary_care_physician_p
				, accepting_patients_p
				, marketable_p
				, typical_patient)
			) values (
				:personnel_id
				, :years_of_practice
				, :primary_care_physician_p
				, :accepting_patients_p
				, :marketable_p
				, :typical_patient
		)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::physician_edit.update_physicians">
	 <querytext>
		update	inst_physicians
		   set	years_of_practice			= :years_of_practice,
				primary_care_physician_p	= :primary_care_physician_p,
				accepting_patients_p		= :accepting_patients_p,
				marketable_p				= :marketable_p,
				typical_patient				= :typical_patient
		 where	physician_id				= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_to_user.personnel_to_party">
	 <querytext>
		 update	parties
			set	email		= :priv_email
		  where	party_id	= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_to_user.personnel_to_user">
	 <querytext>
		insert into users(
				user_id,
				password,
				salt,
				email_verified_p,
				email_bouncing_p,
				password_question,
				password_answer
			) values (
				:personnel_id,
				:hashed_password,
				:salt,
				:true,
				:false,
				:password_question,
				:password_answer
		)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::personnel_to_user.add_user_preferences">
	 <querytext>
		insert into user_preferences (user_id) values (:personnel_id)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::user_to_personnel.personnel_new">
	 <querytext>
		insert into inst_personnel (
				personnel_id
				, preferred_first_name
				, preferred_middle_name
				, preferred_last_name
				, employee_number
				, gender
				, status_id
				, notes
			) values (
				:personnel_id
				, :preferred_first_name
				, :preferred_middle_name
				, :preferred_last_name
				, :employee_number
				, :gender
				, :status_id
				, :notes
		)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::user_to_personnel.personnel_insertion">
	 <querytext>
		update	inst_personnel
		   set	bio 			= empty_clob(),
				date_of_birth 	= to_date(:real_date_of_birth, 'YYYY-MM-DD'),
				start_date 		= to_date(:real_start_date, 'YYYY-MM-DD'),
				end_date 		= to_date(:real_end_date, 'YYYY-MM-DD')
		 where personnel_id 	= :personnel_id
		returning bio into :1
	 </querytext>
	</fullquery>

	<fullquery name="personnel::user_to_personnel.update_photo">
	 <querytext>
		update	inst_personnel
		   set	photo			= empty_blob(),
				photo_type		= :file_type,
				photo_width		= :width,
				photo_height	= :height
		 where	personnel_id	= :personnel_id
		returning photo into :1
	 </querytext>
	</fullquery>

	<fullquery name="personnel::user_to_personnel.language_map">
	 <querytext>
		insert into inst_personnel_language_map(personnel_id, language_id) values (:personnel_id, :language)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::faculty_add.faculty_new">
	 <querytext>
		insert into inst_faculty(faculty_id) values (:faculty_id)
	 </querytext>
	</fullquery>

	<fullquery name="personnel::sttp_mentorship_delete.sttp_requests_for_personnel">
	<querytext>
		select	request_id
		  from	inst_short_term_trnng_progs
		 where	personnel_id = :personnel_id
	</querytext>
	</fullquery>

	<fullquery name="personnel::sttp_mentorship_delete.sttp_delete">
	 <querytext>
		begin
			inst_short_term_trnng_prog.delete(request_id => :request_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
