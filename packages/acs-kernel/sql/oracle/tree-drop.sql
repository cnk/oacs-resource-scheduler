
--
-- Drop The Tree Package
--
-- @author ben@openforce
-- @creation-date 2002-05-17
-- @version $Id: tree-drop.sql,v 1.1 2002-05-30 18:08:05 yon Exp $
--
-- This does funky sortkey stuff in Oracle,
-- similar to DonB's PG varbit stuff, but without varbits
-- because Oracle has no varbits.
--
-- This scheme is usable in PG, too, but probably not as
-- efficient as Don's varbit scheme. So we use it only in Oracle
--

drop package body tree;
drop package tree;
