<?xml version="1.0"?>
<queryset>

<fullquery name="ctrl_event::event_category::associate.category">
   <querytext>
      insert into ctrl_event_categories(event_id, category_id)
      values(:event_id,:category_id)
   </querytext>
</fullquery>

<fullquery name="ctrl_event::event_category::associate.check">
   <querytext>
      select 1 from ctrl_event_categories where event_id = :event_id and category_id = :category_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::event_category::disassociate.category">
   <querytext>
      delete from ctrl_event_categories where event_id = :event_id and category_id = :category_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::event_category::disassociate.check">
   <querytext>
      select 1 from ctrl_event_categories where event_id = :event_id and category_id = :category_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::event_category::current.category_ids">
   <querytext>
      select category_id from ctrl_event_categories where event_id = :event_id
   </querytext>
</fullquery>

<fullquery name="ctrl_event::event_category::category_csv.names">
   <querytext>
      select c.name 
      from   ctrl_event_categories e, ctrl_categories c
      where  e.event_id = :event_id and e.category_id = c.category_id
   </querytext>
</fullquery>

</queryset>
