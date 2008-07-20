-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-pkg-create.sql
--
-- Package for holding information directly related to personnel.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-14
-- @cvs-id $Id: sttp-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- --------------------------------- PERSONNEL ---------------------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_short_term_trnng_prog
as
	-- constructor --
	function new (
		request_id					in inst_short_term_trnng_progs.request_id%TYPE					default null,
		personnel_id				in inst_short_term_trnng_progs.personnel_id%TYPE,
		group_id					in inst_short_term_trnng_progs.group_id%TYPE					default null,
		description					in inst_short_term_trnng_progs.description%TYPE					default null,
		n_grads_currently_employed	in inst_short_term_trnng_progs.n_grads_currently_employed%TYPE	default 0,
		n_requested					in inst_short_term_trnng_progs.n_requested%TYPE					default 1,
		n_received					in inst_short_term_trnng_progs.n_received%TYPE					default 0,
		last_md_candidate			in inst_short_term_trnng_progs.last_md_candidate%TYPE			default null,
		last_md_year				in inst_short_term_trnng_progs.last_md_year%TYPE				default null,
		attend_poster_session_p		in inst_short_term_trnng_progs.attend_poster_session_p%TYPE		default 't',
		experience_required_p		in inst_short_term_trnng_progs.experience_required_p%TYPE		default 'f',
		skill_required_p			in inst_short_term_trnng_progs.skill_required_p%TYPE			default 'f',
		skill						in inst_short_term_trnng_progs.skill%TYPE						default null,
		department_chair_name		in inst_short_term_trnng_progs.department_chair_name%TYPE		default null,

		-- acs_object
		object_type					in acs_object_types.object_type%TYPE							default 'inst_short_term_trnng_prog',
		creation_date				in acs_objects.creation_date%TYPE								default sysdate,
		creation_user				in acs_objects.creation_user%TYPE								default null,
		creation_ip					in acs_objects.creation_ip%TYPE									default null,
		context_id					in acs_objects.context_id%TYPE									default null
	) return inst_personnel.personnel_id%TYPE;

	-- destructor --
	procedure delete (
		request_id					in inst_short_term_trnng_progs.request_id%TYPE
	);
end inst_short_term_trnng_prog;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_short_term_trnng_prog
as
	-- constructor --
	function new (
		request_id					in inst_short_term_trnng_progs.request_id%TYPE					default null,
		personnel_id				in inst_short_term_trnng_progs.personnel_id%TYPE,
		group_id					in inst_short_term_trnng_progs.group_id%TYPE					default null,
		description					in inst_short_term_trnng_progs.description%TYPE					default null,
		n_grads_currently_employed	in inst_short_term_trnng_progs.n_grads_currently_employed%TYPE	default 0,
		n_requested					in inst_short_term_trnng_progs.n_requested%TYPE					default 1,
		n_received					in inst_short_term_trnng_progs.n_received%TYPE					default 0,
		last_md_candidate			in inst_short_term_trnng_progs.last_md_candidate%TYPE			default null,
		last_md_year				in inst_short_term_trnng_progs.last_md_year%TYPE				default null,
		attend_poster_session_p		in inst_short_term_trnng_progs.attend_poster_session_p%TYPE		default 't',
		experience_required_p		in inst_short_term_trnng_progs.experience_required_p%TYPE		default 'f',
		skill_required_p			in inst_short_term_trnng_progs.skill_required_p%TYPE			default 'f',
		skill						in inst_short_term_trnng_progs.skill%TYPE						default null,
		department_chair_name		in inst_short_term_trnng_progs.department_chair_name%TYPE		default null,

		-- acs_object
		object_type					in acs_object_types.object_type%TYPE							default 'inst_short_term_trnng_prog',
		creation_date				in acs_objects.creation_date%TYPE								default sysdate,
		creation_user				in users.user_id%TYPE											default null,
		creation_ip					in acs_objects.creation_ip%TYPE									default null,
		context_id					in acs_objects.context_id%TYPE									default null
	) return inst_personnel.personnel_id%TYPE
	is
		v_request_id	integer := null;
	begin
		v_request_id	:= acs_object.new(
			object_type		=> inst_short_term_trnng_prog.new.object_type,
			creation_date	=> inst_short_term_trnng_prog.new.creation_date,
			creation_user	=> inst_short_term_trnng_prog.new.creation_user,
			creation_ip		=> inst_short_term_trnng_prog.new.creation_ip,
			context_id		=> inst_short_term_trnng_prog.new.context_id
		);

		insert into inst_short_term_trnng_progs (
			request_id,
			personnel_id,
			group_id,
			description,
			n_grads_currently_employed,
			n_requested,
			n_received,
			last_md_candidate,
			last_md_year,
			attend_poster_session_p,
			experience_required_p,
			skill_required_p,
			skill,
			department_chair_name
		) values (
			v_request_id,
			personnel_id,
			group_id,
			description,
			n_grads_currently_employed,
			n_requested,
			n_received,
			last_md_candidate,
			last_md_year,
			attend_poster_session_p,
			experience_required_p,
			skill_required_p,
			skill,
			department_chair_name
		);

		if creation_user is not null then
			acs_permission.grant_permission (
				object_id			=> v_request_id,
				grantee_id			=> creation_user,
				privilege			=> 'admin'
			);
		end if;

		if personnel_id is not null then
			acs_permission.grant_permission (
				object_id			=> v_request_id,
				grantee_id			=> personnel_id,
				privilege			=> 'admin'
			);
		end if;

		return v_request_id;
	end new;

	-- destructor --
	procedure delete (
		request_id					in inst_short_term_trnng_progs.request_id%TYPE
	) is
	begin
		delete from	inst_short_term_trnng_progs
			  where	request_id = inst_short_term_trnng_prog.delete.request_id;

		acs_object.delete(inst_short_term_trnng_prog.delete.request_id);
	end delete;
end inst_short_term_trnng_prog;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
