-- -*- tab-width: 4 -*- -
--
-- packages/institution/sql/oracle/physicians-drop.sql
--
-- Drop Scripts for Physicians
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
-- @creation-date 2003-07-17
-- @cvs-id $Id: physician-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

--drop package inst_physicians;
drop table inst_physicians;
exec acs_object_type.drop_type('inst_physician');
