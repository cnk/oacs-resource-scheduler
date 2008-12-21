<?xml version="1.0"?>

<queryset>

	<fullquery name="category_edit">
	 <querytext>
		update	ctrl_categories
		   set	name				= :name,
				plural				= :plural,
				description			= :description,
				enabled_p			= :enabled_p,
				profiling_weight	= :profiling_weight
		 where	category_id			= :category_id
	 </querytext>
	</fullquery>

	<fullquery name="category_name">
	 <querytext>
		select name from ctrl_categories where category_id = :category_id
	 </querytext>
	</fullquery>

	<fullquery name="parent_category_name">
	 <querytext>
		select name from ctrl_categories where category_id = :parent_category_id
	 </querytext>
	</fullquery>
</queryset>
