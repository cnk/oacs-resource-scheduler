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
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
