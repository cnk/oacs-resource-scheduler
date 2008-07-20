-- /packages/ctrl-calendar/sql/oracle/cc-create.sql
--
-- The CTRL Calendar Package
-- UI for Displaying Events
--
-- @creation-date 4/1/2007
-- @author CTRL
-- @cvs-id $Id$
-- 

@cc-tables-create
@cc-digest-tables-create
@cc-user-profile-tables-create

declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'ctrl_calendar' ,
        pretty_name        => 'CTRL Calendar',
        pretty_plural      => 'CTRL Calendar',
        table_name         => 'ctrl_calendars',
        supertype          => 'acs_object',
        id_column          => 'cal_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_calendar',
        attribute_name     => 'cal_name',
        datatype           => 'string' ,
        pretty_name        => 'Calendar name',
        pretty_plural      => 'Calendar names'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_calendar',
        attribute_name     => 'description',
        datatype           => 'string' ,
        pretty_name        => 'description',
        pretty_plural      => 'description'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_calendar',
        attribute_name     => 'owner_id',
        datatype           => 'number' ,
        pretty_name        => 'owner id',
        pretty_plural      => 'owner id'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'ctrl_calendar',
        attribute_name     => 'object_id',
        datatype           => 'number' ,
        pretty_name        => 'object id',
        pretty_plural      => 'object id'
    );

end;
/

@@cc-pkg-create

show errors;
commit;
