<?xml version="1.0"?>
<queryset>
	<fullquery name="sttp_req">
	 <querytext>
		select	request_id,
				description,
				n_grads_currently_employed,
				n_requested,
				n_received,
				last_md_candidate,
				last_md_year,
				attend_poster_session_p,
				experience_required_p,
				skill_required_p,
				skill,
				department_chair_name,
				personnel_id,
				group_id,
				to_char(expiration_date + 270, 'MM DD YYYY') as expiration_date
		  from	inst_short_term_trnng_progs
		 where	personnel_id = :personnel_id
			$sql_request
	 </querytext>
	</fullquery>

	<fullquery name="sttp_selection">
	 <querytext>
		select		request_id,
				description,
				n_grads_currently_employed,
				n_requested,
				n_received,
				last_md_candidate,
				last_md_year,
				attend_poster_session_p,
				experience_required_p,
				skill_required_p,
				skill,
				department_chair_name,
				personnel_id,
				group_id,
				to_char(expiration_date + 270, 'YYYY MM DD') as expiration_date
		  from	inst_short_term_trnng_progs
		 where	personnel_id = :personnel_id
			$sql_request
	 </querytext>
	</fullquery>

	<fullquery name="subsite_groups">
	 <querytext>
		select	lpad(' ', 4*6*(level-1), '&nbsp;') || short_name,
				group_id,
				parent_group_id,
				short_name
		  from	inst_groups g
		 where	[subsite::parties_sql -groups -party_id {g.group_id}]
		   and	(group_type_id in (
						category.lookup('//Group Type//Department'),
						category.lookup('//Group Type//Academic Department'),
						category.lookup('//Group Type//Clinical Department'),
						category.lookup('//Group Type//Division')
					)
				or exists
					(select	1
					   from	vw_group_component_map	gcm,
							inst_groups				g2
					  where	gcm.ancestor_id	= g.group_id
						and gcm.child_id	= g2.group_id
						and g2.group_type_id in (
								category.lookup('//Group Type//Department'),
								category.lookup('//Group Type//Academic Department'),
								category.lookup('//Group Type//Clinical Department'),
								category.lookup('//Group Type//Division')
							)
					)
				)
		connect	by prior group_id = parent_group_id
		 start	with group_id in ([subsite::parties_sql -only -trunk -groups])
	 </querytext>
	</fullquery>

	<fullquery name="sttp_new">
	 <querytext>
		begin
			:1 := inst_short_term_trnng_prog.new(
						personnel_id				=> :personnel_id,
						description					=> :description,
						n_grads_currently_employed	=> :n_grads_currently_employed,
						n_requested					=> :n_requested,
						n_received					=> :n_received,
						last_md_candidate			=> :last_md_candidate,
						last_md_year				=> :last_md_year,
						attend_poster_session_p		=> :attend_poster_session_p,
						experience_required_p		=> :experience_required_p,
						skill_required_p			=> :skill_required_p,
						skill						=> :skill,
						department_chair_name		=> :department_chair_name,
						group_id					=> :group_id,
						expiration_date				=> :expiration_date,
						creation_user				=> :user_id,
						creation_ip					=> :peer_ip,
						context_id					=> :personnel_id
			);
		end;
	 </querytext>
	</fullquery>

	<fullquery name="sttp_edit">
	 <querytext>
		update	inst_short_term_trnng_progs
		   set	description					= :description,
				n_grads_currently_employed	= :n_grads_currently_employed,
				n_requested					= :n_requested,
				n_received					= :n_received,
				last_md_candidate			= :last_md_candidate,
				last_md_year				= :last_md_year,
				attend_poster_session_p		= :attend_poster_session_p,
				experience_required_p		= :experience_required_p,
				skill_required_p			= :skill_required_p,
				skill						= :skill,
				department_chair_name		= :department_chair_name,
				expiration_date				= :expiration_date,
				group_id					= :group_id
		where	request_id	= :request_id
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
