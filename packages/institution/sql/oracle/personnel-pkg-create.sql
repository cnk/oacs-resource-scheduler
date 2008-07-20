-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-pkg-create.sql
--
-- Package for holding information directly related to personnel.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2003-08-14
-- @cvs-id			$Id: personnel-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- --------------------------------- PERSONNEL ---------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_person
as
	-- constructor --
	function new (
		-- persons
		first_names				in persons.first_names%TYPE,
		middle_name				in persons.middle_name%TYPE						default null,
		last_name				in persons.last_name%TYPE,

		-- personnel
		personnel_id			in inst_personnel.personnel_id%TYPE				default null,
		preferred_first_name	in inst_personnel.preferred_first_name%TYPE		default null,
		preferred_middle_name	in inst_personnel.preferred_middle_name%TYPE	default null,
		preferred_last_name		in inst_personnel.preferred_last_name%TYPE		default null,
		employee_number			in inst_personnel.employee_number%TYPE			default null,
		gender					in inst_personnel.gender%TYPE					default null,
		date_of_birth			in inst_personnel.date_of_birth%TYPE			default null,
		status_id				in inst_personnel.status_id%TYPE				default null,
		start_date				in inst_personnel.start_date%TYPE				default null,
		end_date				in inst_personnel.end_date%TYPE					default null,
		bio						in inst_personnel.bio%TYPE						default empty_clob(),
		photo					in inst_personnel.photo%TYPE					default null,
		photo_height			in inst_personnel.photo_height%TYPE				default null,
		photo_width				in inst_personnel.photo_width%TYPE				default null,
		photo_type				in inst_personnel.photo_type%TYPE				default null,
		notes					in inst_personnel.notes%TYPE					default null,
		meta_keywords			in inst_personnel.meta_keywords%TYPE			default null,

		-- parties
		email					in parties.email%TYPE							default null, -- not optional in acs-kernel:community-core-create:parties, but may be null in table
		url						in parties.url%TYPE								default null,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE			default 'person',
		creation_date			in acs_objects.creation_date%TYPE				default sysdate,
		creation_user			in acs_objects.creation_user%TYPE				default null,
		creation_ip				in acs_objects.creation_ip%TYPE					default null,
		context_id				in acs_objects.context_id%TYPE					default null
	) return inst_personnel.personnel_id%TYPE;

	-- destructor --
	procedure delete (
		personnel_id	in inst_personnel.personnel_id%TYPE
	);

	-- rels delete --
	procedure language_delete (
		personnel_id	in inst_personnel.personnel_id%TYPE
	);

	procedure publication_map_delete (
		personnel_id	in inst_personnel.personnel_id%TYPE
	);

	procedure personnel_to_user (
		personnel_id	in inst_personnel.personnel_id%TYPE,
		p_email			in parties.email%TYPE,
		first_names		in persons.first_names%TYPE,
		middle_name		in persons.middle_name%TYPE		default null,
		last_name		in persons.last_name%TYPE,
		password		in users.password%TYPE,
		salt			in users.salt%TYPE
	);
end inst_person;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_person
as
	-- constructor --
	function new (
		-- persons
		first_names				in persons.first_names%TYPE,
		middle_name				in persons.middle_name%TYPE						default null,
		last_name				in persons.last_name%TYPE,

		-- personnel
		personnel_id			in inst_personnel.personnel_id%TYPE				default null,
		preferred_first_name	in inst_personnel.preferred_first_name%TYPE		default null,
		preferred_middle_name	in inst_personnel.preferred_middle_name%TYPE	default null,
		preferred_last_name		in inst_personnel.preferred_last_name%TYPE		default null,
		employee_number			in inst_personnel.employee_number%TYPE			default null,
		gender					in inst_personnel.gender%TYPE					default null,
		date_of_birth			in inst_personnel.date_of_birth%TYPE			default null,
		status_id				in inst_personnel.status_id%TYPE				default null,
		start_date				in inst_personnel.start_date%TYPE				default null,
		end_date				in inst_personnel.end_date%TYPE					default null,
		bio						in inst_personnel.bio%TYPE						default empty_clob(),
		photo					in inst_personnel.photo%TYPE					default null,
		photo_height			in inst_personnel.photo_height%TYPE				default null,
		photo_width				in inst_personnel.photo_width%TYPE				default null,
		photo_type				in inst_personnel.photo_type%TYPE				default null,
		notes					in inst_personnel.notes%TYPE					default null,
		meta_keywords			in inst_personnel.meta_keywords%TYPE			default null,

		-- parties
		email					in parties.email%TYPE							default null, -- not optional in acs-kernel:community-core-create:parties, but may be null in table
		url						in parties.url%TYPE								default null,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE			default 'person',	-- errors occur if this is made to be 'personnel'
		creation_date			in acs_objects.creation_date%TYPE				default sysdate,
		creation_user			in acs_objects.creation_user%TYPE				default null,
		creation_ip				in acs_objects.creation_ip%TYPE					default null,
		context_id				in acs_objects.context_id%TYPE					default null
	) return inst_personnel.personnel_id%TYPE
	is
		v_personnel_id	integer;
		v_obj_exists_p	integer;
		v_obj_type		acs_objects.object_type%TYPE;
		v_psn_exists_p	integer;
		unused			integer;
	begin
		v_obj_exists_p := 1;
		v_obj_type := null;

		v_psn_exists_p := 1;

		begin
			select object_type into v_obj_type
			  from acs_objects
			 where object_id = inst_person.new.personnel_id;
			exception when no_data_found then v_obj_exists_p := 0;
		end;

		begin
			select 1 into unused from inst_personnel where personnel_id = inst_person.new.personnel_id;
			exception when no_data_found then v_psn_exists_p := 0;
		end;

		if v_psn_exists_p = 1 and v_psn_exists_p = v_obj_exists_p then
			raise_application_error(-20000,
				'Employee exists already: personnel_id/object_id = ' ||
				v_personnel_id || '.'
			);
		end if;

		v_personnel_id := inst_person.new.personnel_id;

		if v_personnel_id is not null and v_obj_exists_p = 1 then
			if v_obj_type <> 'inst_personnel' then
				raise_application_error(-20000,
					'Attempted to create employee object that already ' ||
					'exists and is not an employee: object_id = ' ||
					v_personnel_id || ', object_type = ' || v_obj_type || '.'
				);
			end if;
		else
			-- create corresponding person, use object_id if it's available
			v_personnel_id := person.new (
				person_id		=> v_personnel_id,
				first_names		=> first_names,
				middle_name		=> middle_name,
				last_name		=> last_name,
				email			=> email,
				url				=> url,
				object_type		=> object_type,
				creation_date	=> creation_date,
				creation_user	=> creation_user,
				creation_ip		=> creation_ip,
				context_id		=> context_id
			);
		end if;

		if v_psn_exists_p = 0 then
			insert into inst_personnel (
					personnel_id,
					preferred_first_name,
					preferred_middle_name,
					preferred_last_name,
					employee_number,
					gender,
					date_of_birth,
					status_id,
					start_date,
					end_date,
					bio,
					photo,
					photo_height,
					photo_width,
					photo_type,
					notes,
					meta_keywords
				) values (
					v_personnel_id,
					preferred_first_name,
					preferred_middle_name,
					preferred_last_name,
					employee_number,
					gender,
					date_of_birth,
					nvl(status_id, category.lookup('//Personnel Status//Active')),
					start_date,
					end_date,
					bio,
					photo,
					photo_height,
					photo_width,
					photo_type,
					notes,
					meta_keywords
			);
		end if;

		if creation_user is not null then
			acs_permission.grant_permission (
				object_id			=> v_personnel_id,
				grantee_id			=> creation_user,
				privilege			=> 'admin'
			);
		end if;

		return v_personnel_id;
	end new;

	-- destructor --
	procedure delete (
		personnel_id		in inst_personnel.personnel_id%TYPE
	) is
		v_personnel_id		integer;
	begin
		v_personnel_id := personnel_id;

		-- Languages
		delete from inst_personnel_language_map where personnel_id = v_personnel_id;

		-- Addresses
		for a in (select address_id
					from inst_party_addresses
				   where party_id = v_personnel_id) loop
			inst_party_address.delete(a.address_id);
		end loop;

		-- Phone Numbers
		for p in (select phone_id
					from inst_party_phones
				   where party_id = v_personnel_id) loop
			inst_party_phone.delete(p.phone_id);
		end loop;

		-- Certifications
		for c in (select certification_id
					from inst_certifications
				   where party_id = v_personnel_id) loop
			inst_certification.delete(c.certification_id);
		end loop;

		-- Resumes
		for r in (select resume_id
					from inst_personnel_resumes
				   where personnel_id = v_personnel_id) loop
			inst_personnel_resume.delete(r.resume_id);
		end loop;

		-- URLs
		for u in (select url_id
					from inst_party_urls
				   where party_id = v_personnel_id) loop
			inst_party_url.delete(u.url_id);
		end loop;

		-- Email Addresses
		for e in (select email_id
					from inst_party_emails
				   where party_id = v_personnel_id) loop
			inst_party_email.delete(e.email_id);
		end loop;

		-- Images
		for i in (select image_id
					from inst_party_images
				   where party_id = v_personnel_id) loop
			inst_party_image.delete(i.image_id);
		end loop;

		-- Titles
		for t in (select gpm_title_id,
						 acs_rel_id
					from inst_group_personnel_map	gpm,
						 acs_rels					r
				   where gpm.acs_rel_id		= r.rel_id
					 and r.object_id_two	= v_personnel_id) loop
			inst_title.delete(t.gpm_title_id);
			membership_rel.delete(t.acs_rel_id);
		end loop;

		-- Category Map
		delete from inst_party_category_map where party_id = v_personnel_id;

		-- Languages
		delete from inst_personnel_language_map where personnel_id = v_personnel_id;

		-- Research Interests
		delete from inst_subsite_pers_res_intrsts where personnel_id = v_personnel_id;

		-- Group Specific Data
		delete from access_personnel where personnel_id = v_personnel_id;
		delete from jccc_personnel where personnel_id = v_personnel_id;

		-- Publication Mappings
		delete from inst_personnel_publication_map where personnel_id = v_personnel_id;
		delete from inst_psnl_publ_ordered_subsets where personnel_id = v_personnel_id;

		-- Delete Orphaned Publications
		for pub in (select	publication_id
					  from	inst_publications p
					 where	not exists
							(select	1
							   from	inst_personnel_publication_map pm
							  where	pm.publication_id = p.publication_id)) loop
			begin
				-- try to delete the publication
				-- the exception catch is so that other FK references to the publication
				--	prevent the delete from succeeding but don't cause errors
				inst_publication.delete(pub.publication_id);
				exception when others then null;
			end;
		end loop;

		-- Physician Data
		delete from inst_physicians where physician_id = v_personnel_id;

		-- Faculty Data
		delete from inst_faculty where faculty_id = v_personnel_id;

		------------------------------------------------------------------------
		-- OpenACS Tables: -----------------------------------------------------
		------------------------------------------------------------------------
		--user_preference
		delete from user_preferences where user_id = v_personnel_id;

		--inst_personnel delete
		delete from inst_personnel where personnel_id = v_personnel_id;

		-- If the personnel is a user, delete the user
		declare
			user_exists_p integer := 0;
		begin
			select 1 into user_exists_p
			  from users
			 where user_id = v_personnel_id;
			acs_user.delete(v_personnel_id);
			exception when no_data_found then null;
		end;

		-- person.delete() handles deleting the person, party, and acs_object
		--	that represents this personnel.  It also deletes permissions etc.
		person.delete(v_personnel_id);
	end delete;

	-- language delete --
	procedure language_delete (
		personnel_id		in inst_personnel.personnel_id%TYPE
	) is
		v_personnel_id		integer;
	begin
		v_personnel_id := personnel_id;

	delete from inst_personnel_language_map
	where personnel_id = v_personnel_id;

	end language_delete;

	procedure publication_map_delete (
		personnel_id		in inst_personnel.personnel_id%TYPE
	) is
		v_personnel_id		integer;
	begin
		v_personnel_id := personnel_id;

	delete from inst_personnel_publication_map
	where personnel_id = v_personnel_id;

	end publication_map_delete;

	procedure personnel_to_user (
		personnel_id	in inst_personnel.personnel_id%TYPE,
		p_email			in parties.email%TYPE,
		first_names		in persons.first_names%TYPE,
		middle_name		in persons.middle_name%TYPE				default null,
		last_name		in persons.last_name%TYPE,
		password		in users.password%TYPE,
		salt			in users.salt%TYPE
	) is
		v_personnel_id	integer;
		v_rel_id		integer;
		v_email_type_id integer;
		v_email_id		integer;
	begin

		v_personnel_id := personnel_id;

		update parties
		   set email	= p_email
		 where party_id	= v_personnel_id;

		insert into users (
			user_id,
			password,
			salt
		) values (
			v_personnel_id,
			password,
		    salt
		);

		insert into user_preferences (user_id) values (v_personnel_id);

		v_rel_id := membership_rel.new (
			object_id_two => v_personnel_id,
			object_id_one => acs.magic_object_id('registered_users'),
			 member_state => 'approved'
		);

		acs_permission.grant_permission (
		 	object_id	=> v_personnel_id,
			grantee_id	=> v_personnel_id,
			privilege	=> 'admin'
		);

		v_email_type_id := category.lookup('//Contact Information//Email//Email Address');

		if v_email_type_id is null then
			raise_application_error(-20000,
				'Email Address is not a valid email type'
			);
		end if;

		begin
			-- if they already have such an email address, don't over-write it
			select	email_id into v_email_id
			  from	inst_party_emails
			 where	party_id			= v_personnel_id
			   and	email_type_id		= v_email_type_id
			   and	lower(trim(email))	= lower(trim(p_email));
			exception when no_data_found then
				v_email_id := inst_party_email.new (
					owner_id	=> v_personnel_id,
					type_id		=> v_email_type_id,
					email		=> p_email
				);
		end;
	end;
end inst_person;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
