<?xml version="1.0"?>
<queryset>
	<fullquery name="object_list_query">
	<querytext>
    		select 	ceo.event_object_id,
           		ceo.name,
           		ceo.description,
			ceo.object_type_id,
			c.name as object_type_name
    		from    ctrl_events_objects ceo,
			acs_objects a,
			ctrl_categories c 
		where   a.object_id  = ceo.event_object_id and 
			a.context_id = :context_id and
			ceo.object_type_id = c.category_id(+)  $object_type_constraint_clause
		order   by c.name asc,
			   ceo.name asc
	</querytext>
	</fullquery>
</queryset>
