<?xml version="1.0"?>
<queryset>
	<fullquery name="get_group_name">
	 <querytext>
		select short_name
		  from inst_groups
		 where group_id = :group_id
	 </querytext>
	</fullquery>

	<fullquery name="get_titles">
	 <querytext>
		select	name,
				category_id
		  from	categories
		 where	parent_category_id = category.lookup('//Personnel Title')
	 </querytext>
	</fullquery>

	<fullquery name="get_category_name">
	 <querytext>
		select	name
		  from	categories	c,
				groups		g
		 where	c.category_id	= g.group_type_id
		   and	g.group_id		= :group_id
	 </querytext>
	</fullquery>


	<fullquery name="all_languages">
	 <querytext>
		select	name,
				language_id
		  from	language_codes
		 order	by name
	 </querytext>
	</fullquery>

	<fullquery name="events_start_date_after_p">
	 <querytext>
		select	1
		  from	dual
		 where	to_date(:real_start_date,'yyyy/mm/dd') > to_date(:real_end_date,'yyyy/mm/dd')
	 </querytext>
	</fullquery>

	<fullquery name="group_events_start_date_after_p">
	 <querytext>
		select	1
		  from	dual
		 where	to_date(:real_group_start_date,'yyyy/mm/dd') > to_date(:real_group_end_date,'yyyy/mm/dd')
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
