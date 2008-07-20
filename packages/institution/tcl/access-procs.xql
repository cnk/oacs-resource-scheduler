<?xml version="1.0"?>
<queryset>
	<fullquery name="inst::access::update_publication_to_null.access_update_selected_publication_one_to_null">
	<querytext>
		update access_personnel 
		set    selected_pblctn_for_guide_id_1 = null
		where  selected_pblctn_for_guide_id_1 = :publication_id
	</querytext>
	</fullquery>

	<fullquery name="inst::access::update_publication_to_null.access_update_selected_publication_two_to_null">
	<querytext>
		update access_personnel 
		set    selected_pblctn_for_guide_id_2 = null
		where  selected_pblctn_for_guide_id_2 = :publication_id
	</querytext>
	</fullquery>

	<fullquery name="inst::access::update_publication_to_null.access_update_selected_publication_three_to_null">
	<querytext>
		update access_personnel 
		set    selected_pblctn_for_guide_id_3 = null
		where  selected_pblctn_for_guide_id_3 = :publication_id
	</querytext>
	</fullquery>

	<fullquery name="inst::access::update_publication_to_null_for_personnel.access_selected_publication_one_to_null">
	<querytext>
		update access_personnel 
		set    selected_pblctn_for_guide_id_1 = null 
		where  selected_pblctn_for_guide_id_1 = :publication_id
		and    personnel_id = :personnel_id
	</querytext>
	</fullquery>

	<fullquery name="inst::access::update_publication_to_null_for_personnel.access_selected_publication_two_to_null">
	<querytext>
		update access_personnel 
		set    selected_pblctn_for_guide_id_2 = null 
		where  selected_pblctn_for_guide_id_2 = :publication_id
		and    personnel_id = :personnel_id
	</querytext>
	</fullquery>

	<fullquery name="inst::access::update_publication_to_null_for_personnel.access_selected_publication_three_to_null">
	<querytext>
		update access_personnel 
		set    selected_pblctn_for_guide_id_3 = null 
		where  selected_pblctn_for_guide_id_3 = :publication_id
		and    personnel_id = :personnel_id
	</querytext>
	</fullquery>
</queryset>
