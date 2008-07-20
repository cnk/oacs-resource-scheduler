<?xml version="1.0"?>
<queryset>
	<fullquery name="inst::sph::group_id.sph_group_lookup">
	<querytext>
		select inst_group.lookup('//UCLA//School of Public Health') from dual
	</querytext>
	</fullquery>

	<fullquery name="inst::sph::group_p.sph_group_list">
	<querytext>
		select 			ig.group_id
		from   			inst_groups ig
		connect by prior 	ig.group_id = ig.parent_group_id
		start with 		ig.group_id = :sph_group_id
	</querytext>
	</fullquery>

	<fullquery name="inst::sph::personnel_delete.sph_personnel_delete">
	<querytext>
		delete from sph_personnel where personnel_id = :personnel_id
		delete from sph_personnel_categories where personnel_id = :personnel_id
	</querytext>
	</fullquery>

	<fullquery name="inst::sph::category_list.get_category_list">
	<querytext>
		select name, category_id from categories where parent_category_id=:parent_category_id
	</querytext>
	</fullquery>
</queryset>
