<?xml version="1.0"?>
<queryset>
	
	<fullquery name="get_wfs">
	        <querytext>
		select 	pretty_name,
			workflow_id
		from workflows
		where object_id is null
		 </querytext>
	</fullquery>

	<fullquery name="get_packages">
	        <querytext>
		 select LPAD (' ', 3*(Level-2)) || name,
			object_id,
			name as rawname,
			level
		 from 	site_nodes n
  		 where 	name is not null
		 connect by prior node_id=parent_id
		 start with object_id=(select object_id from site_nodes where parent_id is null)
		 </querytext>
	</fullquery>
</queryset>



