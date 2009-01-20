<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event::category::associate.category">
   <querytext>
      insert into ctrl_events_categories_map(event_id, category_id)
      values(:event_id,:category_id)
   </querytext>
</fullquery>

<fullquery name="ctrl_event::category::associate.check">
   <querytext>
      select 1 from ctrl_events_categories_map where event_id = :event_id and category_id = :category_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::category::disassociate.category">
   <querytext>
      delete from ctrl_events_categories_map where event_id = :event_id and category_id = :category_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::category::disassociate.check">
   <querytext>
      select 1 from ctrl_events_categories_map where event_id = :event_id and category_id = :category_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::category::current.category_ids">
   <querytext>
      select category_id from ctrl_events_categories_map where event_id = :event_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::category::category_csv.names">
   <querytext>
      select c.name 
      from   ctrl_calendar_event_categories e, ctrl_categories c
      where  e.event_id = :event_id and e.category_id = c.category_id
   </querytext>
</fullquery>

</queryset>
