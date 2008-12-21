<?xml version="1.0"?>
<queryset>
	<fullquery name="ctrl::category::new.category_exists_p">
	 <querytext>
			select category_id
			from   ctrl_categories
			where  lower(name) = lower(:name) $parent_category_constraint
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::edit.category_edit">
	 <querytext>
		update	ctrl_categories
		   set	name				= :name,
				plural				= :plural,
				description			= :description,
				enabled_p			= :enabled_p,
				profiling_weight	= :profiling_weight,
				parent_category_id	= :parent_category_id
		 where	category_id			= :category_id
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::subcategories_list.direct_subcategories_of">
	 <querytext>
		select	category_id
		  from	ctrl_categories
		 where	parent_category_id = :category_id
	 </querytext>
	</fullquery>

</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
