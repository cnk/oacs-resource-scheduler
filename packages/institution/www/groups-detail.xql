<?xml version="1.0"?>
<queryset>

	<fullquery name="get_alias_for_group_id">
		<querytext>
			select 	nvl(alias_for_group_id,0) as alias_for_group_id
			from	inst_groups
			where	group_id = :group_id
		</querytext>
	</fullquery>


	<fullquery name="group_children">
	 <querytext>
		select	group_id
		  from	inst_groups		g,
				categories		c
		 where	parent_group_id = :group_id
		   and	g.group_type_id	= c.category_id
		   and	c.enabled_p		= 't'
	 </querytext>
	</fullquery>

	<fullquery name="subgroup_types">
	 <querytext>
		select	c.plural group_type
		  from	categories	c,
				inst_groups	g
		 where	g.parent_group_id	= :group_id
		   and	g.group_type_id		= c.category_id
		   and	c.enabled_p			= 't'
		 group	by g.group_type_id, c.plural
	 </querytext>
	</fullquery>

	<fullquery name="group_cat_info">
	 <querytext>
		select	pc.name	parent_name,
				c.name	name
		  from	inst_party_category_map	ipcm,
				categories				pc,
				categories				c
		 where	ipcm.category_id		= c.category_id
		   and	c.parent_category_id	= pc.category_id
		   and	ipcm.party_id			= :group_id
		 order	by pc.category_id, c.name
	 </querytext>
	</fullquery>

	<fullquery name="group_phone">
	 <querytext>
		select	ipp.phone_number,
				c.name,
				ipp.description					descript,
				substr(ipp.phone_number, 1, 1)	country_code,
				substr(ipp.phone_number, 2, 3)	area_code,
				substr(ipp.phone_number, 5, 3)	prefix,
				substr(ipp.phone_number, 8, 4)	num
		  from	inst_party_phones	ipp,
				categories			c
		 where	party_id		= :group_id
		   and	phone_type_id	= category_id
		   $group_phones_filter
		   and	enabled_p		= 't'
		 order	by phone_type_id,
				profiling_weight,
				ipp.phone_number
	 </querytext>
	</fullquery>

	<fullquery name="group_urls">
	 <querytext>
		select	*
		  from	inst_party_urls, categories
		 where	party_id	= :group_id
		   and	url_type_id	= category_id
		   and	enabled_p	= 't'
		 order	by url_type_id,
				profiling_weight,
				url
	 </querytext>
	</fullquery>

	<fullquery name="group_emails">
	 <querytext>
		select	*
		  from	inst_party_emails, categories
		 where	party_id		= :group_id
		   and	email_type_id	= category_id
		   and	enabled_p		= 't'
		 order	by email_type_id,
				profiling_weight,
				email
	 </querytext>
	</fullquery>

	<fullquery name="group_certifications">
	 <querytext>
		select	*
		  from	inst_certifications, categories
		 where	party_id				= :group_id
		   and	certification_type_id	= category_id
		   and	enabled_p				= 't'
		 order	by certification_type_id,
				profiling_weight,
				certifying_party,
				certification_credential
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
