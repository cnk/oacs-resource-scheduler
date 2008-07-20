<?xml version="1.0"?>
<queryset>
	<fullquery name="sttp_selection">
	 <querytext>
		select	i.description,
				i.n_grads_currently_employed,
				i.n_requested,
				i.n_received,
				i.last_md_candidate,
				i.last_md_year,
				i.attend_poster_session_p,
				i.experience_required_p,
				i.skill_required_p,
				i.skill,
				i.department_chair_name,
				i.personnel_id,
				g.group_id,
				g.short_name
		  from	inst_short_term_trnng_progs	i,
				inst_groups					g
		 where	i.request_id	= :request_id
		   and	i.group_id		= g.group_id (+)
	 </querytext>
	</fullquery>

	<fullquery name="subsite_groups">
	 <querytext>
		select	lpad(' ', 4*6*(level-1), '&nbsp;') || short_name, group_id
		  from	inst_groups g
		 where	[subsite::parties_sql -groups -party_id {g.group_id}]
		connect	by prior group_id = parent_group_id
		 start	with group_id in ([subsite::parties_sql -only -trunk -groups])
	 </querytext>
	</fullquery>

	<fullquery name="sttp_delete">
	 <querytext>
		begin
			inst_short_term_trnng_prog.delete(request_id => :request_id);
		end;
	 </querytext>
	</fullquery>
</queryset>

<!--	Local Variables:	-->
<!--	mode:		sql		-->
<!--	tab-width:	4		-->
<!--	End:				-->
