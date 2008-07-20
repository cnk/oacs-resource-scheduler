<?xml version="1.0"?>
<queryset>
    <fullquery name="resv_resource_list">
        <querytext>
     select b.* from 
       (select a.*, rownum as row_no from (
           select  res.resource_id, 
                res.name ,
                res.description ,
                res.resource_category_id,
                res.resource_category_name,
                res.enabled_p ,
                res.services,
                res.property_tag ,
                res.package_id ,
                res.how_to_reserve,
                res.approval_required_p ,
                res.address_id,
                res.department_id,
                res.floor,
                res.room,
                res.gis ,
		res.color
        from crs_room_resv_resources_vw res, crs_subsite_resrc_map_vw v
        where v.subsite_id = :subsite_id  
        and   res.resource_id = v.resource_id  
        and res.resource_type = 'crs_reservable_resource' and parent_resource_id is null
        and   acs_permission.permission_p(res.resource_id, :user_id, 'admin') = 't'
        order by name) a ) b 
        where row_no >= :start_row and row_no <= :end_row
        </querytext>
    </fullquery>

    <fullquery name="resv_resource_id_list">
        <querytext>
           select res.resource_id
           from   crs_room_resv_resources_vw res, crs_subsite_resrc_map_vw v
           where  v.subsite_id = :subsite_id 
           and    res.resource_id = v.resource_id
           and    res.resource_type = 'crs_reservable_resource' and res.parent_resource_id is null
           and    acs_permission.permission_p(res.resource_id, :user_id, 'admin') = 't'
        </querytext>
    </fullquery>
</queryset>
