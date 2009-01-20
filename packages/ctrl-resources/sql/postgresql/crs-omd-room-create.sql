-- 
-- OACS Metadata for crs_room
-- 
-- @author Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-13
-- @cvs-id $Id$
--

declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'crs_room' ,
        pretty_name        => 'Room',
        pretty_plural      => 'Rooms',
        table_name         => 'crs_rooms',
        supertype          => 'crs_reservable_resource',
        id_column          => 'room_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_room',
        attribute_name     => 'capacity',
        datatype           => 'number' ,
        pretty_name        => 'capacity pretty name',
        pretty_plural      => 'capacity plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_room',
        attribute_name     => 'dimensions_width',
        datatype           => 'number' ,
        pretty_name        => 'dimensions_width pretty name',
        pretty_plural      => 'dimensions_width plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_room',
        attribute_name     => 'dimensions_length',
        datatype           => 'number' ,
        pretty_name        => 'dimensions_length pretty name',
        pretty_plural      => 'dimensions_length plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_room',
        attribute_name     => 'dimensions_height',
        datatype           => 'number' ,
        pretty_name        => 'dimensions_height pretty name',
        pretty_plural      => 'dimensions_height plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_room',
        attribute_name     => 'dimensions_unit',
        datatype           => 'string' ,
        pretty_name        => 'dimensions_unit pretty name',
        pretty_plural      => 'dimensions_unit plural pretty name'
    );
end;
/
show errors

commit;
