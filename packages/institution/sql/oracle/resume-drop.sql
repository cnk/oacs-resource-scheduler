-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/resume-drop.sql
--
-- Drop Script for Resumes
--
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2004-03-05
-- @cvs-id $Id: resume-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--
drop package inst_personnel_resume;
drop table inst_personnel_resumes;
exec acs_object_type.drop_type('resume');
