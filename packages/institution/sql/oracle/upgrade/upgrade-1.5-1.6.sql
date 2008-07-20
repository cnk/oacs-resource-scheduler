drop sequence inst_certification_sequence;

-- rename PL/SQL packages to have 'inst_' in front of them
@../certification-pkg-create.sql
@../party-supplement-address-pkg-create.sql
@../party-supplement-email-pkg-create.sql
@../party-supplement-phone-pkg-create.sql
@../party-supplement-url-pkg-create.sql
drop package certification;
drop package party_address;
drop package party_email;
drop package party_phone;
drop package party_url;

-- faculty, publication (PL/SQL + DM changes), resumes, party-images, and
--	subsite-for-party-relationships were added since v1.5.0
@../faculty-create.sql
@../faculty-oacsmd-create.sql
@../faculty-pkg-create.sql
-- ALREADY CREATED TABLE, no need for: @../publication-create.sql
alter table inst_publications add publication blob;
alter table inst_publications add publication_type varchar2(100);
alter table inst_publications add publisher varchar2(100);
@../publication-oacsmd-create.sql
@../publication-pkg-create.sql
@../publication-map-create.sql
@../resume-create.sql
@../resume-oacsmd-create.sql
@../resume-pkg-create.sql
@../party-image-create.sql
@../party-image-oacsmd-create.sql
@../party-image-pkg-create.sql
@../subsite-for-party-rel-create.sql
@../subsite-for-party-rel-oacsmd-create.sql
@../subsite-for-party-rel-pkg-create.sql

-- -----------------------------------------------------------------------------
-- re-define PL/SQL that references the packages renamed/created above ---------
-- -----------------------------------------------------------------------------
@../personnel-pkg-create.sql
@../group-pkg-create.sql

alter table inst_groups add constraint inst_grp_shrt_nm_prnt_un unique (parent_group_id, short_name);

-- -----------------------------------------------------------------------------
-- create some default categories ----------------------------------------------
-- -----------------------------------------------------------------------------
@../required-categories-create

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- This was done in the v1.3 to v1.4 update but was _not_ in the v1.4 data model,
-- so this needs to be run on any v1.4 installs that were not upgraded from v1.3.
begin
	-- Change primary key from being _only_ the acs_rel_id to being the
	-- combination of acs_rel_id and title_id.
	execute immediate 'alter table inst_group_personnel_map drop constraint inst_gpm_acs_rel_id_pk';
	execute immediate 'alter table inst_group_personnel_map add constraint inst_gpm_pk primary key(title_id, acs_rel_id)';
	exception when others then null;
end;
/

begin
	-- Add new column for ordering the titles a person has.
	-- This replaces the functionality of primary_title_p.
	execute immediate 'alter table inst_group_personnel_map add title_priority_number integer';
	execute immediate 'alter table inst_group_personnel_map drop column primary_title_p';
	exception when others then null;
end;
/

-- -----------------------------------------------------------------------------
-- add a status column that references categories ------------------------------
-- -----------------------------------------------------------------------------
begin
	-- these are already in Healthsciences DBs, so ignore the exceptions
	execute immediate 'alter table inst_group_personnel_map add status_id integer';
	execute immediate 'alter table inst_group_personnel_map add constraint inst_gpm_status_id_fk foreign key(status_id) references categories(category_id)';
	exception when others then null;
end;
/
