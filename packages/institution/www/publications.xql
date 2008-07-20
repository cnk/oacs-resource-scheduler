<?xml version="1.0"?>
<queryset>
	<fullquery name="custom_ordered_publications_p">
	 <querytext>
		select	1
		  from	dual
		 where	exists
				(select 1
				   from	inst_psnl_publ_ordered_subsets
				  where	personnel_id	= :personnel_id
					and	subsite_id		= :subsite_id)
	 </querytext>
	</fullquery>

	<fullquery name="custom_ordered_publications_subset">
	 <querytext>
		select	pub.title,
				pub.publication_id,
				pub.publication_name,
				pub.url,
				pub.authors,
				pub.volume,
				pub.issue,
				pub.page_ranges,
				pub.year,
				pub.publisher,
				pub.publish_date,
				pub.priority_number,
				dbms_lob.getlength(pub.publication)	as bytes
		  from	inst_publications				pub,
				inst_psnl_publ_ordered_subsets	pos
		 where	pos.publication_id	= pub.publication_id
		   and	pos.personnel_id	= :personnel_id
		   and	pos.subsite_id		= :subsite_id
		 order	by pos.relative_order, pub.priority_number desc, pub.publish_date desc, pub.year desc, pub.title
	 </querytext>
	</fullquery>

	<fullquery name="publications">
	 <querytext>
		select	pub.title,
				pub.publication_id,
				pub.publication_name,
				pub.url,
				pub.authors,
				pub.volume,
				pub.issue,
				pub.page_ranges,
				pub.year,
				pub.publisher,
				pub.publish_date,
				pub.priority_number,
				dbms_lob.getlength(pub.publication)	as bytes
		  from	inst_publications				pub,
				inst_personnel_publication_map	ppm
		 where	ppm.publication_id	= pub.publication_id
		   and	ppm.personnel_id	= :personnel_id
		 order	by pub.priority_number desc, pub.publish_date desc, pub.year desc, pub.title
	 </querytext>
	</fullquery>
</queryset>
