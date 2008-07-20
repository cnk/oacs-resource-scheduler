--
-- /packages/acs-kernel/sql/rel-constraints-drop.sql
-- 
-- @author Oumi Mehrotra
-- @creation-date 2000-11-22
-- @cvs-id $Id: rel-constraints-drop.sql,v 1.2 2004-06-18 18:21:57 jeffd Exp $
\t
create function  inline_0 () returns integer as '
begin
        PERFORM acs_rel_type__drop_type(''rel_constraint'');
        return null;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

drop view rel_constraints_violated_one;
drop view rel_constraints_violated_two;
drop view rc_required_rel_segments;
drop view rc_parties_in_required_segs;
drop view rc_violations_by_removing_rel;
drop table rel_constraints;
select drop_package('rel_constraint');
\t
