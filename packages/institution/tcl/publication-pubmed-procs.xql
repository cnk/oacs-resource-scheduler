<?xml version="1.0"?>
<queryset>
 	<fullquery name="publication::pubmed::search.get_publications">
	 <querytext>
		select 	publication_id,
	       		title
		from   	inst_publications ip  $publication_constraint
		order  	by ip.publication_id
	 </querytext>
	</fullquery>

        <fullquery name="publication::pubmed::search.publication_pubmed_insert">
         <querytext>
		insert into inst_external_pub_id_map (inst_publication_id, pubmed_id, pubmed_xml, data_imported_p)
		values (:publication_id, :pubmed_id, empty_clob(), 'f')
		returning pubmed_xml into :1
	 </querytext>
	</fullquery>

	<fullquery name="publication::pubmed::get_xml_data.publication_update">
	 <querytext>
		update inst_publications
	    	$sql_data
            	where  publication_id = :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="publication::pubmed::import.pubmed_xml">
	 <querytext>
		select pubmed_xml
		from   inst_external_pub_id_map
		where  inst_publication_id = :publication_id
		and    pubmed_id = :pubmed_id
	 </querytext>
	</fullquery>

	<fullquery name="publication::pubmed::import.import_status_update">
	 <querytext>
		update 	inst_external_pub_id_map
		set 	data_imported_p = 't'
		where   inst_publication_id = :publication_id
		and     pubmed_id = :pubmed_id
	 </querytext>
	</fullquery>

	<fullquery name="publication::pubmed::delete.pubmed_delete">
	 <querytext>
		delete from inst_external_pub_id_map
		where  inst_publication_id = :publication_id $pubmed_id_constraint
	 </querytext>
	</fullquery>


</queryset>
