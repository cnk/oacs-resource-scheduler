<?xml version="1.0"?>
<queryset> 
  <rdbms><type>postgresql</type><version>7.4</version></rdbms>
	<fullquery name="get_object_types">
		<querytext>
			select acs_object__name(object_id) as object_name, object_id  
			from acs_objects order by object_name asc
			limit 20
		</querytext>
	</fullquery>

	<fullquery name="today_date">
		<querytext>
		    select to_char(now(),'yyyy mm dd hh24') || ' 0' 
		</querytext>
	</fullquery>

	<fullquery name="today_date_end">
		<querytext>
		    select to_char(now() + '1 hour','yyyy mm dd hh24') || ' 0' 
		</querytext>
	</fullquery>
</queryset>
