-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/physicians-create.sql
--
-- Tables for Storing Physican Specific Data
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-07-17
-- @cvs-id $Id: physician-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_physicians (
	physician_id				integer
		constraint				inst_phys_physician_id_pk primary key,
		constraint				inst_phys_physician_id_fk foreign key (physician_id) references inst_personnel(personnel_id),
	years_of_practice			integer
		constraint				inst_phys_yrs_prctc_notneg_ck check (years_of_practice >= 0),
	primary_care_physician_p	char default 't'
		constraint				inst_phys_pcp_p_ck check (primary_care_physician_p in ('t', 'f')) not null,
	accepting_patients_p		char default 't'
		constraint				inst_phys_accptng_ptnts_p_ck check (accepting_patients_p in ('t', 'f')) not null,
	marketable_p				char default 't'
		constraint				inst_phys_marketable_p_ck check (marketable_p in ('t', 'f')) not null,
	typical_patient				varchar2(4000)
);
