<?xml version="1.0"?>
<queryset>
	
	<fullquery name="get_states">
	        <querytext>
		select	pretty_name,
			state_id
		from workflow_fsm_states
		where  workflow_id=:workflow_id
		 </querytext>
	</fullquery>

</queryset>
