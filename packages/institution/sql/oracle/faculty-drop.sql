-- packages/institution/sql/oracle/faculty-drop.sql
--
-- Drop faculty tables
--
-- @author avni@avni.net (AK)
-- @creation-date 03/30/2004
-- @cvs-id $Id: faculty-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

--drop package inst_faculty;
drop table inst_faculty;
exec acs_object_type.drop_type('inst_faculty_member');
