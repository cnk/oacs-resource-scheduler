--
-- /packages/acs-kernel/sql/security-drop.sql
--
-- DDL statements to purge the Security data model
--
-- @author Michael Yoon (michael@arsdigita.com)
-- @creation-date 2000-07-27
-- @cvs-id $Id: security-drop.sql,v 1.1 2001-03-20 22:51:56 donb Exp $
--

drop sequence sec_id_seq;
drop sequence sec_security_token_id_seq;
drop table sec_session_properties;
drop index sec_sessions_by_server;
drop table secret_tokens;
