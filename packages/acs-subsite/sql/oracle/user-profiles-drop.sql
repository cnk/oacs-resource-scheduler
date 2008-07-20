--
-- packages/acs-subsite/sql/user-profiles-drop.sql
--
-- @author oumi@arsdigita.com
-- @creation-date 2000-02-02
-- @cvs-id $Id: user-profiles-drop.sql,v 1.1 2001-04-05 18:23:38 donb Exp $
--

drop table user_profiles;
drop package user_profile;

begin
  acs_rel_type.drop_type('user_profile');
end;
/
show errors

