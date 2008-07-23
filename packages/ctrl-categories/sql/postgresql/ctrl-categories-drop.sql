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


-- drop DDL objects
drop index ctrl_categories_enabled_p_idx;
drop index ctrl_categories_name_idx;
drop table ctrl_categories;
