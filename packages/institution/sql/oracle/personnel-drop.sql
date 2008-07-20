-- -*- tab-width: 4 -*- --
--
-- /packages/institution/sql/oracle/personnel-drop.sql
--
-- drop script for the personnel part of the institution package
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date 07/20/2003
-- @cvs-id $Id: personnel-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

drop package inst_person;
drop table inst_personnel_language_map;
drop table inst_personnel;
exec acs_object_type.drop_type('inst_personnel');
