-- 
-- Upgrade script from 5.0d6 to 5.0d7
--
-- Adds auth_token to users table
--
-- @author Lars Pind (lars@collaboraid.biz)
--
-- @cvs-id $Id: upgrade-5.0d6-5.0d7.sql,v 1.1 2003-09-18 17:11:36 lars Exp $
--

alter table users add (auth_token varchar2(100));

