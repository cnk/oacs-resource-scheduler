-- INST_PUBLICATIONS - PUBMED DATAMODEL CHANGES

-- 1/24/2006 AMK
-- A mapping of institution package Publication IDs to the Pubmed database pubmed ID
create table inst_external_pub_id_map (
	inst_publication_id		integer 
		constraint inst_extern_pim_pub_id_nn not null
		constraint inst_extern_pim_pub_id_fk references inst_publications (publication_id),
	pubmed_id				integer
		constraint inst_extern_pim_pubmed_id_nn not null,
	pubmed_xml				clob
		constraint inst_extern_pim_pubmed_xml_nn not null,
	data_imported_p			char(1) default 'f'
		constraint inst_extern_pim_dip_ck check (data_imported_p in ('t','f'))
);


commit;

