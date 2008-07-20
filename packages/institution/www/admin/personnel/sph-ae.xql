<?xml version="1.0"?>
<queryset>
	<fullquery name="get_sph_data">
		<querytext>
		select courses from sph_personnel where personnel_id=:sph_personnel_id
		</querytext>
	</fullquery>

	<fullquery name="sph_personnel_add">
		<querytext>
			insert into sph_personnel (
				personnel_id,
				courses
			) values (
				:personnel_id,
				:courses
			)			
		</querytext>
	</fullquery>

	<fullquery name="sph_personnel_edit">
		<querytext>
			update 	sph_personnel 
			set	courses = :courses
			where   personnel_id 		= :personnel_id
		</querytext>
	</fullquery>

	<fullquery name="sph_personnel_categories">
		<querytext>
			insert into sph_personnel_categories (
				personnel_id,
				pc_id,
				c_id
			) values (
				:personnel_id,
				:pc_id,
				:c_id
			)			
		</querytext>
	</fullquery>

	<fullquery name="sph_personnel_categories_delete">
		<querytext>
			delete from sph_personnel_categories 
			where   personnel_id = :personnel_id
		</querytext>
	</fullquery>

	<fullquery name="get_categories">
		<querytext>
			select c_id from sph_personnel_categories 
			where pc_id=:pc_id and personnel_id=:personnel_id
		</querytext>
	</fullquery>

</queryset>
