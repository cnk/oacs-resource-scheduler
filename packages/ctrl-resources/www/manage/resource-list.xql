<?xml version="1.0"?>
<queryset>
    <fullquery name="resource_list">
        <querytext>
     select b.* from 
        (select a.*, rownum as row_no 
           from (
        select  crs.resource_id ,
                crs.name,
                crs.description,
                crs.resource_category_id,
                crs.resource_category_name, 
                crs.enabled_p,
                crs.services,
                crs.property_tag,
                crs.package_id
        from crs_resources_vw crs ,
             acs_objects ao 
        where package_id = :package_id  and ao.object_id = crs.resource_id and ao.object_type = 'crs_resource'
        order by name
      ) a ) b
     where row_no >= :start_row and row_no <= :end_row 
        </querytext>
    </fullquery>
    <fullquery name="resource_id_list">
        <querytext>
        select  crs.resource_id
        from crs_resources_vw crs ,
             acs_objects ao 
        where package_id = :package_id  and ao.object_id = crs.resource_id and ao.object_type = 'crs_resource'
        order by name
        </querytext>
    </fullquery>

</queryset>
