-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/resume-create.sql
--
-- Tables for holding information about personnels' resumes.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-05
-- @cvs-id $Id: resume-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_personnel_resumes (
	resume_id				integer
		constraint			inst_pr_resume_id_pk primary key,
		constraint			inst_pr_resume_id_fk foreign key (resume_id) references acs_objects(object_id),
	personnel_id			integer			not null,
		constraint  		inst_pr_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	resume_type_id			integer			not null,
		constraint  		inst_pr_resume_type_id_fk foreign key (resume_type_id) references categories(category_id),
	description				varchar2(1000),
	format					varchar2(100),
	content					blob
);
