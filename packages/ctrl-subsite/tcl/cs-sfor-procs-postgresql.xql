<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

   <fullquery name="ctrl::subsite::object_rel_new.subsite_object_rel_new">
      <querytext>
              select ctrl_subsite_for_object_rel__new (
                        :subsite_id,
   	                :object_id
            )
      </querytext>
   </fullquery>

   <fullquery name="ctrl::subsite::object_rel_del.subsite_object_rel_del">
      <querytext>
	    DECLARE
		r record;
	    BEGIN
		FOR r in select ar.rel_id
			    from acs_rels ar	
			   where ar.object_id_two = :object_id
			     and ar.rel_type = 'ctrl_subsite_for_object_rel' LOOP
		    PERFORM ctrl_subsite_for_object_rel__delete(r.rel_id);
	    	END LOOP;

		return 1;
	    END;
      </querytext>
   </fullquery>

</queryset>
