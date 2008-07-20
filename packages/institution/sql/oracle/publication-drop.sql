-- -*- tab-width: 4 -*- ---
--
-- packages/institution/sql/oracle/publication-drop.sql
--
-- Drop Script for publications part of institution package.
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date	2003/07/20
-- @cvs-id $Id: publication-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

drop package inst_publication;
drop table inst_publications;
execute acs_object_type.drop_type('inst_publications');

