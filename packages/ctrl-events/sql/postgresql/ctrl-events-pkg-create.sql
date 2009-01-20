-- /packages/ctrl-events/sql/postgresql/event-pkg-create.sql
--
-- Event Package
-- 
-- @creation-date 04/15/2005
-- @update-date 08/16/2008 (ported to postgres)
--
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @cvs-id $Id: ctrl-events-pkg-create.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
-- 

select define_function_args('ctrl_event__new','event_id;null,event_object_id,repeat_template_id,repeat_template_p,title,speakers,start_date,end_date,
	all_day_p;f,location,notes;null,capacity,status;scheduled,public_p;t,approved_p;t,category_id,package_id,
	creation_date;now(),creation_user;null,object_type;ctrl_event,creation_ip;null,context_id;null');


create or replace function ctrl_event__new(integer,integer,integer,boolean,varchar,varchar,timestamptz,timestamptz,
	boolean,varchar,varchar,integer,varchar,boolean,boolean,integer,integer,
	timestamptz,integer,varchar,varchar,integer)
returns integer as '
declare
 	new__event_id              alias for $1;      	-- default null	
	new__event_object_id       alias for $2;      
	new__repeat_template_id    alias for $3;      
	new__repeat_template_p     alias for $4;      
	new__title                 alias for $5;      
	new__speakers              alias for $6;      
	new__start_date            alias for $7;      
	new__end_date              alias for $8;      
	new__all_day_p             alias for $9;      
	new__location              alias for $10;      
	new__notes                 alias for $11;      
	new__capacity              alias for $12;      
	new__status                alias for $13;   
	new__public_p              alias for $14;   
	new__approved_p            alias for $15;   
	new__category_id           alias for $16;      
	new__package_id            alias for $17;      
	new__creation_date         alias for $18;      -- default now()
	new__creation_user         alias for $19;      
	new__object_type           alias for $20;      -- default ctrl_event
	new__creation_ip           alias for $21;      
	new__context_id            alias for $22;   
	v_event_id		   ctrl_events.event_id%TYPE;
	v_object_type		   acs_objects.object_type%TYPE;
begin
	IF new__object_type is null THEN
		v_object_type := ''ctrl_event'';
	ELSE
		v_object_type := new__object_type;
	END IF;

	v_event_id := acs_object__new (
	  new__event_id,
	  v_object_type,
	  new__creation_date,
	  new__creation_user,
	  new__creation_ip,
	  new__context_id
	);

	insert into ctrl_events 
	(event_id, event_object_id, repeat_template_id, repeat_template_p, 
	 title, speakers, start_date, end_date, all_day_p, location, notes, capacity, 
	 status, public_p, approved_p, category_id, package_id)
	values (v_event_id, new__event_object_id, new__repeat_template_id, new__repeat_template_p, 
		new__title, new__speakers, new__start_date, new__end_date, new__all_day_p, new__location, new__notes, new__capacity,
		new__status, new__public_p, new__approved_p, new__category_id, new__package_id);

	return v_event_id;
end;' language 'plpgsql';


select define_function_args('ctrl_event__delete','event_id');

create or replace function ctrl_event__delete(integer)
returns integer as '
declare 
	p_event_id  		alias for $1;
	event_rec		record;
	event_object_rec 	record;
begin
	FOR event_rec in select event_id from ctrl_events where repeat_template_id = p_event_id LOOP
		PERFORM ctrl_event__delete(event_rec.event_id);
	END LOOP;

	FOR event_object_rec in select event_object_id from ctrl_events_event_object_map where event_id = p_event_id LOOP
		PERFORM ctrl_event_object__delete(event_object_rec.event_object_id);
	END LOOP;
	
	delete from ctrl_events_repetitions where repeat_template_id = p_event_id;
	delete from ctrl_events_notifications where event_id = p_event_id;
	delete from ctrl_events_tasks where event_id = p_event_id;
	delete from ctrl_events_attendees where rsvp_event_id = p_event_id;
	delete from ctrl_events_rsvps where rsvp_event_id = p_event_id;
	delete from ctrl_events where event_id = p_event_id;
	PERFORM acs_object__delete(p_event_id);

	return 0;
	
end;' language 'plpgsql';


select define_function_args('ctrl_event__title','event_id');

create or replace function ctrl_event__title(integer)
returns varchar as '
declare 
	p_event_id		alias for $1;
	v_event_title		ctrl_events.title%TYPE;
begin
	select title into v_event_title
	from ctrl_events 
	where event_id = p_event_id;

	return v_event_title;

end;' language 'plpgsql';
