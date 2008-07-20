-- 
-- tsearch2 based FTSEngineDriver for Search package 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2004-06-05
-- @arch-tag: 25662a8a-e960-4888-bd9f-3e7a8fff5637
-- @cvs-id $Id: tsearch2-driver-create.sql,v 1.2 2005-02-17 17:18:25 jeffd Exp $
--

-- FIXME need to load tsearch2.sql from postgresql/share/contrib
-- (on debian /usr/share/postgresql/contrib)
create table txt (
	object_id integer
		  constraint txt_object_id_fk
	          references acs_objects on delete cascade,
	fti	  tsvector
);

create index fti_idx on txt using gist(fti);
create index object_id_idx on txt (object_id);

