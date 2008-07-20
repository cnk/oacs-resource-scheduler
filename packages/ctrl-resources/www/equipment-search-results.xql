<?xml version=1.0?>
<queryset>

<fullquery name="get_equipments_query">
<querytext>
select res.resource_id , res.name, res.description
                  from crs_room_resv_resources_vw  res, crs_subsite_resrc_map_vw v
                  where v.subsite_id = :subsite_id
                  and   res.resource_id = v.resource_id
                  and   res.parent_resource_id is null 
                   $eq_clause
</querytext>
</fullquery>

</queryset>

