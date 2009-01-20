<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="get_object_types">
		<querytext>
			select acs_object.name(object_id) as object_name, object_id  
			from acs_objects where rownum < 20 order by object_name asc
		</querytext>
	</fullquery>

	<fullquery name="today_date">
		<querytext>
		    select to_char(sysdate,'yyyy mm dd hh24') || ' 0' from dual
		</querytext>
	</fullquery>

	<fullquery name="today_date_end">
		<querytext>
		    select to_char(sysdate + 0.04167,'yyyy mm dd hh24') || ' 0' from dual
		</querytext>
	</fullquery>
</queryset>
