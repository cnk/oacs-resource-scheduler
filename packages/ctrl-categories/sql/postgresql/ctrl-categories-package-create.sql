-- -*- tab-width: 4 -*- -
--
-- packages/ctrl-categories/sql/oracle/categories-body-create.sql
--
-- Package for finding and adding categories.
--
-- @author          helsleya@cs.ucr.edu (AH)
-- @author          cnk@caltech.edu (CNK) -- postgres port
-- @creation-date   2008-08-02
-- @cvs-id          $Id:$
--

-- function new  --------------------------------------------------------------

select define_function_args('ctrl_category__new','parent_category_id,name,plural,description,enabled_p;t,profiling_weight;1,object_type;ctrl_category,creation_user,creation_ip,context_id');

create or replace function ctrl_category__new (integer,varchar,varchar,varchar,char,integer,varchar,integer,varchar,integer)
returns integer as '
declare 
        new__parent_category_id     alias for $1;   -- default null,
        new__name                   alias for $2; 
        new__plural                 alias for $3;   -- default null,
        new__description            alias for $4;   -- default null,
        new__enabled_p              alias for $5;   -- default ''t'',
        new__profiling_weight       alias for $6;   -- default 1,
        new__object_type            alias for $7;   -- default ''ctrl_category'',
        new__creation_user          alias for $8;   -- default null,
        new__creation_ip            alias for $9;   -- default null,
        new__context_id             alias for $10;  -- default null

        -- variables to satisfy acs_object__new signature
        v_creation_date             date;           --  default null
        v_object_id                 integer;        -- default null

        -- return var
        v_category_id               integer;

    begin

        v_category_id := acs_object__new (
            v_object_id,
            new__object_type,
            v_creation_date,
            new__creation_user,
            new__creation_ip,
			new__context_id
		);

		insert into ctrl_categories (
				category_id,
				Parent_category_id,
				name,
				plural,
				description,
				enabled_p,
				profiling_weight
			) values (
				v_category_id,
				new__parent_category_id,
				new__name,
				new__plural,
				new__description,
				new__enabled_p,
				new__profiling_weight
		);

		if new__creation_user is not null then
			PERFORM acs_permission__grant_permission(
				v_category_id,
				new__creation_user,
				''admin''
			);
		end if;

		return v_category_id;

end;' language 'plpgsql';

-- function delete  --------------------------------------------------------------

select define_function_args('ctrl_category__delete','category_id');

create or replace function ctrl_category__delete (integer)
returns integer as '
declare 
	p_category_id		alias for $1;
    c                   record;

    begin
		for c in (select subtree.category_id
					from ctrl_categories parent, ctrl_categories subtree
				  where subtree.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
                    and parent.category_id = p_category_id
				   order by subtree.tree_sortkey desc) loop
			delete from ctrl_categories
			 where category_id = c.category_id;
			perform acs_object__delete(c.category_id);
		end loop;
end;' language 'plpgsql';



-- function name  --------------------------------------------------------------

select define_function_args('ctrl_category__name','category_id');

create or replace function ctrl_category__name (integer)
returns ctrl_categories.name%TYPE as '
declare 
    v_category_id           alias for $1;
	v_name                  ctrl_categories.name%TYPE;

	begin
		select distinct c.name into v_name
		  from ctrl_categories c
		 where c.category_id = v_category_id;
	return v_name;

end;' language 'plpgsql';

-- function get_subcat  --------------------------------------------------------------

select define_function_args('ctrl_category__get_subcat','parent_cat_id,subcat_name,create_p;f,description,enabled_p,profiling_weight');

create or replace function ctrl_category__get_subcat (ctrl_categories.category_id%TYPE, ctrl_categories.name%TYPE, char, ctrl_categories.description%TYPE,  ctrl_categories.enabled_p%TYPE,	ctrl_categories.profiling_weight%TYPE)
returns ctrl_categories.category_id%TYPE as '
declare 
		parent_cat_id		alias for $1;
		subcat_name			alias for $2;
		create_p			alias for $3;   --	default should be ''f''
		description			alias for $4;   --	default null
		enabled_p			alias for $5;   --	default null
		profiling_weight	alias for $6;   --	default null
        v_subcat_id         integer := null;
	begin
		-- we need to use a slightly different query when the parent category id we want is null
		if parent_cat_id is null then
			begin
				select category_id into v_subcat_id
				  from ctrl_categories
				 where parent_category_id is null
				   and name = subcat_name;
                if not found then
				    v_subcat_id := null;
                end if;
			end;
		else
			begin
				select category_id into v_subcat_id
				  from ctrl_categories
				 where parent_category_id = parent_cat_id
				   and name = subcat_name;
                if not found then
				    v_subcat_id := null;
                end if;
			end;
		end if;


		-- if the subcat was not found
		if v_subcat_id is null then
			-- if we are not supposed to create a subcat, return null
			if lower(create_p) = ''f'' then
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
end;' language 'plpgsql';

-- function get_subcat - with defaults ----------------------------------------------------------

create or replace function ctrl_category__get_subcat (ctrl_categories.category_id%TYPE, ctrl_categories.name%TYPE)
returns ctrl_categories.category_id%TYPE as '
declare 
		parent_cat_id		alias for $1;
		subcat_name			alias for $2;
		create_p			char := ''f'';
		description			ctrl_categories.description%TYPE := NULL;
		enabled_p			ctrl_categories.enabled_p%TYPE := NULL;   
		profiling_weight	ctrl_categories.profiling_weight%TYPE := NULL;
        v_subcat_id         integer := null;
	begin
        select ctrl_category__get_subcat(parent_cat_id, subcat_name, create_p, description, enabled_p, profiling_weight) into v_subcat_id;

		return v_subcat_id;
end;' language 'plpgsql';


-- function lookup  --------------------------------------------------------------

	-- Lookup a category_id by specifying a "path" of categories to look under.
	-- Example:
	--		//Certification Type//Education//Medical Degree//MD
	-- This function can create categories along the way if they don't exist.
	-- In such a case, 'description', 'enabled_p' and 'profiling_weight' will
	-- only be set for the last category created.  All of the other created
	-- categories will have the defaults for those attributes.

	-- a series of uninterrupted '//' pairs should act like a single '//'
	-- a leading '//' should be ignored		(in future, without leading '//' will find un-rooted segments)
	-- a trailing '//' should be ignored	(in future, should check that there are no child categories?)

select define_function_args('ctrl_category__lookup','category_id');

create or replace function ctrl_category__lookup (varchar,ctrl_categories.category_id%TYPE, char,ctrl_categories.description%TYPE,ctrl_categories.enabled_p%TYPE, ctrl_categories.profiling_weight%TYPE)
returns ctrl_categories.category_id%TYPE as '
declare
		path			alias for $1;
		root			alias for $2;   -- default null
		create_p		alias for $3;   -- default ''f''
		description		alias for $4;   -- default null
		enabled_p		alias for $5;   -- default null
		profiling_weight alias for $6;  -- default null
        v_create_p  char                        :=''f'';
		v_ppos		integer						:= 1;
		v_next		integer						:= 1;
		v_nname		ctrl_categories.name%TYPE			:= '''';
		found_id	ctrl_categories.category_id%TYPE		:= root;
	begin
		-- make sure root node exists before using it
        -- CNK not sure this check is ported correctly; figure out how to test
		if root is not null then
			begin
				select category_id into found_id from ctrl_categories where category_id = root;
				if not found then 
                    return null;
                end if;
			end;
		end if;

        if create_p is not null then
            v_create_p := create_p;
        end if;

		while next > 0 loop
			-- find end of name of subcategory
			v_next	:= instr(path, ''//'', v_ppos);

			-- extract name of subcategory
			if v_next <= 0 then
				v_nname := substr(path, v_ppos);
			else
				v_nname := substr(path, v_ppos, v_next - v_ppos);
			end if;

			-- only look for a subcategory if there is a name to look for
			if length(v_nname) > 0 then
				if v_next > 0 then
					found_id := get_subcat(found_id, v_nname, v_create_p);
				else
					found_id := get_subcat(found_id, v_nname, v_create_p,
											description, enabled_p, profiling_weight);
				end if;

				exit when found_id is null;
			end if;

			v_ppos	:= v_next + 2;
		end loop;

		return found_id;
end;' language 'plpgsql';


-- helper function for tree_sortkeys -----------

create or replace function ctrl_categories__get_tree_sortkey(integer) returns varbit as '
declare
  p_category_id    alias for $1;
begin
  return tree_sortkey from ctrl_categories where category_id = p_category_id;
end;' language 'plpgsql' stable strict;


-- function pathto  --------------------------------------------------------------


select define_function_args('ctrl_category__pathto','category_id');

create or replace function ctrl_category__pathto (ctrl_categories.category_id%TYPE)
returns varchar as '
declare
		v_category_id		alias for $1;
		path		        varchar(4000) := null;
        c                   record;
	begin
		for c in (select ctrl_categories.name
					from ctrl_categories,
                    (select tree_ancestor_keys(ctrl_categories__get_tree_sortkey(v_category_id)) as tree_sortkey) parents
                    where ctrl_categories.tree_sortkey = parents.tree_sortkey 
				   order by ctrl_categories.tree_sortkey desc) loop
			path := path || ''//'' || c.name;
		end loop;

		return path;

end;' language 'plpgsql';


-- //TODO - unfinished in oracle version too// 
--  create a trigger on updates to ctrl_categories.parent_category_id
--	if new.parent_category_id is null:
--		if old.parent_category_id is not null
--			:package_id := (context_id of root ancestor category);
--			new.acs_objects.context_id	= :package_id
--		end if;
--	else if nvl(-1,new.parent_category_id) <> nvl(-1,old.parent_category_id)
--		new.acs_objects.context_id	= new.parent_category_id
