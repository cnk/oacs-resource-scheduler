-- /packages/ctrl-subsite/sql/postgresql/subsite-for-object-rel-pkg-create.sql
--
-- Package for relating subsites to objects
--
-- @author		avni@avni.net (AK)
-- @creation-date	2007-07-22
-- @update-date		2008-08-08 (ported to postgres)
-- @cvs-id $Id$
--

select define_function_args('ctrl_subsite_for_object_rel__new','subsite_id,object_id,creation_user,creation_ip,rel_type;ctrl_subsite_for_object_rel,rel_id');

create or replace function ctrl_subsite_for_object_rel__new(integer,integer,integer,varchar,varchar,integer)
returns integer as '
declare 
	new__subsite_id		alias for $1;
	new__object_id		alias for $2;
	new__creation_user	alias for $3;	-- default null
	new__creation_ip	alias for $4;	-- default null
	new__rel_type		alias for $5;	-- default ''ctrl_subsite_for_object_rel''
	new__rel_id		alias for $6;	-- default null
	v_rel_id		acs_rels.rel_id%TYPE;
begin
	v_rel_id := acs_rel__new(
		rel_id			=> rel_id,
		rel_type		=> rel_type,
		object_id_one		=> subsite_id,
		object_id_two		=> object_id,
		context_id		=> subsite_id,
		creation_user		=> creation_user,
		creation_ip		=> creation_ip
	);

	insert into ctrl_subsite_for_object_rels	(rel_id)
	values						(v_rel_id);

	return v_rel_id;
end;' language 'plpgsql';

create or replace function ctrl_subsite_for_object_rel__delete(integer)
returns integer as '
declare
	delete__rel_id alias for $1;	
begin
	PERFORM acs_rel__delete(delete__rel_id);

	delete from ctrl_subsite_for_object_rels
	where  rel_id = delete__rel_id;

	return 0;

end;' language 'plpgsql';

