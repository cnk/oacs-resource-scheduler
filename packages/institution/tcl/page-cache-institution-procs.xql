<?xml version="1.0"?>
<queryset>
	<fullquery name="child_categories">
	 <querytext>
		select	c.name, c.category_id
		  from	categories c
		 where	c.parent_category_id = category.lookup('//' || :parent_category_name)
		 order	by c.name
	 </querytext>
	</fullquery>

	<fullquery name="inst::pg_cache::inst::phys_srch::possible_categories_nocache.possible_categories">
	 <querytext>
		select	c.name, c.category_id
		  from	categories c
		 where	c.parent_category_id = category.lookup('//' || :parent_category_name)
		   and	category_id  in
				(select category_id
				   from inst_party_category_map	pcm
				  where party_id in
						(select	physician_id
						   from	inst_physicians))
		 order	by c.name
	 </querytext>
	</fullquery>

	<fullquery name="inst::pg_cache::inst::phys_srch::clinical_interests_nocache.clinical_interests">
	 <querytext>
		select	c.name, c.category_id
		  from	categories c
		 where	c.parent_category_id = category.lookup('//Field of Interest//Clinical Interest')
		   and	category_id in
				(select category_id
				   from inst_party_category_map	pcm
				  where party_id in
						(select	physician_id
						   from	inst_physicians))
		 order	by c.name
	 </querytext>
	</fullquery>

	<fullquery name="possible_languages">
	 <querytext>
		select	trim(name), language_id
		  from	language_codes l
		 where	language_id in
				(select	language_id
				   from	inst_personnel_language_map	plm
				  where	personnel_id in
						(select physician_id
						   from inst_physicians))
		 order	by name
	 </querytext>
	</fullquery>
<!--		 where exists
				(select	1
				   from	inst_personnel_language_map	plm
				  where	plm.language_id			= l.language_id
					and	exists
						(select 1
						   from inst_physicians
						  where	physician_id	= plm.personnel_id))
-->

	<fullquery name="subsite_groups">
	 <querytext>
		select	lpad(' ', 4*6*(level-1), '&nbsp;') || short_name, group_id
		  from	inst_groups g
		 where	[subsite::parties_sql -groups -party_id {g.group_id}]
		connect	by prior group_id = parent_group_id
		 start	with group_id in ([subsite::parties_sql -only -trunk -groups])
	 </querytext>
	</fullquery>

	<partialquery name="junction__all">
	 <querytext> and </querytext>
	</partialquery>

	<partialquery name="junction__any">
	 <querytext> or </querytext>
	</partialquery>

	<partialquery name="inst_personnel__gender__cond">
	 <querytext>inst_personnel.gender = :gender</querytext>
	</partialquery>

	<partialquery name="persons__first_name__cond">
	 <querytext>persons.first_names = :first_name</querytext>
	</partialquery>

	<partialquery name="persons__last_name__cond">
	 <querytext>persons.last_name = :last_name</querytext>
	</partialquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
