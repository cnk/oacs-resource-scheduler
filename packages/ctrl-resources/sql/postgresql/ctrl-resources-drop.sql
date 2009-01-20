-- /packages/ctrl-resources/sql/oracle/ctrl-resources-drop.sql
--
-- Drop Script for CTRL Resources
--
-- @author avni@ctrl.ucla.edu (AK)
-- @creation-date 12/6/2005
-- @cvs-id $Id$
--

-- @crs-categories-delete


begin
      	FOR x in (select object_id from acs_objects where object_type = 'crs_event') LOOP
          crs_event.del(x.object_id);
      	END LOOP;
	acs_object_type.drop_type('crs_event');
end;
/
show errors
drop package crs_event;
commit;


begin
      	FOR x in (select object_id from acs_objects where object_type = 'crs_request') LOOP
          crs_request.del(x.object_id);
      	END LOOP;
	acs_object_type.drop_type('crs_request');
end;
/
show errors
drop package crs_request;
commit;


begin
      	FOR x in (select object_id from acs_objects where object_type = 'crs_room') LOOP
          crs_room.del(x.object_id);
      	END LOOP;
	acs_object_type.drop_type('crs_room');
end;
/
show errors
drop package crs_room;
commit;


begin
      	FOR x in (select object_id from acs_objects where object_type = 'crs_reservable_resource') LOOP
          crs_reservable_resource.del(x.object_id);
	END LOOP;
	acs_object_type.drop_type('crs_reservable_resource');
end;
/
show errors
drop package crs_reservable_resource;
commit;


begin
      	FOR x in (select object_id from acs_objects where object_type = 'crs_image') LOOP
          crs_image.del(x.object_id);
      	END LOOP;
	acs_object_type.drop_type('crs_image');
end;
/
show errors
drop package crs_image;
commit;


begin
      	FOR x in (select object_id from acs_objects where object_type = 'crs_resource') LOOP
          crs_resource.del(x.object_id);
      	END LOOP;
	acs_object_type.drop_type('crs_resource');
end;
/
show errors
drop package crs_resource;
commit;

@crs-tables-drop
commit;
