<?xml version="1.0"?>
<queryset>
	<fullquery name="subsite_roots_exist_p">
	 <querytext>
		select	count(object_id_two)
		  from	acs_rels
		 where	rel_type		= 'subsite_for_party_rel'
		   and	object_id_one	= :subsite_id
	 </querytext>
	</fullquery>

	<fullquery name="core_groups">
	 <querytext>
		select	distinct grp.group_id,
				grp.short_name				group_name,
				grp.parent_group_id,
				pgrp.short_name				parent_group_name
		  from	inst_groups					grp,
				inst_groups					pgrp
		 where	pgrp.parent_group_id	= inst_group.lookup('//UCLA//David Geffen School of Medicine at UCLA//Cores')
		   and	grp.parent_group_id		= pgrp.group_id
		 order	by parent_group_name, parent_group_id, group_name, group_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
