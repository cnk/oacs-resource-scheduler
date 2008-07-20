-- -*- tab-width: 4 -*- ---
--
-- packages/institution/sql/oracle/external-id-mapping-create.sql
--
-- Data model for table to map institution primary keys to external systems' primary keys
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date	2003/07/22
-- @cvs-id $Id: external-id-mapping-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- a mapping of institution-package Physician IDs to the Morrissey database physician ID
-- add more later as needed
create table inst_external_physician_id_map (
	inst_physician_id		integer constraint inst_extern_phys_id_map_pk primary key,
	morrissey_physician_id	integer
);

create table inst_external_group_id_map (
	inst_group_id			integer constraint inst_extern_grp_id_map_pk primary key,
	handbook_program_id		integer,
	morrissey_hospital_code	integer
);


-- 1/24/2006 AMK
-- A mapping of institution package Publication IDs to the Pubmed database pubmed ID
create table inst_external_pub_id_map (
	inst_publication_id		integer 
		constraint inst_expim_pub_id_nn not null
		constraint inst_expim_pub_id_fk references inst_publications (publication_id),
	pubmed_id				integer
		constraint inst_expim_pubmed_id_nn not null,
	pubmed_xml				clob
		constraint inst_expim_pubmed_xml_nn not null,
	data_imported_p			char(1) default 'f'
		constraint inst_expim_data_import_p_ck check (data_imported_p in ('t','f')),
	constraint inst_expim_pub_id_pubmed_id_un unique (inst_publication_id, pubmed_id)
);

create index inst_extern_pim_pub_id_idx on inst_external_pub_id_map(inst_publication_id);
