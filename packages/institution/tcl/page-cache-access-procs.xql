<?xml version="1.0"?>
<queryset>
	<!-- subsite::for_any_party_p ########################################## -->
	<fullquery name="inst::pg_cache::access::get_possible_lang_nocache.possible_languages">
	 <querytext>
		select	trim(name), language_id
		  from	language_codes lc
		 where	exists
				(select	1
				   from	inst_personnel_language_map plm
				  where	plm.language_id = lc.language_id
					and	exists
						(select 1
						   from inst_personnel p
						  where	p.personnel_id = plm.personnel_id))
		order by name
	 </querytext>
	</fullquery>

	<fullquery name="inst::pg_cache::access::subsite_groups_nocache.subsite_groups">
	 <querytext>
		select	lpad(' ', 4*6*(level-1), '&nbsp;') || short_name, group_id
		  from	inst_groups g
		 where	[subsite::parties_sql -subsite_id $subsite_id -groups -party_id {g.group_id}]
		connect	by prior group_id = parent_group_id
		 start	with group_id in ([subsite::parties_sql -subsite_id $subsite_id -only -trunk -groups])
	 </querytext>
	</fullquery>

</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
