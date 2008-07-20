--
-- packages/acs-messaging/sql/acs-messaging-drop.sql
--
-- @author akk@arsdigita.com
-- @creation-date 2000-08-31
-- @cvs-id $Id: acs-messaging-drop.sql,v 1.1 2001-04-05 18:23:38 donb Exp $
--

begin
  acs_object_type.drop_type('acs_message');
end;
/
show errors

drop package acs_message;

drop table acs_messages_outgoing;

drop view acs_messages_all;

drop table acs_messages;

