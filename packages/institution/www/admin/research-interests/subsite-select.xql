<?xml version="1.0"?>
<queryset>
    <fullquery name="person_info">
	<querytext>
	select 	first_names || ' ' || last_name as personnel_name,
		first_names, 
		middle_name, 
		last_name 
	from 	persons 
	where 	person_id = :personnel_id
	</querytext>
    </fullquery>

    <fullquery name="personnel_subsite_list">
	<querytext>
	select	distinct
		acs_object.name(spr.object_id_one)	as subsite_name,
		spr.object_id_one			as subsite_id
	  from	acs_rels		spr,
		vw_group_member_map	gmm,
		groups			g
	 where	spr.rel_type		= 'subsite_for_party_rel'
	   and	spr.object_id_two	= g.group_id
	   and	g.group_id		= gmm.ancestor_id
	   and	gmm.child_id		= :personnel_id
	union
	select	'<i>Default</i>', to_number(:main_subsite_id)
	  from	dual
	 order	by subsite_name
        </querytext>
    </fullquery>
	
</queryset>
