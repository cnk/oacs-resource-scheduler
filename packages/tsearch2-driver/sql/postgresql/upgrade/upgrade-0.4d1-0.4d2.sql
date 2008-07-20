-- 
-- 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2004-12-18
-- @arch-tag: 46a0ecc0-b123-44dd-9e91-4a565f742071
-- @cvs-id $Id: upgrade-0.4d1-0.4d2.sql,v 1.2 2005-01-13 13:58:51 jeffd Exp $
--

alter table txt drop constraint txt_object_id_fk;
alter table txt add constraint txt_object_id_fk foreign key (object_id) references acs_objects (object_id) on delete cascade;