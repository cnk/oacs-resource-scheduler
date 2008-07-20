<?xml version="1.0"?>
<queryset> 
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="get_groups_search">
	<querytext>
	select * from 
	  (select group_name,group_id,short_name,description,rownum as row_num from
	     (select * from
	     	  (select g.group_name,
			g.group_id,
			i.short_name,
			i.description
		  from  groups g,
			inst_groups i
		  where lower(g.group_name) like lower('%$group_name%') and g.group_id = i.group_id)
		order by group_name) table_name
	   ) outter_table
	where (row_num >= :lower_bound and row_num <= :upper_bound) 
	</querytext>
	</fullquery>

	<fullquery name="get_total_items">
	<querytext>
	select count(*) as total_items
		  from  groups g, inst_groups i
		  where lower(g.group_name) like lower('$group_name%') and g.group_id = i.group_id
	</querytext>
	</fullquery>

</queryset>

