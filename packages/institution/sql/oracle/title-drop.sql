-- -*- tab-width: 4 -*-
--
-- /packages/institution/sql/oracle/title-drop.sql
--
-- drop script for the personnel-titles part of the institution package
--
-- @author			helsleya@cs.ucr.edu (AH)
-- @creation-date	2005-02-16
-- @cvs-id			$Id: title-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

drop package inst_title;
drop table inst_group_personnel_map;
exec acs_object_type.drop_type('inst_title');
