<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="insert_role_type">
	<querytext>
        insert into categories
 		(category_id, parent_category_id, name, plural, description, enabled_p, profiling_weight)
        values (:category_id, :parent_category_id, :name, :plural, :description, :enabled_p, :profiling_weight)
	</querytext>
	</fullquery>

	<fullquery name="get_role_categories">
	<querytext>
		select distinct parent_category_id
		from	categories
		where	parent_category_id = category.lookup('//CTRL Event//Role')
	</querytext>
	</fullquery>

	<fullquery name="get_event_role_type">
	<querytext>
        select	CATEGORY_ID,
		PARENT_CATEGORY_ID,
		NAME,
		PLURAL,
		DESCRIPTION,
		ENABLED_P,
		PROFILING_WEIGHT
	from 	categories
	where	category_id = :category_id
	</querytext>
	</fullquery>

</queryset>

