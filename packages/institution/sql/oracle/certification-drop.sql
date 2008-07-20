-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/certification-drop.sql
--
-- drop script for certifications
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-07-20
-- @cvs-id $Id: certification-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

drop package inst_certification;
drop table inst_certifications;
exec acs_object_type.drop_type('certification');
