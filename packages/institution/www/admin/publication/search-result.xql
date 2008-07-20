<?xml version="1.0"?>
<queryset>
	<fullquery name="search">
	<querytext>
		select 	distinct qb.publication_id, qb.pub_title, qb.pub_authors
		from 	(select	qa.publication_id, qa.pub_title, qa.pub_authors, rownum row_real
			from	(select distinct publication_id, title as pub_title, authors as pub_authors 
				from inst_publications
				$where_clause
				order by publication_id) qa) qb
		
	</querytext>
	</fullquery>
</queryset>
