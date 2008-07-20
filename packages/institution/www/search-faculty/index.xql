<?xml version="1.0"?>
<queryset>
	<fullquery name="subsite_roots_exist_p">
	 <querytext>
		select	count(object_id_two)
		  from	acs_rels
		 where	rel_type = 'subsite_for_party_rel'
		   and	object_id_one = :subsite_id
	 </querytext>
	</fullquery>

	<fullquery name="child_categories">
	 <querytext>
		select	c.name, c.category_id
		  from	categories c
		 where	c.parent_category_id = category.lookup('//' || :parent_category_name)
		 order	by c.name
	 </querytext>
	</fullquery>

	<fullquery name="possible_categories">
	 <querytext>
		select	c.name, c.category_id
		  from	categories c
		 where	c.parent_category_id = category.lookup('//' || :parent_category_name)
		   and	exists
				(select 1
				   from inst_party_category_map	pcm
				  where pcm.category_id = c.category_id
					and exists (select 1 from inst_faculty where faculty_id = party_id))
		 order	by c.name
	 </querytext>
	</fullquery>

	<fullquery name="possible_languages">
	 <querytext>
		select	trim(name), language_id
		  from	language_codes lc
		 where	exists
				(select	1
				   from	inst_personnel_language_map plm
				  where	plm.language_id = lc.language_id
					and	exists
						(select 1
						   from inst_faculty f
						  where	f.faculty_id = plm.personnel_id))
		order by name
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

	<partialquery name="search_phyician_essentials__unused">
	 <querytext>
	 </querytext>
	</partialquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
