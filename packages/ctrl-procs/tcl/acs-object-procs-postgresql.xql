<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.4</version></rdbms>
	<fullquery name="ctrl_procs::acs_object::update_object.update">
	        <querytext>
		select acs_object__update_last_modified (:object_id, :modifying_user, :modifying_ip)
		 </querytext>
	</fullquery>
</queryset>
