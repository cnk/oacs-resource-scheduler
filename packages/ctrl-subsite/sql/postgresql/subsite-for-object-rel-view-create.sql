-- /packages/ctrl-subsite/sql/postgresql/subsite-for-object-rel-view-create.sql
--
-- View for selecting subsites and objects that have been mapped
-- 
-- @author 		avni@avni.net (AK)
-- @creation-date 	2007-03-12
-- @update-date		2008-08 (ported to postgres)		
-- @cvs-id 		$Id$


create 	or replace view crs_subsite_resrc_map_vw as
select 	ar.object_id_one as subsite_id, 
	ar.object_id_two as resource_id
from   	ctrl_subsite_for_object_rels csfor, acs_rels ar
where  	ar.rel_id = csfor.rel_id;
