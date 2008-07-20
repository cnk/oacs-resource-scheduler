-- 
-- 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2005-01-06
-- @arch-tag: a39c54fa-1262-4d8c-8ceb-5f5bed0089ee
-- @cvs-id $Id: upgrade-5.2.0d10-5.2.0d11.sql,v 1.1 2005-01-06 18:48:12 daveb Exp $
--

select define_function_args('content_template__new','name,parent_id,template_id,creation_date;now,creation_user,creation_ip,text,is_live;f');