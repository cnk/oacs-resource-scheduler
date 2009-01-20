-- /packages/ctrl-events/sql/oracle/event-pkg-body-create.sql
--
-- Event Package Definition
-- 
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 04/15/2005
-- @cvs-id $Id: ctrl-events-pkg-body-create.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
-- 

create or replace package body ctrl_event 
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
   ) return ctrl_events.event_id%TYPE
   is 
	v_event_id acs_objects.object_id%TYPE;
   begin
	v_event_id := acs_object.new (
	  object_id	  => event_id,
	  creation_date   => creation_date,
	  creation_user	  => creation_user,
	  object_type	  => object_type,
	  creation_ip	  => creation_ip,
	  context_id	  => context_id
	);

	insert into ctrl_events 
	(event_id, event_object_id, repeat_template_id, repeat_template_p, title, speakers, start_date, end_date, all_day_p, location, notes, capacity, category_id, event_image_caption, package_id)
	values (v_event_id, event_object_id, repeat_template_id, repeat_template_p, title, speakers, start_date, end_date, all_day_p, location, notes, capacity, category_id, event_image_caption, package_id);

	return v_event_id;
   end new;
   
   procedure del (
	event_id in ctrl_events.event_id%TYPE
   )
   is 
   begin
	-- AMK temporary	          
	FOR event_rec in (select event_id from ctrl_events where repeat_template_id = del.event_id) LOOP
		ctrl_event.del(event_rec.event_id);
	END LOOP;

	FOR event_object_rec in (select event_object_id from ctrl_events_event_object_map where event_id = p_event_id LOOP
		ctrl_event_object.del(event_object_rec.event_object_id);
	END LOOP;

	delete from ctrl_events_repetitions where repeat_template_id = del.event_id;
	delete from ctrl_events_notifications where event_id = del.event_id;
	delete from ctrl_events_tasks where event_id = del.event_id;
	delete from ctrl_events_attendees where rsvp_event_id = del.event_id;
	delete from ctrl_events_rsvps where rsvp_event_id = del.event_id;
	delete from ctrl_events where event_id = del.event_id;
	acs_object.del(event_id);

   end del;
end ctrl_event;
/ 
show errors

commit;
