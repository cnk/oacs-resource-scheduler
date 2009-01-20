-- 
-- OACS Metadata for crs_image
-- 
-- @author Avni Khatri (avni@ctrl.ucla.edu)
-- @creation-date 2005-12-13
-- @cvs-id $Id$
--


declare 
    attr_id  acs_attributes.attribute_id%TYPE;
begin 

    acs_object_type.create_type (
        object_type        => 'crs_image' ,
        pretty_name        => 'Resource Image',
        pretty_plural      => 'Resource Images',
        table_name         => 'crs_images',
        supertype          => 'acs_object',
        id_column          => 'image_id'
    --  other parameters below
    --  abstract_p         
    --  type_extension_table 
    --  name_method    
    );

    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_image',
        attribute_name     => 'resource_id',
        datatype           => 'number' ,
        pretty_name        => 'resource_id pretty name',
        pretty_plural      => 'resource_id plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_image',
        attribute_name     => 'image',
        datatype           => 'string' ,
        pretty_name        => 'image pretty name',
        pretty_plural      => 'image plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_image',
        attribute_name     => 'image_width',
        datatype           => 'number' ,
        pretty_name        => 'image_width pretty name',
        pretty_plural      => 'image_width plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_image',
        attribute_name     => 'image_height',
        datatype           => 'number' ,
        pretty_name        => 'image_height pretty name',
        pretty_plural      => 'image_height plural pretty name'
    );
    attr_id := acs_attribute.create_attribute (
        object_type        => 'crs_image',
        attribute_name     => 'image_file_type',
        datatype           => 'string' ,
        pretty_name        => 'image_file_type pretty name',
        pretty_plural      => 'image_file_type plural pretty name'
    );
end;
/
show errors

commit;

