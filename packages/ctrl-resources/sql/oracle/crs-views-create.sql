

/*
Views to query tables in a consistent way

@author KH
@cvs-id $Id$
@creation-date 2005-12-13
*/

create or replace view crs_resources_vw 
as 
select res.resource_id, 
       res.name ,
       res.description ,
       res.resource_category_id,
       (select name from ctrl_categories cat
        where  cat.category_id = res.resource_category_id) as resource_category_name,
       res.enabled_p ,
       res.services,
       res.property_tag ,
       res.package_id ,
       res.owner_id,
       res.quantity,
       res.parent_resource_id,
       res.resource_type 
from crs_resources res;

create or replace view crs_resv_resources_vw 
as
select res.resource_id, 
       res.name ,
       res.description ,
       res.resource_category_id,
       res.enabled_p ,
       res.services,
       res.property_tag ,
       res.package_id ,
       res.owner_id,
       res.quantity,
       res.resource_category_name ,
       res.parent_resource_id,
       rres.how_to_reserve,
       rres.approval_required_p ,
       rres.address_id,
       rres.department_id,
       rres.floor,
       rres.room,
       rres.gis ,
       rres.new_email_notify_list,
       rres.update_email_notify_list,
       rres.color,
       res.resource_type,
       rres.reservable_p,
       rres.reservable_p_note,
       rres.special_request_p
from crs_resources_vw res, 
     crs_reservable_resources rres
where res.resource_id = rres.resource_id;

create or replace view crs_room_default_resources_vw 
as 
select res.resource_id, 
       res.name ,
       res.description ,
       res.resource_category_id,
       (select name from ctrl_categories cat
        where  cat.category_id = res.resource_category_id) as resource_category_name,
       res.enabled_p ,
       res.services,
       res.property_tag ,
       res.package_id ,
       res.owner_id,
       res.quantity,
       res.parent_resource_id ,
       res.resource_type 
from crs_resources res
where  res.resource_type = 'crs_resource';

create or replace view crs_room_resv_resources_vw 
as
select *
from crs_resv_resources_vw 
where resource_type = 'crs_reservable_resource';





