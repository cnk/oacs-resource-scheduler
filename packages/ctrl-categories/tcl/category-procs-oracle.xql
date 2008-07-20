<?xml version="1.0"?>
<queryset>
	<fullquery name="ctrl::category::new.category_exists_p">
	 <querytext>
			select category_id
			from   ctrl_categories
			where  lower(name) = lower(:name) $parent_category_constraint
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::new.new_category">
	 <querytext>
		begin
			:1 := ctrl_category.new(
				parent_category_id	=> :parent_category_id,
				name				=> :name,
				description			=> :description,
				enabled_p			=> :enabled_p,
				plural				=> :plural,
				profiling_weight	=> :profiling_weight,
				context_id			=> :context_id
			);
		end;
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

	<fullquery name="ctrl::category::remove.delete_category">
	 <querytext>
		begin
			ctrl_category.del(:category_id);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::subcategories_list.direct_subcategories_of">
	 <querytext>
		select	category_id
		  from	ctrl_categories
		 where	parent_category_id = :category_id
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::name_from_id.name">
	 <querytext>
		select	ctrl_category.name(:category_id)
		  from	dual
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::find.lookup">
	 <querytext>
		select	ctrl_category.lookup(:path)
		  from	dual
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::before_uninstantiate.remove_package_categories">
	 <querytext>
		begin
			for c in (select	category_id
						from	ctrl_categories	c,
								acs_objects		o
					   where	c.parent_category_id	is null
						 and	c.category_id			= o.object_id
						 and	o.context_id			= :package_id) loop
				ctrl_category.del(c.category_id);
			end loop;
		end;
	 </querytext>
	</fullquery>

    <fullquery name="ctrl::category::option_list.get_subcategories">
     <querytext>
        select  $spacing_statement name as name,
                category_id
          from  ctrl_categories  $query_constraint
         start  with parent_category_id = ctrl_category.lookup(:path)
        connect by prior category_id = parent_category_id
     </querytext>
    </fullquery>

    <fullquery name="ctrl::category::option_id_list.get_subcategories">
     <querytext>
        select category_id
          from  ctrl_categories  
         start  with parent_category_id = ctrl_category.lookup(:path)
        connect by prior category_id = parent_category_id
     </querytext>
    </fullquery>

</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
