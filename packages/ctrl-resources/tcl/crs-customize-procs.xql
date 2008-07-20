<?xml version="1.0"?>
<queryset>

<partialquery name="crs::customize::get_most_reserved_list.user_filter">
  <querytext>
        reserved_by = :user_id 
  </querytext>
</partialquery>

<partialquery name="crs::customize::get_most_reserved_list.after_date_filter">
  <querytext>
        start_date >= :after_date
  </querytext>
</partialquery>


<fullquery name="crs::customize::get_most_reserved_list.get">
  <querytext>
       select room_id_name
       from  (
             select a.room_id||'|'||a.name as room_id_name, count(*)  
             from  crs_room_reserve_details a, crs_subsite_resrc_map_vw b
             where  b.subsite_id = :subsite_id
             and    a.room_id = b.resource_id
             $filter_sql
             group by a.room_id||'|'||a.name) rrc
        where rownum <= :no_row
  </querytext>
</fullquery>

</queryset>
