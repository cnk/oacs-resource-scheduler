-- /packages/ctrl-events/sql/oracle/ctrl-events-objects-pkg-body-create.sql
--
-- Event Object Package Definition
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 11/08/2006
-- @cvs-id $Id:
--

create or replace package body ctrl_event_object
as 
   function new (
	event_object_id in ctrl_events_objects.event_object_id%TYPE,
	name 		in ctrl_events_objects.name%TYPE,
        last_name       in ctrl_events_objects.last_name%TYPE,
	object_type_id	in ctrl_events_objects.object_type_id%TYPE,
	description	in ctrl_events_objects.description%TYPE,
	url		in ctrl_events_objects.url%TYPE,
	creation_date 	in acs_objects.creation_date%TYPE default sysdate,
    	creation_user  	in acs_objects.creation_user%TYPE default null,
       	object_type    	in acs_object_types.object_type%TYPE default 'ctrl_event_object',
        creation_ip   	in acs_objects.creation_ip%TYPE default null,
        context_id     	in acs_objects.context_id%TYPE default null

   ) return ctrl_events_objects.event_object_id%TYPE
   is 
	v_event_object_id acs_objects.object_id%TYPE;
   begin
	v_event_object_id := acs_object.new (
	 creation_date	=> creation_date,
	 creation_user 	=> creation_user,
	 object_type   	=> object_type,
	 creation_ip	=> creation_ip,
	 context_id	=> context_id
        );
	
	insert into ctrl_events_objects
	(event_object_id, name, last_name, object_type_id, description, url)
	values
	(v_event_object_id, name, last_name, object_type_id, description, url);

	return v_event_object_id;
   end new;

   procedure del (
	event_object_id in ctrl_events_objects.event_object_id%TYPE
   )
   is 
   begin 
	acs_object.del(event_object_id);
   end del;
end ctrl_event_object;

/
show errors

commit;
