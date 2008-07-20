<?xml version="1.0"?>
<queryset>
	<fullquery name="search">
	<querytext>
		select 	qb.personnel_id, qb.first_names, qb.last_name
		from 	(select	qa.personnel_id, qa.first_names, qa.last_name, rownum row_real
			from	(select distinct ip.personnel_id, per.first_names, per.last_name
				from persons per, inst_personnel ip
				$where_clause
				order by ip.personnel_id) qa) qb
		
	</querytext>
	</fullquery>
</queryset>
