create or replace view crs_subsite_resrc_map_vw as
select b.object_id_one subsite_id, b.object_id_two resource_id
from   ctrl_subsite_for_object_rels a, acs_rels b
where  b.rel_id = a.rel_id;
