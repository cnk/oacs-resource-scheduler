-- -*- tab-width: 4 -*- ---
--
-- packages/institution/sql/oracle/external-id-mapping-drop.sql
--
-- Drop script for tables to map institution primary keys to external systems' primary keys
--
-- @author avni@avni.net (AK)
-- @author helsleya@cs.ucr.edu (AH)
--
-- @creation-date	2003/07/22
-- @cvs-id $Id: external-id-mapping-drop.sql,v 1.1.1.1 2006/09/13 01:29:58 nsadmin Exp $
--

drop table inst_external_physician_id_map;
drop table inst_external_group_id_map;