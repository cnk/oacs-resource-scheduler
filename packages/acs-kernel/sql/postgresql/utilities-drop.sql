--
-- /packages/acs-kernel/sql/utilities-drop.sql
--
-- Purges useful PL/SQL utility routines.
--
-- @author Jon Salz (jsalz@mit.edu)
-- @creation-date 12 Aug 2000
-- @cvs-id $Id: utilities-drop.sql,v 1.2 2004-06-18 18:21:57 jeffd Exp $
--
\t
select drop_package('util');
\t
