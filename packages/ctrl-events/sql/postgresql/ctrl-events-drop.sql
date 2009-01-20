-- /packages/ctrl-events/sql/oracle/events-drop.sql
-- 
-- Drop Script for CTRL Events
-- 
-- @creation-date 04/22/05
-- @update-date 08/16/08 (ported to postgres)
--
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @cvs-id $Id: ctrl-events-drop.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
--

select drop_package('ctrl_event_object');
select acs_object_type__drop_type('ctrl_event_object', 'f');

create function inline_0 () 
returns integer as '
declare
	object_rec		record;
begin 
	FOR object_rec in select object_id from acs_objects where object_type = ''ctrl_event'' LOOP
		PERFORM ctrl_event__delete(object_rec.object_id);
	END LOOP;
		
	return 0;

end;' language 'plpgsql';

select inline_0();
drop function inline_0();

select drop_package('ctrl_event');
select acs_object_type__drop_type('ctrl_event', 'f');	

\i ctrl-events-tables-drop.sql

