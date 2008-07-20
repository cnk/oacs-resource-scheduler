-- /packages/ctrl-events/sql/oracle/events-drop.sql
-- 
-- Drop Script for CTRL Events
-- 
-- @author avni@ctrl.ucla.edu (AK)
-- @author kellie@ctrl.ucla.edu (KL)
-- @creation-date 04/22/05
-- @cvs-id $Id: ctrl-events-drop.sql,v 1.1 2006/08/02 22:49:41 avni Exp $
--

begin
      FOR d in (select object_id from acs_objects where object_type = 'ctrl_event') LOOP
	  ctrl_events.del(d.object_id);
      END LOOP;
      acs_object_type.drop_type('ctrl_event');
end;
/
show errors

drop package ctrl_event;

@ctrl-events-tables-drop

