-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/resume-pkg-create.sql
--
-- Package for holding resumes of personnel.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-05
-- @cvs-id $Id: resume-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------------------- RESUME -----------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_personnel_resume
as
	-- constructor --
	function new (
		resume_id		in inst_personnel_resumes.resume_id%TYPE		default null,
		owner_id		in inst_personnel_resumes.personnel_id%TYPE,
		type_id			in inst_personnel_resumes.resume_type_id%TYPE	default null,
		description		in inst_personnel_resumes.description%TYPE		default null,
		format			in inst_personnel_resumes.format%TYPE			default 'text/text',
		content			in inst_personnel_resumes.content%TYPE			default empty_blob(),
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
end inst_personnel_resume;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_personnel_resume
as
	-- constructor -- allows augmenting/mutation of other objects at runtime
	function new (
		resume_id		in inst_personnel_resumes.resume_id%TYPE		default null,
		owner_id		in inst_personnel_resumes.personnel_id%TYPE,
		type_id			in inst_personnel_resumes.resume_type_id%TYPE	default null,
		description		in inst_personnel_resumes.description%TYPE		default null,
		format			in inst_personnel_resumes.format%TYPE			default 'text/text',
		content			in inst_personnel_resumes.content%TYPE			default empty_blob(),
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
			v_type_id := category.lookup('//Resume Type//Resume');
		else
			v_type_id := inst_personnel_resume.new.type_id;
		end if;

		insert into inst_personnel_resumes (
				resume_id, personnel_id, resume_type_id, description, format
			) values (
				v_resume_id, owner_id, v_type_id, description, format
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
end inst_personnel_resume;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
