-- /packages/ctrl-calendar/sql/oracle/ctrl-calendar-drop.sql

--- Code to drop the object and associated packages
drop package ctrl_calendar;
exec acs_object_type.drop_type('ctrl_calendar');
commit;  
-- /

@cc-user-profile-tables-drop
@cc-digest-tables-drop
@cc-tables-drop
