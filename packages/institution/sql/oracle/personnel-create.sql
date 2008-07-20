-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/personnel-create.sql
--
-- Data model for the personnel part of the institution package
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date 07/20/2003
-- @cvs-id $Id: personnel-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- All employees within the system

create table inst_personnel (
	personnel_id			integer
		constraint				inst_personnel_personnel_id_pk primary key
		constraint				inst_personnel_personnel_id_fk references persons(person_id),
	preferred_first_name	varchar2(100),
	preferred_middle_name	varchar2(100),
	preferred_last_name		varchar2(100),
	employee_number			integer
		constraint				inst_personnel_emp_num_un unique,
	gender					char(1)
		constraint				inst_personnel_gender_ck check (gender in ('m', 'f')),
	date_of_birth			date,
	bio						clob,
	photo					blob,
	photo_height			integer,
	photo_width				integer,
	photo_type				varchar2(100),
	degree_titles			varchar2(100),
	status_id				integer
		constraint				inst_personnel_status_id_fk references categories(category_id),
	start_date				date,
	end_date				date,
	-- optional notes put in by the data admin
	notes					varchar2(4000),
	meta_keywords			varchar2(4000)
);

create table inst_personnel_language_map (
	personnel_id			integer
		constraint				inst_plm_personnel_id_nn not null
		constraint				inst_plm_personnel_id_fk references inst_personnel(personnel_id),
	language_id				char(2)
		constraint				inst_plm_language_id_nn not null
		constraint 				inst_plm_language_id_fk references language_codes(language_id),
	constraint inst_plm_personnel_lang_id_pk primary key (personnel_id,language_id)
);
