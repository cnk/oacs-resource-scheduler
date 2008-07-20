-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/faculty-pkg-create.sql
--
-- Package for holding information directly related to faculty.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-31
-- @cvs-id $Id: faculty-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- FACULTY-----------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_faculty_member
as
	-- constructor --
	function new (
		-- persons
		first_names				in persons.first_names%TYPE,
		middle_name				in persons.middle_name%TYPE,
		last_name				in persons.last_name%TYPE,

		-- faculty
		faculty_id				in inst_faculty.faculty_id%TYPE					default null,

		-- personnel
		employee_number			in inst_personnel.employee_number%TYPE			default null,
		gender					in inst_personnel.gender%TYPE					default null,
		date_of_birth			in inst_personnel.date_of_birth%TYPE			default null,
		status_id				in inst_personnel.status_id%TYPE				default 'active',
		start_date				in inst_personnel.start_date%TYPE				default null,
		end_date				in inst_personnel.end_date%TYPE					default null,
		bio						in inst_personnel.bio%TYPE						default empty_clob(),
		photo					in inst_personnel.photo%TYPE					default null,
		photo_height			in inst_personnel.photo_height%TYPE				default null,
		photo_width				in inst_personnel.photo_width%TYPE				default null,
		photo_type				in inst_personnel.photo_type%TYPE				default null,
		notes					in inst_personnel.notes%TYPE					default null,

		-- parties
		email					in parties.email%TYPE							default null, -- not optional in acs-kernel:community-core-create:parties, but may be null in table
		url						in parties.url%TYPE								default null,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE			default 'person',
		creation_date			in acs_objects.creation_date%TYPE				default sysdate,
		creation_user			in acs_objects.creation_user%TYPE				default null,
		creation_ip				in acs_objects.creation_ip%TYPE					default null,
		context_id				in acs_objects.context_id%TYPE					default null
	) return inst_faculty.faculty_id%TYPE;

	procedure create_from_personnel(
		personnel_id			in inst_personnel.personnel_id%TYPE
	);

	-- destructor --
	procedure delete (
		faculty_id				in inst_faculty.faculty_id%TYPE
	);
end inst_faculty_member;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_faculty_member
as
	-- constructor --
	function new (
		-- persons
		first_names				in persons.first_names%TYPE,
		middle_name				in persons.middle_name%TYPE,
		last_name				in persons.last_name%TYPE,

		-- faculty
		faculty_id				in inst_faculty.faculty_id%TYPE					default null,

		-- personnel
		employee_number			in inst_personnel.employee_number%TYPE			default null,
		gender					in inst_personnel.gender%TYPE					default null,
		date_of_birth			in inst_personnel.date_of_birth%TYPE			default null,
		status_id				in inst_personnel.status_id%TYPE				default 'active',
		start_date				in inst_personnel.start_date%TYPE				default null,
		end_date				in inst_personnel.end_date%TYPE					default null,
		bio						in inst_personnel.bio%TYPE						default empty_clob(),
		photo					in inst_personnel.photo%TYPE					default null,
		photo_height			in inst_personnel.photo_height%TYPE				default null,
		photo_width				in inst_personnel.photo_width%TYPE				default null,
		photo_type				in inst_personnel.photo_type%TYPE				default null,
		notes					in inst_personnel.notes%TYPE					default null,

		-- parties
		email					in parties.email%TYPE							default null, -- not optional in acs-kernel:community-core-create:parties, but may be null in table
		url						in parties.url%TYPE								default null,

		-- acs_object
		object_type				in acs_object_types.object_type%TYPE			default 'person',
		creation_date			in acs_objects.creation_date%TYPE				default sysdate,
		creation_user			in acs_objects.creation_user%TYPE				default null,
		creation_ip				in acs_objects.creation_ip%TYPE					default null,
		context_id				in acs_objects.context_id%TYPE					default null
	) return inst_faculty.faculty_id%TYPE
	is
		v_personnel_id	integer;
	begin
		v_personnel_id := inst_person.new(
			first_names		=> first_names,
			middle_name		=> middle_name,
			last_name		=> last_name,
			personnel_id	=> faculty_id,
			employee_number	=> employee_number,
			gender			=> gender,
			date_of_birth	=> date_of_birth,
			status_id		=> status_id,
			start_date		=> start_date,
			end_date		=> end_date,
			bio				=> bio,
			photo			=> photo,
			photo_height	=> photo_height,
			photo_width		=> photo_width,
			photo_type		=> photo_type,
			notes			=> notes,
			email			=> email,
			url				=> url,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> context_id
		);

		create_from_personnel(v_personnel_id);

		return v_personnel_id;
	end new;

	procedure create_from_personnel(
		personnel_id			in inst_personnel.personnel_id%TYPE
	) is
	begin
		insert into inst_faculty (
				faculty_id
			) values (
				personnel_id
		);
	end create_from_personnel;

	-- destructor --
	procedure delete (
		faculty_id				in inst_faculty.faculty_id%TYPE
	) is
	begin
		delete from inst_faculty
		 where faculty_id = inst_faculty_member.delete.faculty_id;

		inst_person.delete(inst_faculty_member.delete.faculty_id);
	end delete;
end inst_faculty_member;
/
show errors;

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
