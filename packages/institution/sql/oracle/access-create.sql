-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/access-create.sql
--
-- UCLA ACCESS specific data.
--
-- @author			helsleya@cs.ucr.edu
-- @creation-date	2004-03-05
-- @cvs-id			$Id: access-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

create table access_personnel (
	personnel_id			integer			not null
		constraint			access_psnl_personnel_id_pk primary key,
		constraint  		access_psnl_personnel_id_fk foreign key (personnel_id) references inst_personnel(personnel_id),
	affinity_group_id		integer,
		constraint			access_affnty_group_id_fk foreign key(affinity_group_id) references groups(group_id),
	affinity_group_id_2		integer,
		constraint			access_affnty_group_id_2_fk foreign key(affinity_group_id_2) references groups(group_id),
	selected_pblctn_for_guide_id_1	integer,
		constraint			access_slctd_pblctn_1_fk foreign key (selected_pblctn_for_guide_id_1) references inst_publications(publication_id),
	selected_pblctn_for_guide_id_2	integer,
		constraint			access_slctd_pblctn_2_fk foreign key (selected_pblctn_for_guide_id_2) references inst_publications(publication_id),
	selected_pblctn_for_guide_id_3	integer,
		constraint			access_slctd_pblctn_3_fk foreign key (selected_pblctn_for_guide_id_3) references inst_publications(publication_id)
);
