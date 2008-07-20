<?xml version="1.0"?>
<queryset>
        <fullquery name="sttp_selection">
                <querytext>
                        select  i.description, i.n_grads_currently_employed,
                                i.n_requested, i.n_received,
                                i.last_md_candidate, i.last_md_year,
                                i.attend_poster_session_p, i.experience_required_p,
                                i.skill_required_p, i.skill, i.request_id,
                                i.department_chair_name, i.personnel_id, g.group_id, g.short_name,
				p.last_name, p.first_names, pa.url
                        from    inst_short_term_trnng_progs i, inst_groups g, persons p, parties pa
                        where   i.group_id = g.group_id and
				i.personnel_id = p.person_id and
				i.personnel_id = pa.party_id and
				i.request_id = :request_id
                </querytext>
        </fullquery>

        <fullquery name="sttp_email">
                <querytext>
			select 	description, email
			from	inst_party_emails
			where	party_id = :personnel_id
                </querytext>
        </fullquery>

        <fullquery name="sttp_address">
                <querytext>
			select 	building_name, room_number, description
			from	inst_party_addresses
			where	party_id = :personnel_id
                </querytext>
        </fullquery>

        <fullquery name="sttp_phone">
                <querytext>
			select 	description, phone_number
			from	inst_party_phones
			where	party_id = :personnel_id
                </querytext>
        </fullquery>
</queryset>
