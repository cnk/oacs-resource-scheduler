-- /packages/institution/sql/oracle/subsite-personnel-research-interests-create.sql
--
-- @author avni@ctrl.ucla.edu (AK)
-- @creation-date 2004/09/16
-- @cvs-id $Id: subsite-personnel-research-interests-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- subsite to personnel map of research interests
create table inst_subsite_pers_res_intrsts (
	subsite_id				integer not null
		constraint			inst_spri_subsite_id_fk references apm_packages(package_id),
	personnel_id				integer not null
		constraint			inst_spri_personnel_id_fk references inst_personnel(personnel_id),
	lay_title				varchar2(4000),
	lay_interest				clob,
	technical_title				varchar2(4000),
	technical_interest			clob,
	constraint inst_spri_rilaynn_ritechnn_ck check (lay_interest is not null or technical_interest is not null),
	constraint inst_spri_subsite_person_pk primary key (subsite_id,personnel_id)
);
