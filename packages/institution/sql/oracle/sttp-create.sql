-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/sttp-create.sql
--
-- Data model for the short-term training program.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2004/10/25
-- @cvs-id			$Id: sttp-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_short_term_trnng_progs (
	request_id					integer
		constraint					inst_sttp_request_id_pk primary key,
		constraint					inst_sttp_request_id_fk foreign key (request_id) references acs_objects(object_id),
	personnel_id				integer,				-- faculty_key
		constraint					inst_sttp_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	group_id					integer,
		constraint					inst_sttp_group_id_fk foreign key (group_id) references inst_groups(group_id),
	description					varchar2(4000),			-- description
	n_grads_currently_employed	integer	default 0,		-- phd_cand
	n_requested					integer default 1,		-- available/position
	n_received					integer default 0,		-- available/position
	last_md_candidate			varchar2(150),			-- md_cand
	last_md_year				integer,				-- md_year
	attend_poster_session_p		char(1) default 't',	-- judge_p
	experience_required_p		char(1) default 'f',	-- exper_req
	skill_required_p			char(1) default 'f',	-- skill_req
	skill						varchar2(250),			-- skill
	department_chair_name		varchar2(150)
);
-- NOTE: in the old system, 'available' was set to 1 if at least 1 MD was hired, 0 otherwise
--			and 'position' indicated whether the position was still open (0 or 1)
