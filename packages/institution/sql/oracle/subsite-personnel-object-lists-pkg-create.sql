-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/party-supplement-pkg-create.sql
--
-- Package for managing lists of objects belonging to personnel which
-- should be displayed and which order they should be displayed in.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2005-03-09
-- @cvs-id			$Id: subsite-personnel-object-lists-pkg-create.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

-- -----------------------------------------------------------------------------
-- ---------------------- SUBSITE-PERSONNEL-OBJECT LISTS -----------------------
-- -----------------------------------------------------------------------------

-- declare package -------------------------------------------------------------
create or replace package inst_subsite_psnl_obj_list
as
	-- Return the subsite_id of best list for personnel in order of precedence:
	--	1: subsite_id that was passed in if a list exists for that subsite
	--	2: subsite_id of the main site if a list exists for that subsite
	--	3: null
	function best_subsite_id(
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE,
		object_type		in acs_object_types.object_type%TYPE
	) return apm_packages.package_id%TYPE;

	-- If the provided subsite_id has no list, make a copy of the main site's
	--	list (the default list).  Return 't' if a copy was made.
	function maybe_copy(
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE,
		object_type		in acs_object_types.object_type%TYPE
	) return char;

	-- Use this when a new object is created.
	procedure object_created(
		object_id		in acs_objects.object_id%TYPE,
		in_context_p	in inst_subsite_psnl_obj_lists.in_context_p%TYPE	default 't',
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE
	);

	-- Use this when a new object is deleted.
	procedure object_deleted(
		object_id		in acs_objects.object_id%TYPE
	);

	-- Use this to delete a whole lists.  Null --> delete all.
	procedure delete(
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE,
		object_type		in acs_object_types.object_type%TYPE				default null
	);
end inst_subsite_psnl_obj_list;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body inst_subsite_psnl_obj_list
as
	function best_subsite_id(
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE,
		object_type		in acs_object_types.object_type%TYPE
	) return apm_packages.package_id%TYPE is
		result_subsite_id	apm_packages.package_id%TYPE;
	begin
		begin
			select	best_subsite_id.subsite_id
			  into	result_subsite_id
			  from	dual
			 where	exists
					(select	1
					   from	inst_subsite_psnl_obj_lists	list,
							acs_objects					objs
					  where	list.subsite_id		= inst_subsite_psnl_obj_list.best_subsite_id.subsite_id
						and	list.personnel_id	= inst_subsite_psnl_obj_list.best_subsite_id.personnel_id
						and	objs.object_type	= inst_subsite_psnl_obj_list.best_subsite_id.object_type
						and	list.object_id		= objs.object_id);
			exception when no_data_found then begin
				select	sn.object_id
				  into	result_subsite_id
				  from	site_nodes		sn
				 where	sn.parent_id	is null
				   and	exists
						(select	1
						   from	inst_subsite_psnl_obj_lists	list,
								acs_objects					objs
						  where	list.subsite_id		= (select	sn.object_id
														 from	site_nodes sn
														where	sn.parent_id is null)
							and	list.personnel_id	= inst_subsite_psnl_obj_list.best_subsite_id.personnel_id
							and	objs.object_type	= inst_subsite_psnl_obj_list.best_subsite_id.object_type
							and	list.object_id		= objs.object_id);
				exception when no_data_found then begin
					return null;
				end;
			end;
		end;
		return result_subsite_id;
	end;

	function maybe_copy(
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE,
		object_type		in acs_object_types.object_type%TYPE
	) return char is
		v_main_subsite_id	integer;
		n 					integer;
	begin
		select	object_id
		  into	v_main_subsite_id
		  from	site_nodes
		 where	parent_id is null;

		select	count(*) into n
		  from	inst_subsite_psnl_obj_lists	list,
				acs_objects					objs
		 where	list.object_id		= objs.object_id
		   and	objs.object_type	= inst_subsite_psnl_obj_list.maybe_copy.object_type
		   and	list.subsite_id		= inst_subsite_psnl_obj_list.maybe_copy.subsite_id
		   and	list.personnel_id	= inst_subsite_psnl_obj_list.maybe_copy.personnel_id;

		if n <= 0 then
			insert into inst_subsite_psnl_obj_lists (
					subsite_id,
					personnel_id,
					object_id,
					relative_order,
					in_context_p
				) select	inst_subsite_psnl_obj_list.maybe_copy.subsite_id,
							list.personnel_id,
							list.object_id,
							list.relative_order,
							list.in_context_p
					from	inst_subsite_psnl_obj_lists	list,
							acs_objects					objs
				   where	list.object_id		= objs.object_id
					 and	objs.object_type	= inst_subsite_psnl_obj_list.maybe_copy.object_type
					 and	list.subsite_id		= v_main_subsite_id
					 and	list.personnel_id	= inst_subsite_psnl_obj_list.maybe_copy.personnel_id;
			if sql%rowcount > 0 then
				return 't';
			end if;
			return null;
		end if;

		return 'f';
	end;

	procedure object_created(
		object_id		in acs_objects.object_id%TYPE,
		in_context_p	in inst_subsite_psnl_obj_lists.in_context_p%TYPE	default 't',
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE
	) is
	begin
		--//TODO//
		null;
	end;

	procedure object_deleted(
		object_id		in acs_objects.object_id%TYPE
	) is
	begin
		--//TODO//
		null;
	end;

	procedure delete(
		subsite_id		in apm_packages.package_id%TYPE						default null,
		personnel_id	in inst_personnel.personnel_id%TYPE,
		object_type		in acs_object_types.object_type%TYPE				default null
	) is
	begin
		--//TODO//
		null;
	end;
end inst_subsite_psnl_obj_list;
/
show errors;
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
