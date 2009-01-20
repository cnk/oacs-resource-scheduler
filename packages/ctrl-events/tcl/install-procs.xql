<?xml version="1.0"?>	
<queryset>
	<fullquery name="ctrl_event::install::before_uninstantiate.delete_event_data">
	  <querytext>
		select ctrl_event__delete(ce.event_id) from ctrl_events ce where ce.package_id=:package_id;
	  </querytext>
	</fullquery>
</queryset>