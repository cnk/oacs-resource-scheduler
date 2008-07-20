<?xml version="1.0"?>
<queryset>
	<fullquery name="get_subsite_list">
	  <querytext>
	      	select 	instance_name,
            		package_id
    		from    apm_packages
    		where   package_key = 'acs-subsite'
    		and     package_id != :main_subsite_id
    		order   by instance_name asc
	  </querytext>
	</fullquery>


	<fullquery name="get_calendar_subsite_id_list">
	  <querytext>
		select 	object_id_one 
		from 	acs_rels ar, 
			ctrl_subsite_for_object_rels csor 
		where 	ar.rel_id = csor.rel_id 
		and 	ar.object_id_two = :cal_id
	  </querytext>
	</fullquery>
</queryset>
