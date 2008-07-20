--
-- acs-kernel/sql/oracle/authentication-drop.sql
--
-- The OpenACS core authentication system drop script.
--
-- @author Lars Pind (lars@collaboraid.biz)
--
-- @creation-date 20003-05-14
--
-- @cvs-id $Id: authentication-drop.sql,v 1.1 2003-08-22 11:38:08 peterm Exp $
--

declare
    foo integer;
begin 
  for row in (select authority_id from auth_authorities)
  loop
    foo := authority.del(row.authority_id);
  end loop;

  acs_object_type.drop_type('authority', 't');
end;
/
show errors

drop table auth_authorities cascade constraints;

@@ authentication-package-drop
