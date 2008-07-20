-- 
-- OACS Metadata for crs_reservable_resource
-- 
-- @author Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-13
-- @cvs-id $Id$
--

declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'crs_reservable_resource' ,
        pretty_name        => 'Reservable Resource',
        pretty_plural      => 'Reservable Resources',
        table_name         => 'crs_reservable_resources',
        supertype          => 'crs_resource',
        id_column          => 'resource_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'how_to_reserve',
        datatype           => 'string' ,
        pretty_name        => 'how_to_reserve pretty name',
        pretty_plural      => 'how_to_reserve plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'contact_info',
        datatype           => 'string' ,
        pretty_name        => 'contact_info pretty name',
        pretty_plural      => 'contact_info plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'approval_required_p',
        datatype           => 'string' ,
        pretty_name        => 'approval_required_p pretty name',
        pretty_plural      => 'approval_required_p plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'address_id',
        datatype           => 'number' ,
        pretty_name        => 'address_id pretty name',
        pretty_plural      => 'address_id plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'department_id',
        datatype           => 'number' ,
        pretty_name        => 'department_id pretty name',
        pretty_plural      => 'department_id plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'floor',
        datatype           => 'string' ,
        pretty_name        => 'floor pretty name',
        pretty_plural      => 'floor plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'room',
        datatype           => 'string' ,
        pretty_name        => 'room pretty name',
        pretty_plural      => 'room plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_reservable_resource',
        attribute_name     => 'gis',
        datatype           => 'string' ,
        pretty_name        => 'gis pretty name',
        pretty_plural      => 'gis plural pretty name'
    );
end;
/
show errors

commit;
