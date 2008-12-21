<?xml version="1.0"?>
<queryset>
	<fullquery name="ctrl::category::new.new_category">
	 <querytext>

		select ctrl_category__new(:parent_category_id,:name,:description,:enabled_p,:plural,:profiling_weight,:context_id)

	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::remove.delete_category">
	 <querytext>

		select ctrl_category__delete(:category_id)

	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::name_from_id.name">
	 <querytext>
		select	ctrl_category__name(:category_id)
	 </querytext>
	</fullquery>

	<fullquery name="ctrl::category::find.lookup">
	 <querytext>
		select	ctrl_category__lookup(:path)
	 </querytext>
	</fullquery>

    <!-- CNK TODO - pretty sure I can't do anonymous blocks like this --> 

	<fullquery name="ctrl::category::before_uninstantiate.remove_package_categories">
	 <querytext>
		begin
			for c in (select	category_id
						from	ctrl_categories	c,
								acs_objects		o
					   where	c.parent_category_id	is null
						 and	c.category_id			= o.object_id
						 and	o.context_id			= :package_id) loop
				ctrl_category__delete(c.category_id);
			end loop;
		end;
	 </querytext>
	</fullquery>

    <fullquery name="ctrl::category::option_list.get_subcategories">
     <querytext>
        select  $spacing_statement children.name as name,
                children.category_id
          from  ctrl_categories children, ctrl_categories parent  
          $query_constraint
            and children.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
            and and parent.tree_sortkey <> children.tree_sortkey
            and parent_category_id = ctrl_category__lookup(:path)
     </querytext>
    </fullquery>

    <fullquery name="ctrl::category::option_id_list.get_subcategories">
     <querytext>
        select children.category_id
          from ctrl_categories children, ctrl_categories parent  
        where children.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
          and and parent.tree_sortkey <> children.tree_sortkey
          and parent_category_id = ctrl_category__lookup(:path)
     </querytext>
    </fullquery>

</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
