<?xml version="1.0"?>
<queryset>
	<fullquery name="ctrl_event::category::exists_p.events_category_exists_p">
	<querytext>
		select count(*)
		from   ctrl_categories c,
	       	       ctrl_categories pc
		where  c.category_id	    = :category_id
		and    c.parent_category_id = pc.category_id
	</querytext>
	</fullquery>

	<fullquery name="ctrl_event::category::get_category_options.events_category_options">
	<querytext>
		select 	c.name,
			c.category_id,
			c.profiling_weight
		from    ctrl_categories c,
			ctrl_categories pc
		where   c.parent_category_id = pc.category_id
		and     pc.name		     = :parent_category_name
		order   by c.profiling_weight desc
	</querytext>
	</fullquery>

	<fullquery name="ctrl_event::category::get_info.events_category_info">
	<querytext>
		select $column_name_to_retrieve
		from   ctrl_categories 
		where  lower($unique_field) = lower(:unique_value)
	</querytext>
	</fullquery>

</queryset>
