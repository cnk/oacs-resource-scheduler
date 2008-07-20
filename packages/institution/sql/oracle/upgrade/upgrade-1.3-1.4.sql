-- /packages/institution/sql/oracle/
--
-- Upgrades for the PPLUS Data model 
--
-- @author nick@ucla.edu
-- @creation-date 2004/02/18
-- @cvs-id $Id: upgrade-1.3-1.4.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

alter table inst_publications add publication blob;
alter table inst_publications drop column pages;
alter table inst_publications add page_ranges varchar2(1000);

alter table inst_publications add publication_type varchar2(100);
alter table inst_publications add publisher varchar2(100);

create table inst_personnel_publication_map (
	publication_id		integer ,
		constraint inst_pubmap_publication_id_fk foreign key (publication_id) references inst_publications(publication_id),
	personnel_id		integer ,
		constraint inst_pubmap_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	mapping_date		date default sysdate,
	constraint 	inst_pubmap_pk primary key(publication_id, personnel_id)
);

alter table inst_group_personnel_map drop column primary_title_p;
alter table inst_group_personnel_map add title_priority_number integer;

alter table inst_group_personnel_map drop constraint inst_gpm_acs_rel_id_pk;
alter table inst_group_personnel_map add constraint inst_gpm_pk primary key(title_id, acs_rel_id);


-- NEED to manually drop not null constriants on the table inst_group_personnel_map, columns: title_id, primary_title_p, leader_p if
-- the constraints exist, since removed from group-create.sql on 2/18/2004
