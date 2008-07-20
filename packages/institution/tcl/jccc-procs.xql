<?xml version="1.0"?>
<queryset>
	<fullquery name="inst::jccc::group_id.jccc_group_lookup">
	<querytext>
		select inst_group.lookup('//UCLA//David Geffen School of Medicine at UCLA//Jonsson Comprehensive Cancer Center') from dual
	</querytext>
	</fullquery>

	<fullquery name="inst::jccc::group_p.jccc_group_list">
	<querytext>
		select 			ig.group_id
		from   			inst_groups ig
		connect by prior 	ig.group_id = ig.parent_group_id
		start with 		ig.group_id = :jccc_group_id
	</querytext>
	</fullquery>

	<fullquery name="inst::jccc::personnel_delete.jccc_personnel_delete">
	<querytext>
		delete from jccc_personnel where personnel_id = :personnel_id
	</querytext>
	</fullquery>
</queryset>
