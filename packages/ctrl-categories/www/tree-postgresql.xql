<?xml version="1.0"?>
<queryset>
	<rdbms><type>postgresql</type><version>7.4</version></rdbms>

	<fullquery name="max_visible_depth">
	 <querytext>
		select	coalesce(max(tree_level(c.tree_sortkey)), 0)
		  from	ctrl_categories c, ctrl_categories parent
		 where	c.parent_category_id  in ([join $visible_expanded ","])
            or  c.category_id         in ($roots)
           and  c.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
     </querytext>
    </fullquery>

    <!-- //TODO// decide if joining with 'acs_object_party_privilege_map' is a
            faster method of extracting the permissions info we need -->
    <fullquery name="category_tree">
     <querytext>
        select  distinct c.category_id,
                c.parent_category_id,
                c.name,
                c.plural,
                c.description,
                c.profiling_weight,
                c.tree_sortkey,
                tree_level(c.tree_sortkey) as level,
                lpad(' ', tree_level(c.tree_sortkey)-1) as level_pad,
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'read') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'read') = 'f' then 0 
                end as read_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'write') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'write') = 'f' then 0 
                end as write_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'create') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'create') = 'f' then 0 
                end as create_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'delete') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'delete') = 'f' then 0 
                end as delete_p,           
                case 
                    when acs_permission__permission_p(c.category_id, :user_id, 'admin') = 't' then 1 
                    when acs_permission__permission_p(c.category_id, :user_id, 'admin') = 'f' then 0 
                end as admin_p,           
                (select count(*)
                   from ctrl_categories
                  where parent_category_id = c.category_id) as n_children
          from  ctrl_categories c, ctrl_categories parent
         where  (c.parent_category_id      in ([join $visible_expanded ","])
                or  c.category_id          in ($roots))
           and  acs_permission__permission_p(c.category_id, :user_id, 'read') = 't'
           and  c.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)    
		 order by c.tree_sortkey
     </querytext>
    </fullquery>

    <fullquery name="category_descendants">
     <querytext>
        select  distinct subtree.category_id as child_id
          from  ctrl_categories subtree, ctrl_categories parent
         where   subtree.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
		   and  parent.category_id		= :r_category_id
	 </querytext>
	</fullquery>

	<fullquery name="category_descendants_by_level">
	 <querytext>
		select	subtree.category_id, subtree.parent_category_id
          from  ctrl_categories subtree, ctrl_categories parent
         where   subtree.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
		   and  parent.category_id		= :r_category_id
		order	by tree_level(subtree.tree_sortkey)
	 </querytext>
	</fullquery>

	<fullquery name="root_category_treelevel">
	 <querytext>
		select tree_level(c.tree_sortkey)
		  from ctrl_categories c
		where  c.category_id = :root_category_id
	 </querytext>
    </fullquery>

	<fullquery name="visible_expanded_pruned">
	  <querytext>
		select c.category_id
		from  ctrl_categories c
		where c.category_id in ([join $visible_expanded ","])
		and   tree_level(c.tree_sortkey) > :root_category_treelevel
	  </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
