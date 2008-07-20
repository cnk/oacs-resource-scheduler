-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/certification-pkg-create.sql
--
-- Certification object package for recording various kinds of certifications:
--	Awards, Education, Degrees, Licenses, etc.
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-08-18
-- @cvs-id $Id: certification-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- declare package -------------------------------------------------------------
create or replace package inst_certification
as
	-- constructor --
	function new (
		certification_id	in inst_certifications.certification_id%TYPE			default null,
		owner_id			in inst_certifications.party_id%TYPE,
		type_id				in inst_certifications.certification_type_id%TYPE,
		party				in inst_certifications.certifying_party%TYPE			default null,
		certifying_party	in inst_certifications.certifying_party%TYPE			default null,
		credential			in inst_certifications.certification_credential%TYPE	default null,
		start_date			in inst_certifications.start_date%TYPE					default null,
		certification_date	in inst_certifications.certification_date%TYPE			default null,
		expiration_date		in inst_certifications.expiration_date%TYPE				default null,

		object_type			in acs_object_types.object_type%TYPE					default 'certification',
		creation_date		in acs_objects.creation_date%TYPE						default sysdate,
		creation_user		in acs_objects.creation_user%TYPE						default null,
		creation_ip			in acs_objects.creation_ip%TYPE							default null,
		context_id			in acs_objects.context_id%TYPE							default null
	) return inst_certifications.certification_id%TYPE;

	-- destructor --
	procedure delete (
		certification_id	in inst_certifications.certification_id%TYPE
	);
end inst_certification;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_certification
as
	-- constructor --
	function new (
		certification_id	in inst_certifications.certification_id%TYPE			default null,
		owner_id			in inst_certifications.party_id%TYPE,
		type_id				in inst_certifications.certification_type_id%TYPE,
		party				in inst_certifications.certifying_party%TYPE			default null,
		certifying_party	in inst_certifications.certifying_party%TYPE			default null,
		credential			in inst_certifications.certification_credential%TYPE	default null,
		start_date			in inst_certifications.start_date%TYPE					default null,
		certification_date	in inst_certifications.certification_date%TYPE			default null,
		expiration_date		in inst_certifications.expiration_date%TYPE				default null,

		object_type			in acs_object_types.object_type%TYPE					default 'certification',
		creation_date		in acs_objects.creation_date%TYPE						default sysdate,
		creation_user		in acs_objects.creation_user%TYPE						default null,
		creation_ip			in acs_objects.creation_ip%TYPE							default null,
		context_id			in acs_objects.context_id%TYPE							default null
	) return inst_certifications.certification_id%TYPE
	 is
		v_certification_id	integer;
	begin
		v_certification_id := certification_id;

		v_certification_id := acs_object.new (
			object_id		=> v_certification_id,
			object_type		=> object_type,
			creation_date	=> creation_date,
			creation_user	=> creation_user,
			creation_ip		=> creation_ip,
			context_id		=> context_id
		);

		insert into inst_certifications (
				certification_id,
				party_id,
				certification_type_id,
				certifying_party,
				certification_credential,
				start_date,
				certification_date,
				expiration_date
			) values (
				v_certification_id,
				owner_id,
				type_id,
				party,
				credential,
				start_date,
				certification_date,
				expiration_date
		);
		return v_certification_id;
	end new;

	-- destructor --
	procedure delete (
		certification_id		in inst_certifications.certification_id%TYPE
	) is
		v_certification_id		integer;
	begin
		v_certification_id := certification_id;

		delete from acs_rels
		where object_id_one = v_certification_id
		   or object_id_two = v_certification_id;

		delete from acs_permissions
		where object_id = v_certification_id;

		delete from inst_certifications
		where certification_id = v_certification_id;

		acs_object.delete(v_certification_id);
	end delete;
end inst_certification;
/
show errors;

-- -----------------------------------------------------------------------------
-- This maintains the field in inst_personnel that is an aggregate of all of the
-- degree certifications of all personnel
-- -----------------------------------------------------------------------------
create or replace trigger inst_prsnnl_deg_titles_agg_tr
after insert or update or delete on inst_certifications
declare
	md_title_id					categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Medical Degree');
	other_degree_title_id		categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Degree');
	last_prsnl_id				inst_personnel.personnel_id%TYPE				:= null;
	last_certification_type_id	inst_certifications.certification_type_id%TYPE	:= null;
	certs_agg					varchar2(100)									:= '';
begin
	-- clear all aggregated titles
	update inst_personnel
	   set degree_titles = null;

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
				  and	cats.name						not in (
							'A.B.', 'B.A.', 'B.S.', 'B.S.N.',
							'M.A.', 'M.N.', 'M.S.', 'B.Sc.'
						)
				  and	cats.enabled_p					= 't'
				order	by personnel_id, profiling_weight, certification_type_id) loop

		if pc.personnel_id = last_prsnl_id then
			certs_agg := certs_agg || ', ' || pc.certification_name;
		elsif last_prsnl_id is not null then
			-- update inst_personnel since this is now a different person
			-- and there was a non-null last-person
			update	inst_personnel ip
			   set	degree_titles	= certs_agg
			 where	ip.personnel_id	= last_prsnl_id;

			-- initialize certs_agg, setup for next personnel
			certs_agg		:= pc.certification_name;
		else
			-- initialize certs_agg for first person, setup for next personnel
			certs_agg		:= pc.certification_name;
		end if;
		last_prsnl_id	:= pc.personnel_id;
	end loop;

	-- update LAST inst_personnel
	update	inst_personnel ip
	   set	degree_titles	= certs_agg
	 where	ip.personnel_id	= last_prsnl_id;
end;
/
show errors;

-- -----------------------------------------------------------------------------
/*	-- This smaller, more targeted trigger is rife with "data is mutating"
	-- errors because it attempts to iterate over the rows after the changes
	-- have been accepted.  Strangely, the trigger above has no such problems,
	-- though it iterates over a much larger set of rows.  Note how the 'nvl()'
	-- forces a NULL value in only one of 'old' or 'new' to cause an update.
create or replace trigger inst_prsnnl_deg_titles_agg_tr
	after insert or update or delete of certification_type_id on inst_certifications
	referencing new as new old as old
	for each row when (nvl(new.certification_type_id,0) <> nvl(old.certification_type_id,0))
declare
	md_title_id				categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Medical Degree');
	other_degree_title_id	categories.category_id%TYPE	:= category.lookup('//Certification Type//Education//Degree');
	party_is_personnel_p	integer := 0;
	certs_agg				varchar2(500)	:= '';
begin
	select	count(*) into party_is_personnel_p
	  from	inst_personnel
	 where	personnel_id	= :old.party_id;

	if party_is_personnel_p > 0 then
		-- clear the aggregated degree_title
		update	inst_personnel ip
		   set	degree_titles	= null
		 where	ip.personnel_id	= :old.party_id;

		-- concatenate the names of the degrees
		for pc in (select	distinct
							crt.certification_type_id,
							typ.name as certification_name,
							typ.profiling_weight
					 from	inst_certifications 			crt,
							inst_personnel					psnl,
							categories						typ
					where	crt.party_id					= psnl.personnel_id
					  and	crt.certification_type_id		= typ.category_id
					  and	(typ.parent_category_id			= md_title_id
							or typ.parent_category_id		= other_degree_title_id)
					  and	typ.name						not in (
								'A.B.', 'B.A.', 'B.S.', 'B.S.N.',
								'M.A.', 'M.N.', 'M.S.', 'B.Sc.'
							)
					  and	typ.enabled_p					= 't'
					  and	psnl.personnel_id				= :old.party_id
					order	by
							profiling_weight,
							certification_type_id
					) loop
			certs_agg := certs_agg || ', ' || pc.certification_name;
		end loop;

		-- save the aggregated degree_title
		update	inst_personnel ip
		   set	degree_titles	= certs_agg
		 where	ip.personnel_id	= :old.party_id;
	end if;
end;
/
show errors;
*/