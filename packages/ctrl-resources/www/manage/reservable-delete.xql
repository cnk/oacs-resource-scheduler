<?xml version="1.0"?>
<queryset>
  <fullquery name="get_event_counter">
    <querytext>
       select count(*) 
       from   ctrl_events
       where  event_object_id = :resource_id
    </querytext>
  </fullquery>
</queryset>
