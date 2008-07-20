<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

   <fullquery name="ctrl::subsite::object_rel_new.subsite_object_rel_new">
      <querytext>
         begin
              :1 := ctrl_subsite_for_object_rel.new (
                        subsite_id => :subsite_id,
   	                object_id  => :object_id
            );
          end;
      </querytext>
   </fullquery>

   <fullquery name="ctrl::subsite::object_rel_del.subsite_object_rel_del">
      <querytext>
	    BEGIN
		FOR r in (select ar.rel_id
			    from acs_rels ar	
			   where ar.object_id_two = :object_id
			     and ar.rel_type = 'ctrl_subsite_for_object_rel') LOOP
		    ctrl_subsite_for_object_rel.del(r.rel_id);
	    	END LOOP;
	    END;
      </querytext>
   </fullquery>

</queryset>
