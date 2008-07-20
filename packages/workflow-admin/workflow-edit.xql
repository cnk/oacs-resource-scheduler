<?xml version="1.0"?>
<queryset>
	
	<fullquery name="get_states">
	        <querytext>	
		select state_id,
			short_name,
			pretty_name
		from    workflow_fsm_states
		where   workflow_id=:workflow_id
		order   by short_name
		 </querytext>
	</fullquery>


	<fullquery name="get_actions">
	        <querytext>
		select  a.action_id,
			short_name,
			pretty_name,
			new_state
		from  	workflow_actions a,
			workflow_fsm_actions fa
		where 	workflow_id=:workflow_id and
			a.action_id=fa.action_id
		order by short_name
		 </querytext>
	</fullquery>


	<fullquery name="get_roles">
	        <querytext>
		select 	role_id,
			pretty_name
		from workflow_roles
		where workflow_id=:workflow_id
		 </querytext>
	</fullquery>

</queryset>
