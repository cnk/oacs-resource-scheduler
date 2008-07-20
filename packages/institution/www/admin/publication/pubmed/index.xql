<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="publication_information">
	 <querytext>
		select	title,
			publication_name,
			url,
			authors,
			volume,
			issue,
			page_ranges,
			year,
			publish_date,
			publication_type,
			dbms_lob.getlength(publication)		as content_bytes,
			to_char(o.creation_date, 'yyyy-mm-dd')	as created_on,
			to_char(o.creation_date, 'hh:miam')	as created_at,
			person.name(o.creation_user)		as created_by,
			o.creation_ip				as created_from,
			to_char(o.last_modified, 'yyyy-mm-dd')	as modified_on,
			to_char(o.last_modified, 'hh:miam')	as modified_at,
			person.name(o.modifying_user)		as modified_by,
			o.modifying_ip				as modified_from
		  from	inst_publications	ip,
			acs_objects		o
		 where	ip.publication_id	= :publication_id
		   and	ip.publication_id	= o.object_id
	 </querytext>
	</fullquery>

	<fullquery name="publication_personnel">
	 <querytext>
		select 	p.first_names,
			   	p.last_name,
				p.person_id
		from   	inst_personnel_publication_map ippm,
				persons p
		where   ippm.publication_id = :publication_id
		and		ippm.personnel_id   = p.person_id
		order   by p.last_name asc, p.first_names asc
	 </querytext>
	</fullquery>

	<fullquery name="pubmed_status">
	 <querytext>
	    select count(*)
		from   inst_external_pub_id_map
		where  inst_publication_id = :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="pubmed_data">
	 <querytext>
	    select pubmed_id,
	           pubmed_xml,
        	   decode(data_imported_p,'t','Yes','No') as data_imported_p
    	    from   inst_external_pub_id_map
    	    where  inst_publication_id = :publication_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:		-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
