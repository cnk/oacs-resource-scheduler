alter table inst_group_personnel_map add title_priority_number integer;

create table inst_personnel_resumes (
	resume_id				integer
		constraint			inst_pr_resume_id_pk primary key,
		constraint			inst_pr_resume_id_fk foreign key (resume_id) references acs_objects(object_id),
	personnel_id			integer			not null,
		constraint  		inst_pr_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	resume_type_id			integer			not null,
		constraint  		inst_pr_resume_type_id_fk foreign key (resume_type_id) references categories(category_id),
	description				varchar2(1000),
	resume					varchar2(4000),
	format					varchar2(100)
);

begin
	acs_object_type.create_type (
		supertype		=> 'acs_object',
		object_type		=> 'resume',
		pretty_name		=> 'Resume',
		pretty_plural	=> 'Resumes',
		table_name		=> 'INST_PERSONNEL_RESUMES',
		id_column		=> 'RESUME_ID'
	);
end;
/
show errors;

-- create attributes -----------------------------------------------------------
declare
	attr_id	acs_attributes.attribute_id%TYPE;
begin
	attr_id := acs_attribute.create_attribute (
		object_type		=> 'resume',
		attribute_name	=> 'DESCRIPTION',
		pretty_name		=> 'Description',
		pretty_plural	=> 'Descriptions',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'resume',
		attribute_name	=> 'RESUME',
		pretty_name		=> 'Resume',
		pretty_plural	=> 'Resumes',
		datatype		=> 'string'
	);

	attr_id := acs_attribute.create_attribute (
		object_type		=> 'resume',
		attribute_name	=> 'FORMAT',
		pretty_name		=> 'Resume Format',
		pretty_plural	=> 'Resume Formats',
		datatype		=> 'string'
	);
end;
/
show errors;

-- declare package -------------------------------------------------------------
create or replace package personnel_resume
as
	-- constructor --
	function new (
		resume_id		in inst_personnel_resumes.resume_id%TYPE		default null,
		owner_id		in inst_personnel_resumes.personnel_id%TYPE,
		type_id			in inst_personnel_resumes.resume_type_id%TYPE	default null,
		description		in inst_personnel_resumes.description%TYPE		default null,
		resume			in inst_personnel_resumes.resume%TYPE,
		format			in inst_personnel_resumes.format%TYPE			default 'text/text',

		object_type		in acs_object_types.object_type%TYPE			default 'resume',
		creation_date	in acs_objects.creation_date%TYPE				default sysdate,
		creation_user	in acs_objects.creation_user%TYPE				default null,
		creation_ip		in acs_objects.creation_ip%TYPE					default null,
		context_id		in acs_objects.context_id%TYPE					default null
	) return inst_personnel_resumes.resume_id%TYPE;

	-- destructor --
	procedure delete (
		resume_id		in inst_personnel_resumes.resume_id%TYPE
	);
end personnel_resume;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body personnel_resume
as
	-- constructor -- allows augmenting/mutation of other objects at runtime
	function new (
		resume_id		in inst_personnel_resumes.resume_id%TYPE		default null,
		owner_id		in inst_personnel_resumes.personnel_id%TYPE,
		type_id			in inst_personnel_resumes.resume_type_id%TYPE	default null,
		description		in inst_personnel_resumes.description%TYPE		default null,
		resume			in inst_personnel_resumes.resume%TYPE,
		format			in inst_personnel_resumes.format%TYPE			default 'text/text',

		object_type		in acs_object_types.object_type%TYPE			default 'resume',
		creation_date	in acs_objects.creation_date%TYPE				default sysdate,
		creation_user	in acs_objects.creation_user%TYPE				default null,
		creation_ip		in acs_objects.creation_ip%TYPE					default null,
		context_id		in acs_objects.context_id%TYPE					default null
	) return inst_personnel_resumes.resume_id%TYPE
	is
		v_resume_id			integer;
		v_obj_exists_p		integer;
		v_obj_type			acs_objects.object_type%TYPE;
		v_resume_exists_p	integer;
		v_type_id			integer;
		unused				integer;
	begin
		v_resume_id := acs_object.new (
			object_id		=> v_resume_id,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> context_id
		);

		-- use a default type_id if it's null
		if type_id is null then
			select category_id into v_type_id
			  from categories
			 where parent_category_id =
					(select category_id
					   from categories
					  where parent_category_id is null
						and name = 'Contact Information')
			   and name = 'Other';
		else
			v_type_id := personnel_resume.new.type_id;
		end if;

		insert into inst_personnel_resumes (
				resume_id, personnel_id, resume_type_id, description, resume, format
			) values (
				v_resume_id, owner_id, v_type_id, description, resume, format
		);

		return v_resume_id;
	end new;

	-- destructor --
	procedure delete (
		resume_id		in inst_personnel_resumes.resume_id%TYPE
	) is
		v_resume_id		integer;
	begin
		v_resume_id := resume_id;

		delete from acs_rels
		where object_id_one = v_resume_id
		   or object_id_two = v_resume_id;

		delete from acs_permissions
		where object_id = v_resume_id;

		delete from inst_personnel_resumes
		where resume_id = v_resume_id;

		acs_object.delete(v_resume_id);
	end delete;
end personnel_resume;
/
show errors;


create table inst_faculty (
	faculty_id				integer
		constraint			inst_faculty_faculty_id_pk primary key,
		constraint			inst_faculty_faculty_id_fk foreign key(faculty_id) references inst_personnel(personnel_id)
);

declare
	pcat_id integer;
	cat_id integer;
begin
	pcat_id := category.new(name => 'Contact Information', plural => 'Contact Information');
	cat_id := category.new(parent_category_id => pcat_id, name => 'Login Email Address', plural => 'Login Email Addresses');
	cat_id := category.new(parent_category_id => pcat_id, name => 'Other', plural => 'Others');

	pcat_id := category.new(name => 'Group Type', plural => 'Group Types');
	cat_id := category.new(parent_category_id => pcat_id, name => 'Department', plural => 'Departments');

	pcat_id := category.new(name => 'Personnel Title', plural => 'Personnel Titles');
	pcat_id := category.new(name => 'Certification Type', plural => 'Certification Types');
end;
/

-- declare package -------------------------------------------------------------
create or replace package personnel
as
	-- constructor --
	function new (
			-- persons
		first_names				in persons.first_names%TYPE,
		last_name				in persons.last_name%TYPE,

		-- personnel
		personnel_id			in inst_personnel.personnel_id%TYPE				default null,
		employee_number			in inst_personnel.employee_number%TYPE			default null,
		gender					in inst_personnel.gender%TYPE					default null,
		date_of_birth			in inst_personnel.date_of_birth%TYPE			default null,
		status					in inst_personnel.status%TYPE					default 'active',
		start_date				in inst_personnel.start_date%TYPE				default null,
		end_date				in inst_personnel.end_date%TYPE					default null,
		bio						in inst_personnel.bio%TYPE						default empty_clob(),
		photo					in inst_personnel.photo%TYPE					default null,
		photo_height			in inst_personnel.photo_height%TYPE				default null,
		photo_width				in inst_personnel.photo_width%TYPE				default null,
		photo_type				in inst_personnel.photo_type%TYPE				default null,
		notes					in inst_personnel.notes%TYPE					default null,

		-- parties
		email					in parties.email%TYPE	default null, -- not optional in acs-kernel:community-core-create:parties, but may be null in table
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
		last_name		in persons.last_name%TYPE,
		password		in users.password%TYPE,	
		salt		    in users.salt%TYPE	
	);
end personnel;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body personnel
as
	-- constructor --
	function new (
		-- persons
		first_names				in persons.first_names%TYPE,
		last_name				in persons.last_name%TYPE,

		-- personnel
		personnel_id			in inst_personnel.personnel_id%TYPE				default null,
		employee_number			in inst_personnel.employee_number%TYPE			default null,
		gender					in inst_personnel.gender%TYPE					default null,
		date_of_birth			in inst_personnel.date_of_birth%TYPE			default null,
		status					in inst_personnel.status%TYPE					default 'active',
		start_date				in inst_personnel.start_date%TYPE				default null, 
		end_date				in inst_personnel.end_date%TYPE					default null,
		bio						in inst_personnel.bio%TYPE						default empty_clob(),
		photo					in inst_personnel.photo%TYPE					default null,
		photo_height			in inst_personnel.photo_height%TYPE				default null,
		photo_width				in inst_personnel.photo_width%TYPE				default null,
		photo_type				in inst_personnel.photo_type%TYPE				default null,
		notes					in inst_personnel.notes%TYPE					default null,

		-- parties
		email					in parties.email%TYPE    default null, -- not optional in acs-kernel:community-core-create:parties, but may be null in table
		url						in parties.url%TYPE								default null,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE			default 'person',
		creation_date			in acs_objects.creation_date%TYPE				default sysdate,
		creation_user			in acs_objects.creation_user%TYPE				default null,
		creation_ip				in acs_objects.creation_ip%TYPE					default null,
		context_id				in acs_objects.context_id%TYPE					default null
	) return inst_personnel.personnel_id%TYPE
	is
		v_personnel_id		integer;
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
			 where object_id = personnel.new.personnel_id;
			exception when no_data_found then v_obj_exists_p := 0;
		end;

		begin
			select 1 into unused from inst_personnel where personnel_id = personnel.new.personnel_id;
			exception when no_data_found then v_psn_exists_p := 0;
		end;

		if v_psn_exists_p = 1 and v_psn_exists_p = v_obj_exists_p then
			raise_application_error(-20000,
				'Employee exists already: personnel_id/object_id = ' ||
				v_personnel_id || '.'
			);
		end if;

		v_personnel_id := personnel.new.personnel_id;

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
					employee_number,
					gender,
					date_of_birth,
					status,
					start_date,
					end_date,
					bio,
					photo,
					photo_height,
					photo_width,
					photo_type,
					notes
				) values (
					v_personnel_id,
					employee_number,
					gender,
					date_of_birth,
					status,
					start_date,
					end_date,
					bio,
					photo,
					photo_height,
					photo_width,
					photo_type, 
					notes
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

		--delete from acs_permissions--
		--where object_id = v_personnel_id;--

		delete from inst_personnel
		where personnel_id = v_personnel_id;
		
    --personnel_resumes 
	delete from inst_personnel_resumes where personnel_id = v_personnel_id;
    --personnel_url 
	delete from inst_party_urls where party_id = v_personnel_id;
    -- personnel_email 
	delete from inst_party_emails where party_id = v_personnel_id;
    --personnel_phone 
	delete from inst_party_phones where party_id = v_personnel_id;
    --personnel_address 
	delete from inst_party_addresses where party_id = v_personnel_id;
    --personnel_certificates 
	delete from inst_certifications where party_id = v_personnel_id;
    --user_permissions 
	delete from acs_permissions where object_id = v_personnel_id;
   	--grantee 
	delete from acs_permissions where grantee_id = v_personnel_id;
	
	--user_preference
	delete from user_preferences where user_id = v_personnel_id;
    --user_delete 
	delete from users where user_id = v_personnel_id;

	--faculty delete
	delete from inst_faculty where faculty_id = v_personnel_id;

	person.delete(v_personnel_id);
	--make sure delete acs_object--
		
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
		last_name		in persons.last_name%TYPE,
		password		in users.password%TYPE,	
		salt		    in users.salt%TYPE	
	) 
	is
		v_personnel_id	integer;
		v_rel_id		integer;
		v_email_type_id integer;
		v_temp 			integer;
	begin

		v_personnel_id := personnel_id;
				
		update parties
		set email = p_email
		where party_id = v_personnel_id;
	
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
		 	object_id => v_personnel_id,
			grantee_id => v_personnel_id,
			privilege => 'read'
		);

		acs_permission.grant_permission (
			object_id => v_personnel_id,
			grantee_id => v_personnel_id,
			privilege => 'write'
		);
		
		v_email_type_id := category.lookup('//Contact Information//Login Email Address');

		v_temp := party_email.new (
			owner_id => v_personnel_id,
			type_id => v_email_type_id,
			email => p_email
		);	

		end;
end personnel;
/
show errors;


commit;

@personnel-body-drop.sql
@personnel-body-create.sql

@publications-body-drop.sql
@publications-body-create.sql

