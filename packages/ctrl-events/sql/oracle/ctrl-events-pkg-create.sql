-- /web/drc/packages/ctrl-events/sql/oracle/event-pkg-create.sql
--
-- Event Package Declaration
-- 
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 04/15/2005
-- @cvs-id $Id: ctrl-events-pkg-create.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
-- 

create or replace package ctrl_event 
as 
   function new (
	    event_id				in ctrl_events.event_id%TYPE,
	    event_object_id			in ctrl_events.event_object_id%TYPE,
	    repeat_template_id			in ctrl_events.repeat_template_id%TYPE,
	    repeat_template_p			in ctrl_events.repeat_template_p%TYPE,
	    title				in ctrl_events.title%TYPE,
	    speakers				in ctrl_events.speakers%TYPE,
	    start_date				in ctrl_events.start_date%TYPE,
	    end_date				in ctrl_events.end_date%TYPE,
	    all_day_p				in ctrl_events.all_day_p%TYPE,
	    location				in ctrl_events.location%TYPE,
	    notes				in ctrl_events.notes%TYPE default null,
	    capacity				in ctrl_events.capacity%TYPE,
	    category_id				in ctrl_events.category_id%TYPE,
	    event_image_caption			in ctrl_events.event_image_caption%TYPE,
	    package_id				in ctrl_events.package_id%TYPE,
	    creation_date			in acs_objects.creation_date%TYPE default sysdate,
	    creation_user			in acs_objects.creation_user%TYPE default null,
	    object_type				in acs_object_types.object_type%TYPE default 'ctrl_event',
	    creation_ip				in acs_objects.creation_ip%TYPE default null,
	    context_id				in acs_objects.context_id%TYPE default null
   ) return ctrl_events.event_id%TYPE;

   procedure del (
	     event_id in ctrl_events.event_id%TYPE
   );

end ctrl_event;
/ 
show errors
