<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8</version></rdbms>
	<fullquery name="ctrl_procs::acs_object::update_object.update">
	        <querytext>
		begin
			acs_object.update_last_modified (
				object_id 	=> :object_id, 
                                modifying_user  => :modifying_user ,
                                modifying_ip    => :modifying_ip
			);
		end;
		 </querytext>
	</fullquery>
</queryset>
