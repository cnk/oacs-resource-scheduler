-- -*- tab-width: 4 -*- --
--
-- packages/ctrl-categories/sql/oracle/categories-drop.sql
--
-- A drop script for categories
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2003-07-17
-- @cvs-id			$Id: ctrl-categories-drop.sql,v 1.1.1.1 2005/05/10 03:08:22 andy Exp $
--

begin
	-- drop instances
	for c in (select	object_id
				from	acs_objects
			   where	object_type = 'ctrl_category') loop
		ctrl_category.del(c.object_id);
	end loop;

	-- drop OpenACS metadata
	acs_object_type.drop_type('ctrl_category');
end;
/
show errors;

-- drop PL/SQL package
drop package ctrl_category;

-- drop DDL objects
drop index ctrl_categories_enabled_p_idx;
drop index ctrl_categories_name_idx;
drop table ctrl_categories;
