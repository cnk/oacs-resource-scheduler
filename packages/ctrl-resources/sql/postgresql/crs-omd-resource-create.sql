-- 
-- OACS Metadata for crs_resource
-- 
-- @author Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-13
-- @cvs-id $Id$
--

declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'crs_resource' ,
        pretty_name        => 'Resource',
        pretty_plural      => 'Resources',
        table_name         => 'crs_resources',
        supertype          => 'acs_object',
        id_column          => 'resource_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'parent_resource_id',
        datatype           => 'number' ,
        pretty_name        => 'Parent Resource Id',
        pretty_plural      => 'Parent Resource Ids'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'name',
        datatype           => 'string' ,
        pretty_name        => 'name pretty name',
        pretty_plural      => 'name plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'description',
        datatype           => 'string' ,
        pretty_name        => 'description pretty name',
        pretty_plural      => 'description plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'resource_category_id',
        datatype           => 'number' ,
        pretty_name        => 'resource_category_id pretty name',
        pretty_plural      => 'resource_category_id plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'owner_id',
        datatype           => 'number' ,
        pretty_name        => 'Owner Id',
        pretty_plural      => 'Owner Ids'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'enabled_p',
        datatype           => 'string' ,
        pretty_name        => 'enabled_p pretty name',
        pretty_plural      => 'enabled_p plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'quantity',
        datatype           => 'number' ,
        pretty_name        => 'Quantity',
        pretty_plural      => 'Quantity'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'services',
        datatype           => 'string' ,
        pretty_name        => 'services pretty name',
        pretty_plural      => 'services plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'property_tag',
        datatype           => 'string' ,
        pretty_name        => 'property_tag pretty name',
        pretty_plural      => 'property_tag plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_resource',
        attribute_name     => 'package_id',
        datatype           => 'number' ,
        pretty_name        => 'package_id pretty name',
        pretty_plural      => 'package_id plural pretty name'
    );
end;
/
show errors

commit;
