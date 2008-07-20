<?xml version="1.0"?>
<queryset>
	<fullquery name="publication::publication_add.publication_insertion">
	 <querytext>
		    update inst_publications 
		    set publish_date = to_date(:publish_date, 'YYYY-MM-DD') 
		    where publication_id = :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="publication::publication_add.update_publication">
	 <querytext>
		update	    inst_publications
		set	    publication = empty_blob(),
		publication_type = :file_type
		where	    publication_id = :publication_id
		returning publication into :1
	 </querytext>
	</fullquery>


	<fullquery name="publication::publication_add.ippm_create">
	 <querytext>
		insert into inst_personnel_publication_map
		(publication_id,
		 personnel_id,
	 	 mapping_date)
	    	values (:publication_id,
		    	:personnel_id,
		    	sysdate)
	 </querytext>
	</fullquery>

	<fullquery name="publication::publication_exist.get_publication_check">
	 <querytext>
		select count(*) from inst_publications where publication_id = :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="publication::publication_edit.publication_update">
	 <querytext>
	    update inst_publications 
	    set publish_date = to_date(:publish_date, 'YYYY-MM-DD'),
	        title = :title,
	        publication_name = :publication_name,
	        url = :url,
	        authors = :authors,
	        volume = :volume,
	        issue = :issue,
	        page_ranges = :page_ranges,
	        year = :year,
	        publisher = :publisher,
	        priority_number = :priority_number
	    where publication_id = :publication_id
	 </querytext>
	</fullquery>

 	<fullquery name="publication::publication_edit.update_publication">
	 <querytext>
		update	    inst_publications
		set	    publication = empty_blob(),
		            publication_type = :file_type
		where	    publication_id = :publication_id
		returning publication into :1
	 </querytext>
	</fullquery>

 	<fullquery name="publication::publication_personnel_map.ippm_create">
	 <querytext>
		    insert into inst_personnel_publication_map 
	    		(publication_id, 
	     		 personnel_id,
	    		 mapping_date)
	    	    values (:publication,
		    	    :personnel_id,
		    	    sysdate)
	 </querytext>
	</fullquery>

 	<fullquery name="publication::publication_delete.publication_map_delete">
	 <querytext>
		delete from inst_personnel_publication_map where publication_id = :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="publication::audit.publication_audit">
	 <querytext>
		insert into inst_publications_audit (publication_id,
					     title,
					     publication_name,
					     url,
					     authors,
					     volume,
					     issue,
					     page_ranges,
					     year,
					     publish_date,
					     publisher)
		select 	publication_id,
	       		title,
	       		publication_name,
	       		url,
	       		authors,
	       		volume,
	       		issue,
	       		page_ranges,
	       		year,
	       		publish_date,
	       		publisher
		from   inst_publications
		where  publication_id = :publication_id
	 </querytext>
	</fullquery>
</queryset>
