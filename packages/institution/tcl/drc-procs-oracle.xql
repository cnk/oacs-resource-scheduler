<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	<fullquery name="inst::drc::personnel_data_xml.get_employee_info">
		<querytext>
		select 	ip.personnel_id,
	       		p.first_names,
	       		p.last_name
		from   	inst_personnel ip,
	       		persons p
		where  ip.employee_number = trim(:employee_number)
		and    ip.personnel_id = p.person_id
		</querytext>
	</fullquery>

	<fullquery name="inst::drc::personnel_data_xml.get_group_membership_info">
		<querytext>
	    	select 	category.name(igpm.title_id) as title,
                        igpm.title_id, 
	           	ar.object_id_one as group_id,
	           	g.group_name
	    	from   	acs_rels ar,
	           	inst_group_personnel_map igpm,
	           	groups g
	    	where  	ar.object_id_two = :personnel_id
	    	and    	ar.rel_id = igpm.acs_rel_id
	    	and    	ar.object_id_one = g.group_id
	    	order  by ar.object_id_one
		</querytext>
	</fullquery>

	<fullquery name="inst::drc::personnel_login_data_xml.get_login_info">
		<querytext>
		select	prty.party_id			as party_id,
			psn.person_id			as person_id,
			usr.user_id			as user_id,
			psnl.personnel_id		as personnel_id,
			lower(trim(prty.email))		as personnel_email,
			nvl(psnl.personnel_id,0)	as en_party_id,
			nvl(eml.party_id,0)		as email_party_id,
			psn.first_names			as first_name,
			psn.last_name
		  from	(select	party_id,
				lower(trim(email)) as email
			   from	parties)		eml,
			inst_personnel			psnl,
			persons				psn,
			parties				prty,
			users				usr,
			(select	to_number(:employee_number)	as employee_number,
				:email				as email
			   from	dual)		input
		 where	psnl.employee_number(+)		= input.employee_number
		   and	eml.email(+)			= input.email
		   and	psn.person_id			= prty.party_id(+)
		   and	psn.person_id			= usr.user_id(+)
		   and	psn.person_id			= psnl.personnel_id
		   and	rownum				< 2
		 order	by abs(eml.party_id - prty.party_id)
		</querytext>
	</fullquery>
</queryset>
