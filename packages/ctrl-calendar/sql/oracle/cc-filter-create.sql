-- /packages/ctrl-calendar/sql/oracle/cc-filter-create.sql
--
-- The CTRL Calendar Package
-- UI for Displaying Events
--
-- @creation-date 08/03/2007
-- @author CTRL
-- @cvs-id $Id$
-- 

begin 

   -- CTRL Calendar Filter
    acs_object_type.create_type (
        object_type        => 'ctrl_calendar_filter' ,
        pretty_name        => 'CTRL Calendar Filter',
        pretty_plural      => 'CTRL Calendar Filters',
        table_name         => 'ctrl_calendar_filters',
        supertype          => 'acs_object',
        id_column          => 'cal_filter_id'
    );

end;
/

show errors;
commit;
