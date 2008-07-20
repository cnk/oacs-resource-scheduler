<?xml version="1.0"?>
<queryset>
	<fullquery name="crs::install::before_uninstantiate.remove_package_categories">
	 <querytext>
		begin
			for c in (select	category_id
				    from	ctrl_categories	c,
						acs_objects		o
				   where	c.category_id		= o.object_id
				     and	o.context_id		= :package_id) loop
				ctrl_category.del(c.category_id);
			end loop;
		end;
	 </querytext>
	</fullquery>
</queryset>
