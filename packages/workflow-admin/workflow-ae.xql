<?xml version="1.0"?>
<queryset>
	
	<fullquery name="get_packages">
	        <querytext>
		 select LPAD (' ', 3*(Level-2)) || name,
			object_id,
			name as rawname,
			level
		 from 	site_nodes n
  		 where 	name is not null
		 connect by prior node_id=parent_id
		 start with object_id=405
		 </querytext>
	</fullquery>


	
	<fullquery name="get_package_options">
	        <querytext>
		select distinct package_key,package_key
		from   apm_packages
		 </querytext>
	</fullquery>
</queryset>
