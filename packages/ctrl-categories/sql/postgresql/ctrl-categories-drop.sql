-- -*- tab-width: 4 -*- --
--
-- packages/ctrl-categories/sql/postgres/categories-drop.sql
--
-- A drop script for categories
--
-- @author		helsleya@cs.ucr.edu (AH)
-- @author		cnk@caltech.edu (CNK) -- postgres port
-- @creation-date	2003-07-17
-- @cvs-id		$Id:$
--

create function inline_0 ()
returns integer as '
declare
    c     record;
begin
	-- drop instances
	for c in select	object_id from acs_objects where object_type = ''ctrl_category'' loop
        raise notice ''c is %'', c.object_id;
        perform ctrl_category__delete(c.object_id);
    end loop;

    return 0;

end;' language 'plpgsql';

select inline_0 ();
drop function inline_0(); 

-- drop plpgsql package
select drop_package('ctrl_category');

-- drop OpenACS metadata
select acs_object_type__drop_type('ctrl_category', 'f');


-- drop DDL objects
drop index ctrl_categories_enabled_p_idx;
drop index ctrl_categories_name_idx;
drop trigger ctrl_category_insert_tr on ctrl_categories;
drop trigger ctrl_category_update_tr on ctrl_categories;
drop function ctrl_category_insert_tr();
drop function ctrl_category_update_tr();
drop table ctrl_categories;
