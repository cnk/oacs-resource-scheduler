-- /web/ucla/packages/ctrl-events/sql/oracle/ctrl-events-objects-pkg-create.sql
--
-- Event Object Package
--
-- @creation-date 11/08/2006
-- @update-date 8/30/2008 (ported to postgres)
--
-- @author kellie@ctrl.ucla.edu (KL)
-- @author avni@avni.net (AK) - ported to postgres
-- @cvs-id $Id:
--

select define_function_args('ctrl_event_object__new','event_object_id;null,name,object_type_id,description;null,
	url;null,creation_date;now(),creation_user;null,object_type;ctrl_event_object,creation_ip;null,context_id;null');

create or replace function ctrl_event_object__new(integer,varchar,varchar,integer,varchar,varchar,timestamptz,integer,varchar,varchar,integer)
returns integer as '
declare
	new__event_object_id		alias for $1; 	-- default null
	new__name			alias for $2;	
        new__last_name                  alias for $3;
	new__object_type_id		alias for $4;	
	new__description		alias for $5;	
	new__url			alias for $6;
	new__creation_date		alias for $7;	-- default now()
	new__creation_user		alias for $8;
	new__object_type		alias for $9;	-- default ''ctrl_event_object''
	new__creation_ip		alias for $10;	-- default null
	new__context_id			alias for $11;	-- default null
	v_event_object_id		ctrl_events_objects.event_object_id%TYPE;
	v_object_type			acs_objects.object_type%TYPE;
begin
	IF new__object_type is null THEN
		v_object_type := ''ctrl_event_object'';
	ELSE
		v_object_type := new__event_object_id;
	END IF;

	v_event_object_id := acs_object_new (
		new__event_object_id, 
		v_object_type,
		new__creation_date,
		new__creation_user,
		new__creation_ip,
		new__conext_id
	);

	insert into ctrl_events_objects (event_object_id, name, last_name, object_type_id, description, url)
	values (v_event_object_id, name, last_name, object_type_id, description, url);

	return v_event_object_id;
end;' language 'plpgsql'; 


select define_function_args('ctrl_event_object__delete','event_object_id');

create or replace function ctrl_event_object__delete(integer)
returns integer as '
declare 
	p_event_object_id	alias for $1;
	event_object_re		record;
begin
	delete from ctrl_events_event_object_map where event_object_id = p_event_object_id;
	delete from ctrl_events_objects where event_object_id = p_event_object_id;
	PERFORM acs_object__delete(p_event_object_id);

	return 0;
end;' language 'plpgsql';


select define_function_args('ctrl_event_object__name','event_object_id');

create or replace function ctrl_event_object__name(integer)
returns varchar as '
declare
	p_event_object_id	alias for $1;
	v_event_object_name	ctrl_events_objects.name%TYPE;
begin
	select name into v_event_object_name
	from   ctrl_events_objects
	where  event_object_id = p_event_object_id;

	return v_event_object_name;

end;' language 'plpgsql';
