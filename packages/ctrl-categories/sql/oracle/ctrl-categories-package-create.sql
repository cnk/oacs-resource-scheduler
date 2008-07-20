-- -*- tab-width: 4 -*- -
--
-- packages/ctrl-categories/sql/oracle/categories-body-create.sql
--
-- Package for finding and adding categories.
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2003-08-21
-- @cvs-id			$Id: ctrl-categories-package-create.sql,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
--

-- declare package -------------------------------------------------------------
create or replace package ctrl_category
as
	function new (
		parent_category_id		in ctrl_categories.parent_category_id%TYPE	default null,
		name					in ctrl_categories.name%TYPE,
		plural					in ctrl_categories.plural%TYPE				default null,
		description				in ctrl_categories.description%TYPE			default null,
		enabled_p				in ctrl_categories.enabled_p%TYPE			default 't',
		profiling_weight		in ctrl_categories.profiling_weight%TYPE	default 1,
		object_type				in acs_objects.object_type%TYPE				default 'ctrl_category',
		creation_user			in acs_objects.creation_user%TYPE			default null,
		creation_ip				in acs_objects.creation_ip%TYPE				default null,
		context_id				in acs_objects.context_id%TYPE				default null
	) return ctrl_categories.category_id%TYPE;

	procedure del (
		category_id		in ctrl_categories.category_id%TYPE
	);

	function name (
		category_id		in ctrl_categories.category_id%TYPE
	) return ctrl_categories.name%TYPE;

	function get_subcat (
		parent_cat_id		in ctrl_categories.category_id%TYPE,
		subcat_name			in ctrl_categories.name%TYPE,
		create_p			in char											default 'f',
		description			in ctrl_categories.description%TYPE				default null,
		enabled_p			in ctrl_categories.enabled_p%TYPE				default null,
		profiling_weight	in ctrl_categories.profiling_weight%TYPE		default null
	) return ctrl_categories.category_id%TYPE;

	-- Lookup a category_id by specifying a "path" of categories to look under.
	-- Example:
	--		//Certification Type//Education//Medical Degree//MD
	-- This function can create categories along the way if they don't exist.
	-- In such a case, 'description', 'enabled_p' and 'profiling_weight' will
	-- only be set for the last category created.  All of the other created
	-- categories will have the defaults for those attributes.
	function lookup (
		path				in varchar2,
		root				in ctrl_categories.category_id%TYPE				default null,
		create_p			in char											default 'f',
		description			in ctrl_categories.description%TYPE				default null,
		enabled_p			in ctrl_categories.enabled_p%TYPE				default null,
		profiling_weight	in ctrl_categories.profiling_weight%TYPE		default null
	) return ctrl_categories.category_id%TYPE;

	function pathto(
		v_category_id		in ctrl_categories.category_id%TYPE
	) return varchar2;
end ctrl_category;
/
show errors;

-- define package --------------------------------------------------------------
create or replace package body ctrl_category
as
	function new (
		parent_category_id		in ctrl_categories.parent_category_id%TYPE	default null,
		name					in ctrl_categories.name%TYPE,
		plural					in ctrl_categories.plural%TYPE				default null,
		description				in ctrl_categories.description%TYPE			default null,
		enabled_p				in ctrl_categories.enabled_p%TYPE			default 't',
		profiling_weight		in ctrl_categories.profiling_weight%TYPE	default 1,
		object_type				in acs_objects.object_type%TYPE				default 'ctrl_category',
		creation_user			in acs_objects.creation_user%TYPE			default null,
		creation_ip				in acs_objects.creation_ip%TYPE				default null,
		context_id				in acs_objects.context_id%TYPE				default null
	) return ctrl_categories.category_id%TYPE
	is
		v_category_id acs_objects.object_id%TYPE;
	begin
		v_category_id := acs_object.new (
			object_type	=> object_type,
			context_id	=> context_id
		);

		insert into ctrl_categories (
				category_id,
				parent_category_id,
				name,
				plural,
				description,
				enabled_p,
				profiling_weight
			) values (
				v_category_id,
				parent_category_id,
				name,
				plural,
				description,
				enabled_p,
				profiling_weight
		);

		if creation_user is not null then
			acs_permission.grant_permission(
				object_id	=> v_category_id,
				grantee_id	=> creation_user,
				privilege	=> 'admin'
			);
		end if;
		return v_category_id;
	end new;

	procedure del (
		category_id		in ctrl_categories.category_id%TYPE
	) is
	begin
		for c in (select category_id
					from ctrl_categories
				  start with category_id = ctrl_category.del.category_id
				  connect by prior category_id = parent_category_id
				   order by level desc) loop
			delete from ctrl_categories
			 where category_id = c.category_id;
			acs_object.del(c.category_id);
		end loop;
	end del;

	function name (
		category_id		in ctrl_categories.category_id%TYPE
	) return ctrl_categories.name%TYPE is
		v_name ctrl_categories.name%TYPE;
	begin
		select distinct c.name into v_name
		  from ctrl_categories c
		 where c.category_id = ctrl_category.name.category_id;
		return v_name;
	end name;


	function get_subcat (
		parent_cat_id		in ctrl_categories.category_id%TYPE,
		subcat_name			in ctrl_categories.name%TYPE,
		create_p			in char											default 'f',
		description			in ctrl_categories.description%TYPE				default null,
		enabled_p			in ctrl_categories.enabled_p%TYPE				default null,
		profiling_weight	in ctrl_categories.profiling_weight%TYPE		default null
	) return ctrl_categories.category_id%TYPE
	is
		v_subcat_id	ctrl_categories.category_id%TYPE;
	begin
		v_subcat_id := null;

		-- we need to use a slightly different query when the parent category id we want is null
		if parent_cat_id is null then
			begin
				select category_id into v_subcat_id
				  from ctrl_categories
				 where parent_category_id is null
				   and name = subcat_name;
				exception when no_data_found then v_subcat_id := null;
			end;
		else
			begin
				select category_id into v_subcat_id
				  from ctrl_categories
				 where parent_category_id = parent_cat_id
				   and name = subcat_name;
				exception when no_data_found then v_subcat_id := null;
			end;
		end if;


		-- if the subcat was not found
		if v_subcat_id is null then
			-- if we are not supposed to create a subcat, return null
			if lower(create_p) = 'f' then
				return v_subcat_id;
			end if;

			-- create the subcategory
			v_subcat_id := ctrl_category.new(
				parent_category_id	=> parent_cat_id,
				name				=> subcat_name,
				plural				=> subcat_name,
				description			=> description,
				enabled_p			=> enabled_p,
				profiling_weight	=> profiling_weight
			);
		end if;

		return v_subcat_id;
	end get_subcat;

	-- a series of uninterrupted '//' pairs should act like a single '//'
	-- a leading '//' should be ignored		(in future, without leading '//' will find un-rooted segments)
	-- a trailing '//' should be ignored	(in future, should check that there are no child categories?)
	function lookup (
		path				in varchar2,
		root				in ctrl_categories.category_id%TYPE				default null,
		create_p			in char											default 'f',
		description			in ctrl_categories.description%TYPE				default null,
		enabled_p			in ctrl_categories.enabled_p%TYPE				default null,
		profiling_weight	in ctrl_categories.profiling_weight%TYPE		default null
	) return ctrl_categories.category_id%TYPE
	is
		ppos		integer							:= 1;
		next		integer							:= 1;
		nname		ctrl_categories.name%TYPE			:= '';
		found_id	ctrl_categories.category_id%TYPE		:= root;
	begin
		-- make sure root node exists before using it
		if root is not null then
			begin
				select category_id into found_id from ctrl_categories where category_id = ctrl_category.lookup.root;
				exception when no_data_found then return null;
			end;
		end if;

		while next > 0 loop
			-- find end of name of subcategory
			next	:= instr(path, '//', ppos);

			-- extract name of subcategory
			if next <= 0 then
				nname := substr(path, ppos);
			else
				nname := substr(path, ppos, next - ppos);
			end if;

			-- only look for a subcategory if there is a name to look for
			if length(nname) > 0 then
				if next > 0 then
					found_id := get_subcat(found_id, nname, create_p);
				else
					found_id := get_subcat(found_id, nname, create_p,
											description, enabled_p, profiling_weight);
				end if;

				exit when found_id is null;
			end if;

			ppos	:= next + 2;
		end loop;

		return found_id;
	end lookup;

	function pathto(
		v_category_id		in ctrl_categories.category_id%TYPE
	) return varchar2
	is
		path		varchar2(4000) := null;
	begin
		for c in (select	name
					from	ctrl_categories
				  connect	by prior parent_category_id = category_id
					start	with category_id = v_category_id
					order	by level desc) loop
			path := path || '//' || c.name;
		end loop;
		return path;
	end pathto;
end ctrl_category;
/
show errors;


-- //TODO// create a trigger on updates to ctrl_categories.parent_category_id
--	if new.parent_category_id is null:
--		if old.parent_category_id is not null
--			:package_id := (context_id of root ancestor category);
--			new.acs_objects.context_id	= :package_id
--		end if;
--	else if nvl(-1,new.parent_category_id) <> nvl(-1,old.parent_category_id)
--		new.acs_objects.context_id	= new.parent_category_id
