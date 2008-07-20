<?xml version="1.0"?>
<queryset>
    <fullquery name="person_info">
	<querytext>
	select 	first_names, 
		middle_name, 
		last_name 
	from 	persons 
	where 	person_id = :personnel_id
	</querytext>
    </fullquery>

    <fullquery name="ri_select">
	<querytext>
	    select lay_title,
        	   lay_interest,
		   technical_title,
		   technical_interest
    	    from   inst_subsite_pers_res_intrsts
	    where  personnel_id = :personnel_id
	    and    subsite_id   = :subsite_id
	</querytext>
    </fullquery>

    <fullquery name="ri_subsite_name">
	<querytext>
	select	distinct
		acs_object.name(spr.object_id_one)	as subsite_name
	  from	acs_rels		spr,
		vw_group_member_map	gmm,
		groups			g
	 where	spr.rel_type		= 'subsite_for_party_rel'
	   and	spr.object_id_two	= g.group_id
	   and	g.group_id		= gmm.ancestor_id
	   and	gmm.child_id		= :personnel_id
	   and  spr.object_id_one	= :subsite_id
        </querytext>
    </fullquery>
	
    <fullquery name="ri_exists_p">
	<querytext>
	  select count(*) 
	  from   inst_subsite_pers_res_intrsts 
	  where  personnel_id = :personnel_id
	  and    subsite_id = :subsite_id
	</querytext>
    </fullquery>
</queryset>
