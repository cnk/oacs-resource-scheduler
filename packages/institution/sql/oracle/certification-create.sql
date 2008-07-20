-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/certification-create.sql
--
-- Data model to model the certification of parties by other parties
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-07-20
-- @cvs-id $Id: certification-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- This table will store the awards, education, degrees, certifications, etc.. for parties
create table inst_certifications (
	certification_id			integer
		constraint				inst_cert_certification_id_pk primary key,
		constraint				inst_cert_certification_id_fk foreign key (certification_id) references acs_objects(object_id),
	party_id					integer		not null
		constraint				inst_cert_party_id_fk references parties(party_id),
	certification_type_id		integer		not null
		constraint				inst_cert_cert_type_id_fk references categories(category_id),
	certifying_party			varchar2(4000),
	-- Certification "Number" given upon receipt of the certification
	-- An alphanumeric unique identifier
	certification_credential	varchar2(1000),
	start_date					date,
	certification_date			date,
	expiration_date				date,
		constraint				inst_cert_expire_ge_start_ck check (start_date is null or expiration_date is null or expiration_date >= start_date)
);

comment on column inst_certifications.start_date is '
This field describes when the party began acquiring this certification.
';
