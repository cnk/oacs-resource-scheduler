<?xml version="1.0"?>
<queryset>

  <fullquery name="room_order_page">
    <querytext>
select a.room_id, a.name, a.description, a.capacity
from   crs_room_details a, crs_subsite_resrc_map_vw b
where  b.subsite_id = :subsite_id
and    a.room_id = b.resource_id
and    acs_permission.permission_p(a.room_id, :user_id, 'admin') = 't'
$pagination
$orderby_clause
    </querytext>
  </fullquery>

  <fullquery name="room_order_all">
    <querytext>
select a.room_id, a.name, a.description, a.capacity
from   crs_room_details a, crs_subsite_resrc_map_vw b
where  b.subsite_id = :subsite_id
and    a.room_id = b.resource_id
and    acs_permission.permission_p(a.room_id, :user_id, 'admin') = 't'
$orderby_clause
    </querytext>
  </fullquery>

</queryset>
