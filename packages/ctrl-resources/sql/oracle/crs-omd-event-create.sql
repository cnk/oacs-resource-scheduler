-- 
-- OACS Metadata for crs_event
-- 
-- @author Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-13
-- @cvs-id $Id$
--

declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'crs_event' ,
        pretty_name        => 'pretty name ',
        pretty_plural      => 'pretty plural name',
        table_name         => 'crs_events',
        supertype          => 'ctrl_event',
        id_column          => 'event_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_event',
        attribute_name     => 'request_id',
        datatype           => 'number' ,
        pretty_name        => 'request_id pretty name',
        pretty_plural      => 'request_id plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_event',
        attribute_name     => 'status',
        datatype           => 'string' ,
        pretty_name        => 'status pretty name',
        pretty_plural      => 'status plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_event',
        attribute_name     => 'reserved_by',
        datatype           => 'number' ,
        pretty_name        => 'reserved_by pretty name',
        pretty_plural      => 'reserved_by plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_event',
        attribute_name     => 'date_reserved',
        datatype           => 'date' ,
        pretty_name        => 'date_reserved pretty name',
        pretty_plural      => 'date_reserved plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_event',
        attribute_name     => 'event_code',
        datatype           => 'string' ,
        pretty_name        => 'event_code pretty name',
        pretty_plural      => 'event_code plural pretty name'
    );
end;
/
show errors
commit;
