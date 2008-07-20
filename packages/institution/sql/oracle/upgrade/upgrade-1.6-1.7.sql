@../personnel-pkg-create.sql

-- -----------------------------------------------------------------------------
-- These changes didn't work properly in upgrade v1.5-v1.6 due to a syntax error
-- that was masked by the exception handling.  Now the exception handling will
-- serve to make sure that creation of duplicate objects will not short-circuit
-- the creation of others.
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- This field is an aggregate of all of the degree certifications of personnel
-- -----------------------------------------------------------------------------
alter table inst_personnel add degree_titles varchar2(100);
create or replace trigger inst_prsnl_titles_agg_synch
after insert or update or delete on inst_certifications
declare
	md_title_id					categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Medical Degree');
	other_degree_title_id		categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Degree');
	last_prsnl_id				inst_personnel.personnel_id%TYPE				:= null;
	last_certification_type_id	inst_certifications.certification_type_id%TYPE	:= null;
	certs_agg					varchar2(100)									:= '';
begin
	-- clear all aggregated titles
	update inst_personnel set degree_titles = null;

	-- update for each personnel
	for pc in (select	distinct personnel_id,
						certification_type_id,
						cats.name as certification_name,
						cats.profiling_weight
				 from	inst_certifications 			certs,
						inst_personnel					prsnl,
						categories						cats
				where	certs.party_id					= prsnl.personnel_id
				  and	certs.certification_type_id		= cats.category_id
				  and	(cats.parent_category_id		= md_title_id
						or cats.parent_category_id		= other_degree_title_id)
				  and	cats.enabled_p					= 't'
				order	by personnel_id, certification_type_id, profiling_weight) loop

		if pc.personnel_id = last_prsnl_id then
			if certs_agg is not null then
				certs_agg := certs_agg || pc.certification_name || ', ';
			end if;
		elsif last_prsnl_id is not null then
			certs_agg		:= substr(certs_agg, 1, length(certs_agg)-2);

			-- update inst_personnel
			update	inst_personnel ip
			   set	degree_titles	= certs_agg
			 where	ip.personnel_id	= last_prsnl_id;

			-- initialize certs_agg, setup for next personnel
			certs_agg		:= pc.certification_name || ', ';
		end if;
		last_prsnl_id	:= pc.personnel_id;
	end loop;
end;
/
show errors;

-- populate the field in each row by running the trigger once
declare
	md_title_id					categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Medical Degree');
	other_degree_title_id		categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Degree');
	last_prsnl_id				inst_personnel.personnel_id%TYPE				:= null;
	last_certification_type_id	inst_certifications.certification_type_id%TYPE	:= null;
	certs_agg					varchar2(100)									:= '';
begin
	-- clear all aggregated titles
	update inst_personnel set degree_titles = null;

	-- update for each personnel
	for pc in (select	distinct personnel_id,
						certification_type_id,
						cats.name as certification_name,
						cats.profiling_weight
				 from	inst_certifications 			certs,
						inst_personnel					prsnl,
						categories						cats
				where	certs.party_id					= prsnl.personnel_id
				  and	certs.certification_type_id		= cats.category_id
				  and	(cats.parent_category_id		= md_title_id
						or cats.parent_category_id		= other_degree_title_id)
				  and	cats.enabled_p					= 't'
				order	by personnel_id, certification_type_id, profiling_weight) loop

		if pc.personnel_id = last_prsnl_id then
			if certs_agg is not null then
				certs_agg := certs_agg || pc.certification_name || ', ';
			end if;
		elsif last_prsnl_id is not null then
			certs_agg		:= substr(certs_agg, 1, length(certs_agg)-2);

			-- update inst_personnel
			update	inst_personnel ip
			   set	degree_titles	= certs_agg
			 where	ip.personnel_id	= last_prsnl_id;

			-- initialize certs_agg, setup for next personnel
			certs_agg		:= pc.certification_name || ', ';
		end if;
		last_prsnl_id	:= pc.personnel_id;
	end loop;
end;
/
show errors;
