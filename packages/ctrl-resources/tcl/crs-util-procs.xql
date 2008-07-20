<?xml version=1.0?>
<queryset>

	<fullquery name="crs::util::build_branch_js.get_resource_types">
		<querytext>
		  select distinct resource_category_name,
		                  resource_category_id
	          from crs_resv_resources_vw 
		</querytext>
	</fullquery>


	<fullquery name="crs::util::build_branch_js.get_resources">
		<querytext>
		  select  name,
		          resource_id
	          from crs_resv_resources_vw
		  where resource_category_id=:resource_type_id
		</querytext>
	</fullquery>

</queryset>
