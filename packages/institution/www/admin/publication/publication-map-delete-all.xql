<?xml version="1.0"?>
<queryset>

	<fullquery name="delete_publication_personnel_subsets">
	 <querytext>
		delete from inst_psnl_publ_ordered_subsets
		where  publication_id = :publication_id 
		and    personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="delete_publication_maps">
	 <querytext>
		delete from inst_personnel_publication_map
		where publication_id = :publication_id 
		and personnel_id = :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="publication_personnel_map_exists_p">
	 <querytext>
		select count(*)
		from   inst_personnel_publication_map
		where  publication_id = :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="person_exist">
	<querytext>
	    select	first_names,
			last_name
	      from	persons
	     where	person_id = :personnel_id
	</querytext>
	</fullquery>

	<fullquery name="get_publication_title">
	<querytext>
	    select title as pub_title
	      from inst_publications
	     where publication_id = :del_item
	</querytext>
	</fullquery>

</queryset>
