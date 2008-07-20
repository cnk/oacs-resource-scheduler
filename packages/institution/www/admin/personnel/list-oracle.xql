<?xml version="1.0"?>
<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

	<fullquery name="personnel">
	 <querytext>
		select	p.personnel_id,
				per.first_names,
				per.middle_name,
				per.last_name,
				decode(personnel_id - :user_id, 0, 1, 0)	as user_is_this_person_p,
				1 as read_p,
				1 as write_p,
				1 as create_p,
				1 as delete_p,
				1 as admin_p
		  from	inst_personnel	p,
				persons			per
		 where	p.personnel_id	in ($items)
		   and	per.person_id	= p.personnel_id
		 order	by last_name, first_names
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
