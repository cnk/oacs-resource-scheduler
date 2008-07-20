-- packages/institution/sql/oracle/publication-map-create.sql
--
-- Data model for publication map part of institution package.
--
-- @author nick@ucla.edu
-- @creation-date	2004/02/09
-- @cvs-id $Id: publication-map-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table inst_personnel_publication_map (
	publication_id		integer ,
		constraint inst_pubmap_publication_id_fk foreign key (publication_id) references inst_publications(publication_id),
	personnel_id		integer ,
		constraint inst_pubmap_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	mapping_date		date default sysdate,
	constraint 	inst_pubmap_pk primary key(publication_id, personnel_id)
);

create table inst_psnl_publ_ordered_subsets (
	subsite_id			integer,
		constraint inst_pp_ordrd_ss_subsite_id_fk foreign key (subsite_id) references apm_packages(package_id),
	publication_id		integer,
		constraint inst_pp_ordrd_ss_publctn_id_fk foreign key (publication_id) references inst_publications(publication_id),
	personnel_id		integer,
		constraint inst_pp_ordrd_ss_persnnl_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	relative_order		integer,
	constraint 	inst_psnl_publ_ordrd_sbsts_pk primary key(subsite_id, publication_id, personnel_id),
	constraint	inst_psnl_publ_ordrd_sbsts_fk foreign key(personnel_id,publication_id) references inst_personnel_publication_map(personnel_id,publication_id)
);