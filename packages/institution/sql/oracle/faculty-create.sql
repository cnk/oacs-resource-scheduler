-- packages/institution/sql/oracle/faculty-create.sql
--
-- Tables for Storing Physican Specific Data
--
-- @author avni@avni.net (AK)
-- @creation-date 03/30/2004
-- @cvs-id $Id: faculty-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_faculty (
	faculty_id				integer
		constraint			inst_fac_faculty_id_pk primary key,
		constraint			inst_fac_faculty_id_fk foreign key (faculty_id) references inst_personnel(personnel_id),
	f_key					integer
);
