<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="object_names">
	 <querytext>
		select	acs_object.name(:personnel_id)	as personnel_name,
				acs_object.name(:subsite_id)	as subsite_name
		  from dual
	 </querytext>
	</fullquery>

	<fullquery name="publication_attributes">
	 <querytext>
		select	pretty_name, attribute_name
		  from	acs_attributes
		 where	object_type		= 'inst_publication'
	 </querytext>
	</fullquery>

	<fullquery name="create_default_ordered_subset">
	 <querytext>
		declare
			i integer := 0;
		begin
			for p in (select	:subsite_id	as subsite_id,
								ppm.publication_id		as publication_id,
								:personnel_id			as personnel_id
						from	inst_personnel_publication_map	ppm,
								inst_publications				pub
					   where	ppm.personnel_id	= :personnel_id
						 and	ppm.publication_id	= pub.publication_id
					   order	by publish_date desc, year desc, title) loop
				insert into inst_psnl_publ_ordered_subsets (
						subsite_id,
						publication_id,
						personnel_id,
						relative_order
					) values (
						p.subsite_id,
						p.publication_id,
						p.personnel_id,
						i
				);
				i := i + 1;
			end loop;
		end;
	 </querytext>
	</fullquery>

	<fullquery name="unordered_personnel_publications">
	 <querytext>
		select	year || ': ' || substr(pbl.title,1,60) ||
				decode(substr(pbl.title,61,1),
						null, '', '...') as title,
				ppm.publication_id,
				pbl.year
		  from	inst_personnel_publication_map	ppm,
				inst_publications				pbl
		 where	ppm.publication_id	= pbl.publication_id
		   and	ppm.personnel_id	= :personnel_id
		   and	not exists
				(select	1
				   from	inst_psnl_publ_ordered_subsets
				  where	personnel_id	= :personnel_id
					and	publication_id	= ppm.publication_id
					and	subsite_id		= :subsite_id)
		 order	by pbl.publish_date desc, pbl.year desc, pbl.title
	 </querytext>
	</fullquery>

	<fullquery name="ordered_personnel_publications">
	 <querytext>
		select	year || ': ' || substr(pbl.title,1,60) ||
				decode(substr(pbl.title,61,1),
						null, '', '...') as title,
				ppm.publication_id,
				pbl.year
		  from	inst_personnel_publication_map	ppm,
				inst_publications				pbl,
				inst_psnl_publ_ordered_subsets	pos
		 where	ppm.publication_id	= pbl.publication_id
		   and	ppm.publication_id	= pos.publication_id
		   and	ppm.personnel_id	= pos.personnel_id
		   and	ppm.personnel_id	= :personnel_id
		   and	pos.subsite_id		= :subsite_id
		 order	by pos.relative_order, pbl.publish_date desc, pbl.year desc, pbl.title
	 </querytext>
	</fullquery>

	<fullquery name="delete_custom_ordering">
	 <querytext>
		delete from inst_psnl_publ_ordered_subsets
		 where	subsite_id		= :subsite_id
		   and	personnel_id	= :personnel_id
	 </querytext>
	</fullquery>

	<fullquery name="insert_automatic_ordering">
	 <querytext>
		begin
			for p in (select	rownum,
								publication_id
						from	(select	p.publication_id
								   from	inst_publications				p,
										inst_personnel_publication_map	ppm
								  where	ppm.personnel_id	= :personnel_id
									and	ppm.publication_id	= p.publication_id
									and	p.publication_id in
											([join $included ,])
								  order	by $order_by_sql)) loop
				insert into inst_psnl_publ_ordered_subsets (
						subsite_id,
						personnel_id,
						publication_id,
						relative_order
					) values (
						:subsite_id,
						:personnel_id,
						p.publication_id,
						p.rownum
				);
			end loop;
		end;
	 </querytext>
	</fullquery>

	<fullquery name="insert_custom_ordering">
	 <querytext>
		insert into inst_psnl_publ_ordered_subsets (
				subsite_id,
				personnel_id,
				publication_id,
				relative_order
			) values (
				:subsite_id,
				:personnel_id,
				:publication_id,
				:relative_order
		)
	 </querytext>
	</fullquery>

	<fullquery name="update_automatic_ordering">
	 <querytext>
		update	inst_psnl_publ_ordered_subsets
		   set	relative_order	= :relative_order
		 where	subsite_id		= :subsite_id
		   and	personnel_id	= :personnel_id
		   and	publication_id	= :publication_id
	 </querytext>
	</fullquery>

	<fullquery name="delete_ordering_of_unassociated_publications">
	 <querytext>
		delete from inst_psnl_publ_ordered_subsets	pos
		 where	pos.subsite_id		= :subsite_id
		   and	pos.personnel_id	= :personnel_id
		   and	not exists
				(select	1
				   from	inst_personnel_publication_map	ppm
				  where	ppm.personnel_id	= pos.personnel_id
					and	ppm.publication_id	= pos.publication_id)
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->