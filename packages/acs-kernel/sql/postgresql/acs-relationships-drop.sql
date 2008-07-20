--
-- packages/acs-kernel/sql/acs-relationships-drop.sql
--
-- @creation-date 2000-08-13
--
-- @author rhs@mit.edu
--
-- @cvs-id $Id: acs-relationships-drop.sql,v 1.2 2004-06-18 18:21:57 jeffd Exp $
--

\t
select drop_package('acs_rel');
select drop_package('acs_rel_type');
\t
drop table acs_rels;
drop view acs_rel_id_seq;
drop sequence t_acs_rel_id_seq;
drop table acs_rel_types;
drop table acs_rel_roles;
