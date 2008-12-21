-- /web/ucla/packages/ctrl-events/sql/oracle/ctrl-events-objects-pkg-create.sql
--
-- Event Package Declaration
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 11/08/2006
-- @cvs-id $Id:
--

create or replace package ctrl_event_object
as 
   function new (
	event_object_id	in ctrl_events_objects.event_object_id%TYPE,
	name		in ctrl_events_objects.name%TYPE,
        last_name       in ctrl_events_objects.last_name%TYPE,
	object_type_id	in ctrl_events_objects.object_type_id%TYPE,
	description	in ctrl_events_objects.description%TYPE,
	url		in ctrl_events_objects.url%TYPE,
	creation_date	in acs_objects.creation_date%TYPE default sysdate,
	creation_user	in acs_objects.creation_user%TYPE default null,
	object_type	in acs_object_types.object_type%TYPE default 'ctrl_event_object',
	creation_ip	in acs_objects.creation_ip%TYPE default null,
	context_id	in acs_objects.context_id%TYPE default null
   ) return ctrl_events_objects.event_object_id%TYPE;

   procedure del (
	event_object_id in ctrl_events_objects.event_object_id%TYPE
   );

end ctrl_event_object;

/
show errors
