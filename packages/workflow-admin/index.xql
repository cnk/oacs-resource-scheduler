<?xml version="1.0"?>
<queryset>
	
	<fullquery name="get_wfs">
	        <querytext>
		select workflow_id,
			short_name,
			pretty_name
		from workflows
		where $where_clause
		 </querytext>
	</fullquery>

</queryset>
